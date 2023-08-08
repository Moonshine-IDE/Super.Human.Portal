package mediator.bookmarks
{
    import interfaces.IEditBookmarkView;

    import model.proxy.customBookmarks.ProxyBookmarks;
    import model.proxy.urlParams.ProxyUrlParameters;
    import model.vo.ApplicationVO;

    import org.apache.royale.collections.ArrayList;
    import org.apache.royale.events.Event;
    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
    import org.apache.royale.events.MouseEvent;
    import constants.ApplicationConstants;
    
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
			
			this.view.cancelBookmark.addEventListener(MouseEvent.CLICK, onCancelEditBookmark);
			this.view.typeBookmark.addEventListener(Event.CHANGE, onTypeBookmarkChange);
			
			updateView();
		}
		
		override public function onRemove():void 
		{			
			super.onRemove();

			this.view.cancelBookmark.removeEventListener(MouseEvent.CLICK, onCancelEditBookmark);
			this.view.typeBookmark.removeEventListener(Event.CHANGE, onTypeBookmarkChange);
			this.bookmarksProxy.selectedBookmark = null;
			this.bookmarksProxy = null;
		}
		
		
		override public function listNotificationInterests():Array 
		{
			var interests:Array = super.listNotificationInterests();
	
			return interests;
		}
		
		override public function handleNotification(note:INotification):void 
		{
			switch (note.getName()) 
			{
				
			}
		}		
		
		public function get view():IEditBookmarkView
		{
			return viewComponent as IEditBookmarkView;
		}

		private function onCancelEditBookmark(event:MouseEvent):void
		{
			sendNotification(ApplicationConstants.NOTE_OPEN_SELECTED_BOOKMARK_GROUP, this.bookmarksProxy.selectedGroup);
		}
		
		private function onTypeBookmarkChange(event:Event):void
		{
			this.typeBookmarkChangeRefresh();	
		}
		
		private function updateView():void
		{
			this.view.titleBookmark = bookmarksProxy.selectedBookmark.dominoUniversalID ? "Edit Bookmark" : "Add Bookmark";
			this.view.bookmark = bookmarksProxy.selectedBookmark;
			this.view.typeBookmark.dataProvider = new ArrayList([
				{label: "URL", type: ApplicationVO.LINK_BROWSER},
				{label: "Database", type: ApplicationVO.LINK_DATABASE }
			]);
			
			this.selectTypeBookmark(bookmarksProxy.selectedBookmark.type);
			this.typeBookmarkChangeRefresh();
		}

		private function typeBookmarkChangeRefresh():void
		{
			var selectedType:Object = this.view.typeBookmark.selectedItem;
			if (!selectedType) return;
			
			view.browserForm.visible = selectedType.type == ApplicationVO.LINK_BROWSER;
			view.databaseForm.visible = selectedType.type == ApplicationVO.LINK_DATABASE;
		}
		
		private function selectTypeBookmark(type:String):void
		{
			var selectBookmarkType:Object = null;
			for (var i:int = 0; i < this.view.typeBookmark.dataProvider.length; i++)
			{
				var bookmarkType:Object = this.view.typeBookmark.dataProvider.getItemAt(i);
				if (bookmarkType.type == type)
				{
					selectBookmarkType = bookmarkType;
					break;
				}
			}
			
			view.typeBookmark.selectedItem = selectBookmarkType;
		}
    }
}