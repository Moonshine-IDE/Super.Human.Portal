package mediator.bookmarks
{
    import constants.ApplicationConstants;
    import constants.PopupType;

    import interfaces.IBookmarksView;

    import mediator.popup.MediatorPopup;

    import model.proxy.customBookmarks.ProxyBookmarks;
    import model.proxy.customBookmarks.ProxyBrowseMyServer;
    import model.proxy.urlParams.ProxyUrlParameters;
    import model.vo.ApplicationVO;
    import model.vo.BookmarkVO;
    import model.vo.PopupVO;

    import org.apache.royale.events.Event;
    import org.apache.royale.events.MouseEvent;
    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;

    import view.applications.ConfigurationAppDetails;
    import view.bookmarks.Bookmark;
    import view.bookmarks.event.BookmarkEvent;
    
    public class MediatorBookmarks extends Mediator implements IMediator
    {
		public static const NAME:String  = 'MediatorBookmarks';
		
		public static const BOOKMARKS_VIEW_STATE:String = "bookmarksView";
		public static const BROWSE_MY_SERVER_VIEW_STATE:String = "browseMyServerView";
		
		private var bookmarksProxy:ProxyBookmarks;
		private var urlParamsProxy:ProxyUrlParameters;
		
		public function MediatorBookmarks(mediatorName:String, component:IBookmarksView) 
		{
			super(mediatorName, component);
		}
		
		override public function onRegister():void 
		{			
			super.onRegister();
			
			this.bookmarksProxy = facade.retrieveProxy(ProxyBookmarks.NAME) as ProxyBookmarks;
			
			this.view["addEventListener"]("stateChangeComplete", onViewStateChangeComplete);
			
			if (this.bookmarksProxy.selectedGroup != "Browse My Server")
			{
				updateView();
			}
			else
			{
				this.view.currentState = this.bookmarksProxy.selectedGroup == "Browse My Server" ?
											BROWSE_MY_SERVER_VIEW_STATE : BOOKMARKS_VIEW_STATE;
			}
			
			sendNotification(ApplicationConstants.COMMAND_EXECUTE_BOOKMARKS_ROLES);
		}
		
		override public function onRemove():void 
		{			
			super.onRemove();

			facade.removeMediator(MediatorBrowseMyServer.NAME);
			this.view["removeEventListener"]("stateChangeComplete", onViewStateChangeComplete);
			if (this.view.refreshButton)
			{
				this.view.refreshButton.removeEventListener(MouseEvent.CLICK, onRefreshServersListClick);
			}
			this.view["currentState"] = BOOKMARKS_VIEW_STATE;
			
			cleanUpBookmarksList();
			this.bookmarksProxy = null;
		}
		
		
		override public function listNotificationInterests():Array 
		{
			var interests:Array = super.listNotificationInterests();
				interests.push(ApplicationConstants.NOTE_OK_POPUP + MediatorPopup.NAME + this.getMediatorName());
				interests.push(ApplicationConstants.NOTE_CANCEL_POPUP + MediatorPopup.NAME + this.getMediatorName());
				interests.push(ProxyBookmarks.NOTE_BOOKMARK_DELETE_SUCCESS);
				
			return interests;
		}
		
		override public function handleNotification(note:INotification):void 
		{
			switch (note.getName()) 
			{
				case ApplicationConstants.NOTE_OK_POPUP + MediatorPopup.NAME + this.getMediatorName():
					this.bookmarksProxy.deleteBookmark();
					break;	
				case ApplicationConstants.NOTE_CANCEL_POPUP + MediatorPopup.NAME + this.getMediatorName():
					
					break;	
				case ProxyBookmarks.NOTE_BOOKMARK_DELETE_SUCCESS:
					this.cleanUpBookmarksList();
					this.updateListOfBookmarks();
					this.bookmarksProxy.selectedBookmark = null;
					break;
				case ProxyBookmarks.NOTE_BOOKMARK_DELETE_FAILED:
					sendNotification(ApplicationConstants.COMMAND_SHOW_POPUP, new PopupVO(PopupType.ERROR, this.getMediatorName(), String(note.getBody())));
					break;
			}
		}		
		
		public function get view():IBookmarksView
		{
			return viewComponent as IBookmarksView;
		}

		private function updateView():void
		{
			if (view.currentState == BOOKMARKS_VIEW_STATE)
			{
				facade.removeMediator(MediatorBrowseMyServer.NAME);		
				if (view.refreshButton)
				{
					view.refreshButton.removeEventListener(MouseEvent.CLICK, onRefreshServersListClick);
				}
				
				view.addBookmark.addEventListener(MouseEvent.CLICK, onAddBookmarkClick);

				view.title = "Bookmarks";
				view.groupName = bookmarksProxy.selectedGroup;
				
				this.cleanUpBookmarksList();
				this.updateListOfBookmarks();
				
				sendNotification(ApplicationConstants.COMMAND_EXECUTE_ROLES);		
			}
			else if (view["currentState"] == BROWSE_MY_SERVER_VIEW_STATE)
			{
				view.addBookmark.removeEventListener(MouseEvent.CLICK, onAddBookmarkClick);
				
				view.refreshButton.addEventListener(MouseEvent.CLICK, onRefreshServersListClick);
				facade.registerMediator(new MediatorBrowseMyServer(view.browseMyServerView));
				view.title = "Browse My Server";
			}
		}

		private function updateListOfBookmarks():void
		{
			var bookmarks:Array = this.bookmarksProxy.getData() as Array;
				bookmarks = bookmarks.filter(function(b:BookmarkVO, index:int, arr:Array):Boolean{
					return b.group == bookmarksProxy.selectedGroup;	
				});
				
			for (var i:int = 0; i < bookmarks.length; i++)
			{
				var bookmark:BookmarkVO = bookmarks[i];
				var bookmarkView:Bookmark = null;
						
				if (bookmark.type == ApplicationVO.LINK_BROWSER)
				{
					bookmarkView = new Bookmark();
					bookmarkView.bookmark = bookmark;
					bookmarkView.currentState = "browser";
				}
				else if (bookmark.type == ApplicationVO.LINK_DATABASE)
				{
					bookmarkView = new Bookmark();
					bookmarkView.bookmark = bookmark;
					bookmarkView.currentState = "database";
				}
				
				bookmarkView.addEventListener("initComplete", onBookmarkInitComplete);
				bookmarkView.addEventListener(BookmarkEvent.EDIT_BOOKMARK, onModifyBookmark);
				bookmarkView.addEventListener(BookmarkEvent.DELETE_BOOKMARK, onModifyBookmark);
									
				view.bookmarksList.addElement(bookmarkView);
			}
		}

		private function cleanUpBookmarksList():void
		{
			var listCount:int = view.bookmarksList.numElements - 1;
			for (var i:int = listCount; i >= 0; i--)
			{
				var bookmarkItem:Object = view.bookmarksList.getElementAt(i);
					bookmarkItem.removeEventListener(BookmarkEvent.EDIT_BOOKMARK, onModifyBookmark);
					bookmarkItem.removeEventListener(BookmarkEvent.DELETE_BOOKMARK, onModifyBookmark);
					bookmarkItem.removeEventListener("initComplete", onBookmarkInitComplete);
					
				view.bookmarksList.removeElement(bookmarkItem);
			}
		}
		
		private function onBookmarkInitComplete(event:Event):void
		{
			var bookmarkView:Bookmark = event.currentTarget as Bookmark;
			bookmarkView.configurationDetails.openInNomad.addEventListener(MouseEvent.CLICK, onOpenNomadWeb);
		}
		
		private function onOpenNomadWeb(event:MouseEvent):void
		{
			event.preventDefault();

			var confView:ConfigurationAppDetails = event["nativeEvent"].currentTarget.royale_wrapper.parent.parent.parent as ConfigurationAppDetails;
			var selectedApp:Object = confView.data;
			sendNotification(ApplicationConstants.COMMAND_LAUNCH_NOMAD_LINK, {name: selectedApp.database, link: selectedApp.nomadURL});
		}
		
		private function onViewStateChangeComplete(event:Event):void
		{
			this.updateView();
		}

		private function onAddBookmarkClick(event:MouseEvent):void
		{
			this.bookmarksProxy.selectedBookmark = new BookmarkVO(this.bookmarksProxy.selectedGroup);
			this.bookmarksProxy.selectedBookmark.type = ApplicationVO.LINK_BROWSER;
			sendNotification(ApplicationConstants.NOTE_OPEN_ADD_EDIT_BOOKMARK);
		}
			
		private function onModifyBookmark(event:BookmarkEvent):void
		{
			this.bookmarksProxy.selectedBookmark = event.bookmark;
			if (event.type == BookmarkEvent.DELETE_BOOKMARK)
			{
				sendNotification(ApplicationConstants.COMMAND_SHOW_POPUP, new PopupVO(PopupType.QUESTION, this.getMediatorName(), 
							 "Are you sure you want to delete Bookmark " + event.bookmark.name + "?"));	
			}
			else
			{
				sendNotification(ApplicationConstants.NOTE_OPEN_ADD_EDIT_BOOKMARK);
			}
		}
		
		private function onRefreshServersListClick(event:MouseEvent):void
		{
			var browseMyServerProxy:ProxyBrowseMyServer = facade.retrieveProxy(ProxyBrowseMyServer.NAME) as ProxyBrowseMyServer;
				browseMyServerProxy.getServersList();
		}
    }
}