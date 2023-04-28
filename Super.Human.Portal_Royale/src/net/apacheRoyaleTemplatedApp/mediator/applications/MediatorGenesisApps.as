package mediator.applications
{
    import constants.ApplicationConstants;
    import constants.PopupType;

    import interfaces.IGenesisAppsView;

    import model.proxy.applicationsCatalog.ProxyGenesisApps;
    import model.proxy.urlParams.ProxyUrlParameters;
    import model.vo.ApplicationVO;
    import model.vo.PopupVO;

    import org.apache.royale.events.Event;
    import org.apache.royale.events.MouseEvent;
    import org.apache.royale.jewel.beads.controls.Disabled;
    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
    import classes.com.devexpress.js.dataGrid.events.DataGridEvent;
    
    public class MediatorGenesisApps extends Mediator implements IMediator
    {
		public static const NAME:String  = 'MediatorGenesisApps';
		
		private var genesisAppsProxy:ProxyGenesisApps;
		private var urlParamsProxy:ProxyUrlParameters;
		
		public function MediatorGenesisApps(component:IGenesisAppsView) 
		{
			super(NAME, component);
		}
		
		override public function onRegister():void 
		{			
			super.onRegister();
			
			view.genesisAppsList.addEventListener(DataGridEvent.SELECTION_CHANGED, onGenesisAppsListChange);
			view.installApplicationButton.addEventListener(MouseEvent.CLICK, onInstallAppClick);
			view.refreshButton.addEventListener(MouseEvent.CLICK, onRefreshButtonClick);
			
			this.genesisAppsProxy = facade.retrieveProxy(ProxyGenesisApps.NAME) as ProxyGenesisApps;
			sendNotification(ApplicationConstants.COMMAND_ADD_PROXY_FOR_DATA_DISPOSE, ProxyGenesisApps.NAME);

			this.urlParamsProxy = facade.retrieveProxy(ProxyUrlParameters.NAME) as ProxyUrlParameters;
			
			updateView();
		}
		
		override public function onRemove():void 
		{			
			super.onRemove();
			
			view.genesisAppsList.removeEventListener(DataGridEvent.SELECTION_CHANGED, onGenesisAppsListChange);
			view.installApplicationButton.removeEventListener(MouseEvent.CLICK, onInstallAppClick);
			view.refreshButton.removeEventListener(MouseEvent.CLICK, onRefreshButtonClick);
			
			sendNotification(ApplicationConstants.COMMAND_REMOVE_PROXY_DATA, ProxyGenesisApps.NAME);
			
			this.genesisAppsProxy = null;
			this.urlParamsProxy = null;
		}
		
		
		override public function listNotificationInterests():Array 
		{
			var interests:Array = super.listNotificationInterests();
			interests.push(ProxyGenesisApps.NOTE_GENESIS_APPS_LIST_FETCHED);
			interests.push(ProxyGenesisApps.NOTE_GENESIS_APPS_LIST_FETCH_FAILED);
			interests.push(ProxyGenesisApps.NOTE_GENESIS_APP_INSTALLED);
			interests.push(ProxyGenesisApps.NOTE_GENESIS_APPS_INSTALL_FAILED);
			
			return interests;
		}
		
		override public function handleNotification(note:INotification):void 
		{
			switch (note.getName()) 
			{
				case ProxyGenesisApps.NOTE_GENESIS_APPS_LIST_FETCHED:
					updateGenesisList();
					break;
				case ProxyGenesisApps.NOTE_GENESIS_APP_INSTALLED:
					view.installationResult(String(note.getBody()));
					setTimeout(function():void{
						genesisAppsProxy.getInstalledApps(true);
					}, 800);
					break;
				case ProxyGenesisApps.NOTE_GENESIS_APPS_LIST_FETCH_FAILED:
				case ProxyGenesisApps.NOTE_GENESIS_APPS_INSTALL_FAILED:
					sendNotification(ApplicationConstants.COMMAND_SHOW_POPUP, new PopupVO(PopupType.ERROR, this.mediatorName, String(note.getBody())));
					break;
			}
		}		
		
		public function get view():IGenesisAppsView
		{
			return viewComponent as IGenesisAppsView;
		}

		private function updateSelectedAppToProxy(selectedItem:Object):void
		{
			var selectedApp:ApplicationVO = selectedItem as ApplicationVO;
			genesisAppsProxy.selectedApplication = selectedApp;
		}
		
		private function updateView():void
		{
			view.learnMore["html"] = "<a href='http://genesis.directory/articles/what-is-genesis' target='_blank'>Learn More</a>";
			view.selectedApp = "Select an application from the list below";
			
			if (!genesisAppsProxy.getData())
			{
				genesisAppsProxy.getGenesisAppsList();
			}
			else
			{
				updateGenesisList();
			}
		}
		
		private function updateGenesisList():void
		{
			view.genesisAppsDataProvider = genesisAppsProxy.getData() as Array;
			refreshInstallButtonState();
			refreshSeeMoreDetails();
		}

		private function refreshInstallButtonState():void
		{
			var disabled:Disabled = view.installApplicationButton["getBeadByType"](Disabled);
			disabled.disabled = genesisAppsProxy.selectedApplication == null;
		}
		
		private function refreshSeeMoreDetails():void
		{
			var disabled:Disabled = view.seeMoreDetails["getBeadByType"](Disabled);
			disabled.disabled = genesisAppsProxy.selectedApplication == null;	
			
			if (genesisAppsProxy.selectedApplication)
			{
				view.seeMoreDetails["html"] = '<a height="100%" href="' + genesisAppsProxy.selectedApplication.detailsUrl + '" target="_blank">App details</a>';
			}
			else
			{
				view.seeMoreDetails["html"] = "";
				view.seeMoreDetails["text"] = "App details";
			}
		}
		
		private function onGenesisAppsListChange(event:DataGridEvent):void
		{
			view.selectedApp = event.item ? event.item.label : "";
			
			updateSelectedAppToProxy(event.item);
			refreshInstallButtonState();
			refreshSeeMoreDetails();
		}

		private function onInstallAppClick(event:Event):void
		{
			genesisAppsProxy.installApplication();
		}

		private function onRefreshButtonClick(event:Event):void
		{
			genesisAppsProxy.getGenesisAppsList();
		}	
    }
}