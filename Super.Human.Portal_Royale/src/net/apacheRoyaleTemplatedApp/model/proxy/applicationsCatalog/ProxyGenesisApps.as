package model.proxy.applicationsCatalog
{
	import classes.managers.ParseCentral;

	import constants.ApplicationConstants;

	import interfaces.IDisposable;

	import model.proxy.ProxySessionCheck;
	import model.proxy.busy.ProxyBusyManager;
	import model.vo.ApplicationVO;

	import org.apache.royale.net.events.FaultEvent;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	import services.GenesisAppsDelegate;
						
	public class ProxyGenesisApps extends Proxy implements IDisposable
	{
		public static const NAME:String = "ProxyGenesisApps";
		
		public static const NOTE_GENESIS_APPS_LIST_FETCHED:String = NAME + "NoteGenesisAppsListFetched";
		public static const NOTE_GENESIS_APPS_LIST_FETCH_FAILED:String = NAME + "NoteGenesisAppsListFetchFailed";
		
		public static const NOTE_GENESIS_APP_INSTALLED:String = NAME + "NoteGenesisAppInstalled";
		public static const NOTE_GENESIS_APPS_INSTALL_FAILED:String = NAME + "NoteGenesisAppInstallFailed";
		
		private var genesisAppsDelegate:GenesisAppsDelegate;
		private var sessionCheckProxy:ProxySessionCheck;
		private var busyManagerProxy:ProxyBusyManager;
		
		public function ProxyGenesisApps()
		{
			super(NAME);
			
			genesisAppsDelegate = new GenesisAppsDelegate();
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			busyManagerProxy = facade.retrieveProxy(ProxyBusyManager.NAME) as ProxyBusyManager;
			sessionCheckProxy = facade.retrieveProxy(ProxySessionCheck.NAME) as ProxySessionCheck;
		}
		
		public function dispose(force:Boolean):void
		{
			setData(null);
		}

		private var _selectedApplication:ApplicationVO;

		public function get selectedApplication():ApplicationVO
		{
			return _selectedApplication;
		}

		public function set selectedApplication(value:ApplicationVO):void
		{
			_selectedApplication = value;
		}

		public function getGenesisAppsList():void
		{
			var successCallback:Function = this.busyManagerProxy.wrapSuccessFunction(onGenesisAppsListFetched);
			var failureCallback:Function = this.busyManagerProxy.wrapFailureFunction(onGenesisAppsListFetchFailed);
		
			genesisAppsDelegate.getGenesisCatalogList(successCallback, onGenesisAppsListFetchFailed);
		}

		public function getInstalledApps(forceRefresh:Boolean = false):void
		{	
			if (forceRefresh)
			{
				this.setData(null);	
			}
			
			var installedApps:Array = this.getData() as Array;
			if (installedApps)
			{
				installedApps = filterInstalledApps(installedApps);
				sendNotification(ApplicationConstants.COMMAND_REFRESH_NAV_INSTALLED_APPS, installedApps);
			}
			else
			{
				var successCallback:Function = forceRefresh ? onGenesisAppsListFetched : this.busyManagerProxy.wrapSuccessFunction(onGenesisAppsListFetched);
				var failureCallback:Function = forceRefresh ? onGenesisAppsListFetchFailed : this.busyManagerProxy.wrapFailureFunction(onGenesisAppsListFetchFailed);
		
				genesisAppsDelegate.getGenesisCatalogList(successCallback, failureCallback);
			}
		}
		
		public function installApplication():void
		{			
			var failureCallback:Function = this.busyManagerProxy.wrapFailureFunction(onGenesisAppInstallFailed);
			var successCallback:Function = this.busyManagerProxy.wrapSuccessFunctionWithCustomDelay(onGenesisAppInstalled, 15000, "Installation is in progress...");

			genesisAppsDelegate.getGenesisCatalogInstall(selectedApplication.appId, successCallback, failureCallback);	
		}
		
		private function onGenesisAppsListFetched(event:Event):void
		{
			var fetchedData:String = event.target["data"];
			if (fetchedData)
			{
				var jsonData:Object = JSON.parse(fetchedData);
				if (!sessionCheckProxy.checkUserSession(jsonData))
				{
					return;
				}
				
				var errorMessage:String = jsonData["errorMessage"];
				
				if (errorMessage)
				{
					sendNotification(NOTE_GENESIS_APPS_LIST_FETCH_FAILED, "Getting Genesis applications list failed: " + errorMessage);
				}
				else
				{
					var apps:Array = ParseCentral.parseGenesisCatalogList(jsonData.apps);
					setData(apps);
					sendNotification(NOTE_GENESIS_APPS_LIST_FETCHED);
					
					var installedApps:Array = filterInstalledApps(apps);
					sendNotification(ApplicationConstants.COMMAND_REFRESH_NAV_INSTALLED_APPS, installedApps);
				}
			}
			else
			{
				sendNotification(NOTE_GENESIS_APPS_LIST_FETCH_FAILED, "Getting Genesis applications list failed.");
			}
		}
		
		private function onGenesisAppsListFetchFailed(event:FaultEvent):void
		{
			sendNotification(NOTE_GENESIS_APPS_LIST_FETCH_FAILED, "Getting Genesis applications list failed: " + event.message.toLocaleString());
		}
		
		private function onGenesisAppInstalled(event:Event):void
		{
			var fetchedData:String = event.target["data"];
			if (fetchedData)
			{
				var jsonData:Object = JSON.parse(fetchedData);
				if (!sessionCheckProxy.checkUserSession(jsonData))
				{
					return;
				}
				
				var errorMessage:String = jsonData["errorMessage"];
				
				if (!errorMessage)
				{
					sendNotification(NOTE_GENESIS_APP_INSTALLED, jsonData["successMessage"]);
				}
				else
				{
					sendNotification(NOTE_GENESIS_APPS_INSTALL_FAILED, "Installation of Genesis application failed: " + errorMessage);
				}
			}
			else
			{
				sendNotification(NOTE_GENESIS_APPS_INSTALL_FAILED, "Installation of Genesis application failed.");
			}
		}
		
		private function onGenesisAppInstallFailed(event:FaultEvent):void
		{
			sendNotification(NOTE_GENESIS_APPS_INSTALL_FAILED, "Installation of Genesis application failed: " + event.message.toLocaleString());
		}
		
		private function filterInstalledApps(apps:Array):Array
		{
			var installedApps:Array = [];
			if (apps)
			{
				installedApps = apps.filter(function(app:ApplicationVO, index:int, arr:Array):Boolean {
					return app.installed;
				});
			}	
			
			return installedApps;
		}
	}
}