package mediator.bookmarks
{
	import classes.breadcrump.events.BreadcrumpEvent;
	import classes.topMenu.events.TopMenuEvent;

	import constants.ApplicationConstants;
	import constants.PopupType;

	import interfaces.IBrowseMyServerView;

	import model.proxy.customBookmarks.ProxyBrowseMyServer;
	import model.vo.PopupVO;

	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
								
	public class MediatorBrowseMyServer extends Mediator implements IMediator
	{
		public static const NAME:String  = 'MediatorBrowseMyServer';

		private var browseMyServerProxy:ProxyBrowseMyServer;
		
		public function MediatorBrowseMyServer(component:IBrowseMyServerView) 
		{
			super(NAME, component);
		}
		
		override public function onRegister():void 
		{			
			super.onRegister();
			
			this.browseMyServerProxy = facade.retrieveProxy(ProxyBrowseMyServer.NAME) as ProxyBrowseMyServer;
			this.view.breadcrump.addEventListener(BreadcrumpEvent.BREADCRUMP_ITEM_CLICK, onBreadcrumpItemClick);
			this.view.topMenu.addEventListener(TopMenuEvent.MENU_ITEM_CHANGE, onTopMenuItemChange);
			
			this.browseMyServerProxy.getServersList();
			this.view.topMenu.initializeMenuModel(this.browseMyServerProxy.menuItems);
		}
		
		override public function onRemove():void 
		{			
			super.onRemove();
			
			this.view.breadcrump.removeEventListener(BreadcrumpEvent.BREADCRUMP_ITEM_CLICK, onBreadcrumpItemClick);
			this.view.topMenu.removeEventListener(TopMenuEvent.MENU_ITEM_CHANGE, onTopMenuItemChange);
			
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
					this.view.breadcrump.model = this.view.topMenu.model;
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
			this.view.breadcrump.buildBreadcrump(event.item);
		}
	}
}