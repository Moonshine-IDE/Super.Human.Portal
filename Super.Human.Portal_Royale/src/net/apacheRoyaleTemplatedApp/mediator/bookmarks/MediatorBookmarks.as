package mediator.bookmarks
{
    import constants.ApplicationConstants;
    import constants.PopupType;

    import interfaces.IBookmarksView;

    import model.proxy.customBookmarks.ProxyBookmarks;
    import model.proxy.urlParams.ProxyUrlParameters;
    import model.vo.ApplicationVO;
    import model.vo.BookmarkVO;
    import model.vo.PopupVO;

    import org.apache.royale.events.MouseEvent;
    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;

    import view.bookmarks.Bookmark;
    import view.bookmarks.event.BookmarkEvent;
    import mediator.popup.MediatorPopup;
    
    public class MediatorBookmarks extends Mediator implements IMediator
    {
		public static const NAME:String  = 'MediatorBookmarks';
		
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
			this.view.addBookmark.addEventListener(MouseEvent.CLICK, onAddBookmarkClick);
			
			updateView();
		}
		
		override public function onRemove():void 
		{			
			super.onRemove();

			this.view.addBookmark.removeEventListener(MouseEvent.CLICK, onAddBookmarkClick);
			
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
			}
		}		
		
		public function get view():IBookmarksView
		{
			return viewComponent as IBookmarksView;
		}

		private function updateView():void
		{
			view.groupName = bookmarksProxy.selectedGroup;
			
			this.cleanUpBookmarksList();
			this.updateListOfBookmarks();
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
					
				view.bookmarksList.removeElement(bookmarkItem);
			}
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
		
		private function onAddBookmarkClick(event:MouseEvent):void
		{
			this.bookmarksProxy.selectedBookmark = new BookmarkVO(this.bookmarksProxy.selectedGroup);
			sendNotification(ApplicationConstants.NOTE_OPEN_ADD_EDIT_BOOKMARK);
		}
    }
}