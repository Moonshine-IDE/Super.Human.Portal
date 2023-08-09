package mediator.bookmarks
{
    import constants.ApplicationConstants;

    import interfaces.IEditBookmarkView;

    import model.proxy.customBookmarks.ProxyBookmarks;
    import model.proxy.urlParams.ProxyUrlParameters;
    import model.vo.ApplicationVO;

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
				
			return interests;
		}
		
		override public function handleNotification(note:INotification):void 
		{
			switch (note.getName()) 
			{
				case ProxyBookmarks.NOTE_BOOKMARK_CREATE_SUCCESS:
					this.bookmarksProxy.getCustomBookmarksList();
					break;
				case ProxyBookmarks.NOTE_BOOKMARK_CREATE_FAILED:
					
					break;
				case ProxyBookmarks.NOTE_CUSTOM_BOOKMARKS_LIST_FETCHED:
					sendNotification(ApplicationConstants.NOTE_OPEN_SELECTED_BOOKMARK_GROUP, this.bookmarksProxy.selectedGroup);
					break;
			}
		}		
		
		public function get view():IEditBookmarkView
		{
			return viewComponent as IEditBookmarkView;
		}

		private function onBookmarkFormValid(event:Event):void
		{
			bookmarksProxy.selectedBookmark.group = view.groupText;
			bookmarksProxy.selectedBookmark.name = view.nameText;
			bookmarksProxy.selectedBookmark.type = view.selectedBookmarkType;
			bookmarksProxy.selectedBookmark.url = view.urlText;
			bookmarksProxy.selectedBookmark.server = view.serverText;
			bookmarksProxy.selectedBookmark.database = view.databaseText;
			bookmarksProxy.selectedBookmark.view = view.viewText;
			
			bookmarksProxy.createBookmark();
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
				{label: "Browser", type: ApplicationVO.LINK_BROWSER, selected: true},
				{label: "Database", type: ApplicationVO.LINK_DATABASE, selected: false }
			]);

			this.typeBookmarkChangeRefresh(view.selectedBookmarkType);
		}

		private function typeBookmarkChangeRefresh(bookmarkType:String):void
		{
			view.browserFormVisible = bookmarkType == ApplicationVO.LINK_BROWSER;
			view.databaseFormVisible = bookmarkType == ApplicationVO.LINK_DATABASE;
		}
    }
}