package mediator.bookmarks
{
    import constants.ApplicationConstants;
    import constants.PopupType;

    import interfaces.IEditBookmarkView;

    import model.proxy.customBookmarks.ProxyBookmarks;
    import model.proxy.urlParams.ProxyUrlParameters;
    import model.vo.ApplicationVO;
    import model.vo.PopupVO;

    import org.apache.royale.events.MouseEvent;
    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;

    import view.bookmarks.event.BookmarkEvent;
    
    public class MediatorEditBookmark extends Mediator implements IMediator
    {
		public static const NAME:String  = 'MediatorEditBookmark';
		
		private var bookmarksProxy:ProxyBookmarks;
		private var urlParamsProxy:ProxyUrlParameters;
		
		public function MediatorEditBookmark(mediatorName:String, component:IEditBookmarkView) 
		{
			super(mediatorName, component);
		}
		
		override public function onRegister():void 
		{			
			super.onRegister();
			
			this.bookmarksProxy = facade.retrieveProxy(ProxyBookmarks.NAME) as ProxyBookmarks;
			
			this.view.bookmarkForm.addEventListener("valid", onBookmarkFormValid);
			this.view.cancelBookmark.addEventListener(MouseEvent.CLICK, onCancelEditBookmark);
			this.view.addEventListener(BookmarkEvent.BOOKMARK_TYPE_CHANGE, onTypeBookmarkChange);
			
			updateView();
		}
		
		override public function onRemove():void 
		{			
			super.onRemove();

			this.view.resetView();
			this.view.bookmarkForm.removeEventListener("valid", onBookmarkFormValid);
			this.view.cancelBookmark.removeEventListener(MouseEvent.CLICK, onCancelEditBookmark);
			this.bookmarksProxy.selectedBookmark = null;
			this.bookmarksProxy = null;
		}
		
		
		override public function listNotificationInterests():Array 
		{
			var interests:Array = super.listNotificationInterests();
				interests.push(ProxyBookmarks.NOTE_BOOKMARK_CREATE_SUCCESS);
				interests.push(ProxyBookmarks.NOTE_BOOKMARK_CREATE_FAILED);
				interests.push(ProxyBookmarks.NOTE_CUSTOM_BOOKMARKS_LIST_FETCHED);
				interests.push(ProxyBookmarks.NOTE_BOOKMARK_UPDATE_SUCCESS);
				interests.push(ProxyBookmarks.NOTE_BOOKMARK_UPDATE_FAILED);
				
			return interests;
		}
		
		override public function handleNotification(note:INotification):void 
		{
			switch (note.getName()) 
			{
				case ProxyBookmarks.NOTE_BOOKMARK_CREATE_SUCCESS:
					this.bookmarksProxy.getCustomBookmarksList();
					break;
				case ProxyBookmarks.NOTE_BOOKMARK_UPDATE_SUCCESS:
					if (!this.bookmarksProxy.hasGroup(this.bookmarksProxy.selectedGroup))
					{
						this.bookmarksProxy.getCustomBookmarksList();
					}
					else
					{
						sendNotification(ApplicationConstants.NOTE_OPEN_SELECTED_BOOKMARK_GROUP, this.bookmarksProxy.selectedGroup);
					}
					break;
				case ProxyBookmarks.NOTE_CUSTOM_BOOKMARKS_LIST_FETCHED:
					sendNotification(ApplicationConstants.NOTE_OPEN_SELECTED_BOOKMARK_GROUP, this.bookmarksProxy.selectedGroup);
					break;
				case ProxyBookmarks.NOTE_BOOKMARK_CREATE_FAILED:
				case ProxyBookmarks.NOTE_BOOKMARK_UPDATE_FAILED:
					sendNotification(ApplicationConstants.COMMAND_SHOW_POPUP, new PopupVO(PopupType.ERROR, this.getMediatorName(), String(note.getBody())));
					break;
			}
		}		
		
		public function get view():IEditBookmarkView
		{
			return viewComponent as IEditBookmarkView;
		}

		private function onBookmarkFormValid(event:Event):void
		{
			var groupName:String = "Default";
			if (view.groupText)
			{
				groupName = view.groupText;	
			}
			
			this.bookmarksProxy.selectedGroup = groupName;
			bookmarksProxy.selectedBookmark.group = groupName;
			bookmarksProxy.selectedBookmark.name = view.nameText;
			bookmarksProxy.selectedBookmark.type = view.selectedBookmarkType;
			bookmarksProxy.selectedBookmark.description = view.descriptionText;
			
			if (view.selectedBookmarkType == ApplicationVO.LINK_BROWSER)
			{
				bookmarksProxy.selectedBookmark.url = view.urlText;
				
				bookmarksProxy.selectedBookmark.server = "";
				bookmarksProxy.selectedBookmark.database = "";
				bookmarksProxy.selectedBookmark.view = "";
			}
			else if (view.selectedBookmarkType == ApplicationVO.LINK_DATABASE)
			{
				bookmarksProxy.selectedBookmark.server = view.serverText;
				bookmarksProxy.selectedBookmark.database = view.databaseText;
				bookmarksProxy.selectedBookmark.view = view.viewText;
				
				bookmarksProxy.selectedBookmark.url = "";			
			}

			if (bookmarksProxy.selectedBookmark.dominoUniversalID)
			{
				bookmarksProxy.updateBookmark();
			}
			else
			{
				bookmarksProxy.createBookmark();
			}
		}
		
		private function onCancelEditBookmark(event:MouseEvent):void
		{
			sendNotification(ApplicationConstants.NOTE_OPEN_SELECTED_BOOKMARK_GROUP, this.bookmarksProxy.selectedGroup);
		}
		
		private function onTypeBookmarkChange(event:BookmarkEvent):void
		{
			this.typeBookmarkChangeRefresh(event.bookmarkType);	
		}
		
		private function updateView():void
		{
			this.view.titleBookmark = bookmarksProxy.selectedBookmark.dominoUniversalID ? "Edit Bookmark" : "Add Bookmark";
			this.view.bookmark = bookmarksProxy.selectedBookmark;
			this.view.setBookmarkTypes([
				{label: "Browser", type: ApplicationVO.LINK_BROWSER, selected: this.view.bookmark.type == ApplicationVO.LINK_BROWSER},
				{label: "Database", type: ApplicationVO.LINK_DATABASE, selected: this.view.bookmark.type == ApplicationVO.LINK_DATABASE }
			]);

			this.typeBookmarkChangeRefresh(view.selectedBookmarkType);
		}

		private function typeBookmarkChangeRefresh(bookmarkType:String):void
		{
			view.currentState = bookmarkType == ApplicationVO.LINK_BROWSER ? "browser" : "database";
		}
    }
}