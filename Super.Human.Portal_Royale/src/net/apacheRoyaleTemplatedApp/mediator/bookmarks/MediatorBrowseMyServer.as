package mediator.bookmarks
{
	import classes.breadcrump.events.BreadcrumpEvent;
	import classes.topMenu.events.TopMenuEvent;

	import constants.ApplicationConstants;
	import constants.PopupType;

	import interfaces.IBrowseMyServerView;

	import model.proxy.customBookmarks.ProxyBookmarks;
	import model.proxy.customBookmarks.ProxyBrowseMyServer;
	import model.vo.BookmarkVO;
	import model.vo.PopupVO;
	import model.vo.ServerVO;

	import org.apache.royale.events.MouseEvent;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	import utils.ClipboardText;
	import model.vo.ApplicationVO;
								
	public class MediatorBrowseMyServer extends Mediator implements IMediator
	{
		public static const NAME:String  = 'MediatorBrowseMyServer';

		private var bookmarksProxy:ProxyBookmarks;
		private var browseMyServerProxy:ProxyBrowseMyServer;
		
		public function MediatorBrowseMyServer(component:IBrowseMyServerView) 
		{
			super(NAME, component);
		}
		
		override public function onRegister():void 
		{			
			super.onRegister();
			
			this.bookmarksProxy = facade.retrieveProxy(ProxyBookmarks.NAME) as ProxyBookmarks;
			this.browseMyServerProxy = facade.retrieveProxy(ProxyBrowseMyServer.NAME) as ProxyBrowseMyServer;
			this.view.breadcrump.addEventListener(BreadcrumpEvent.BREADCRUMP_ITEM_CLICK, onBreadcrumpItemClick);
			this.view.topMenu.addEventListener(TopMenuEvent.MENU_LOADED, onTopMenuItemChange);
			this.view.topMenu.addEventListener(TopMenuEvent.MENU_ITEM_CHANGE, onTopMenuItemChange);
			this.view.addBookmark.addEventListener(MouseEvent.CLICK, onAddBookmarkClick);
			this.view.copyToClipboardServer.addEventListener(MouseEvent.CLICK, onCopyToClipboardServer);
			this.view.copyToClipboardDatabase.addEventListener(MouseEvent.CLICK, onCopyToClipboardDatabase);
			this.view.copyToClipboardReplica.addEventListener(MouseEvent.CLICK, onCopyToClipboardReplica);
			
			if (!this.browseMyServerProxy.getData())
			{
				this.browseMyServerProxy.getServersList();
			}
		}
		
		override public function onRemove():void 
		{			
			super.onRemove();
			
			this.view.breadcrump.removeEventListener(BreadcrumpEvent.BREADCRUMP_ITEM_CLICK, onBreadcrumpItemClick);
			this.view.topMenu.removeEventListener(TopMenuEvent.MENU_LOADED, onTopMenuItemChange);
			this.view.topMenu.removeEventListener(TopMenuEvent.MENU_ITEM_CHANGE, onTopMenuItemChange);
			this.view.addBookmark.removeEventListener(MouseEvent.CLICK, onAddBookmarkClick);
			this.view.copyToClipboardServer.removeEventListener(MouseEvent.CLICK, onCopyToClipboardServer);
			this.view.copyToClipboardDatabase.removeEventListener(MouseEvent.CLICK, onCopyToClipboardDatabase);
			this.view.copyToClipboardReplica.removeEventListener(MouseEvent.CLICK, onCopyToClipboardReplica);
			
			this.bookmarksProxy = null;
			this.browseMyServerProxy = null;
		}	
		
		override public function listNotificationInterests():Array 
		{
			var interests:Array = super.listNotificationInterests();
				interests.push(ProxyBrowseMyServer.NOTE_SERVERS_LIST_FETCHED);
				interests.push(ProxyBrowseMyServer.NOTE_SERVERS_LIST_FETCH_FAILED);
				
			return interests;
		}
		
		override public function handleNotification(note:INotification):void {
			
			switch (note.getName()) 
			{
				case ProxyBrowseMyServer.NOTE_SERVERS_LIST_FETCHED:
					this.view.topMenu.initializeMenuModel(note.getBody());
					this.updateView();
					break;
				case ProxyBrowseMyServer.NOTE_SERVERS_LIST_FETCH_FAILED:
					sendNotification(ApplicationConstants.COMMAND_SHOW_POPUP, new PopupVO(PopupType.ERROR, this.getMediatorName(), String(note.getBody())));
					break;
			}
		}		
		
		public function get view():IBrowseMyServerView
		{
			return viewComponent as IBrowseMyServerView;
		}

		private function onBreadcrumpItemClick(event:BreadcrumpEvent):void
		{
			this.view.topMenu.navigateToItem(event.item);
		}

		private function onTopMenuItemChange(event:TopMenuEvent):void
		{
			this.view.breadcrump.model = this.view.topMenu.model;
								
			this.view.breadcrump.buildBreadcrump(event.subItem ? event.subItem : event.item);
			view.selectedItem = event.subItem ? event.subItem.data : event.item.data;
			
			this.refreshButtonLinks();
				
			view.currentState = "selectedDatabaseState";
			if (event.subItem && event.subItem.children.length >= 1)
			{
				view.currentState = "selectedFolderState";
			}
			else if (event.item && event.item.children.length >= 1 && event.subItem == null)
			{
				view.currentState = "selectedFolderState";
			}
		}

		private function onCopyToClipboardServer(event:Object):void
		{
			ClipboardText.copyToClipboard(view.selectedItem.server);
		}

		private function onCopyToClipboardDatabase(event:Object):void
		{
			ClipboardText.copyToClipboard(view.selectedItem.database);
		}

		private function onCopyToClipboardReplica(event:Object):void
		{
			ClipboardText.copyToClipboard(view.selectedItem.replicaID);
		}
		
		private function onAddBookmarkClick(event:MouseEvent):void
		{
			var bookmark:BookmarkVO = new BookmarkVO("Default");
				bookmark.name = view.selectedItem.name;
				bookmark.server = view.selectedItem.server;
				bookmark.database = view.selectedItem.database;
				bookmark.view = view.selectedItem.view;
				bookmark.url = view.selectedItem.url;
				bookmark.nomadURL = view.selectedItem.nomadURL;
				
			this.bookmarksProxy.selectedBookmark = bookmark;
			this.bookmarksProxy.selectedBookmark.type = ApplicationVO.LINK_DATABASE;
			sendNotification(ApplicationConstants.NOTE_OPEN_ADD_EDIT_BOOKMARK);
		}
		
		private function updateView():void
		{
			if (view.topMenu.selectedItem)
			{
				view.selectedItem = view.topMenu.selectedItem.data;
				this.refreshButtonLinks();
			}
		}
		
		private function refreshButtonLinks():void
		{
			if (view.selectedItem)
			{
				view.openClient.html = "<a target='_blank' href='" + view.selectedItem.url + "'>Open in Client</a>";
				view.openNomadWeb.html = "<a target='_blank' href='" + view.selectedItem.nomadURL + "'>Open in Nomad</a>";
			}
		}
	}
}