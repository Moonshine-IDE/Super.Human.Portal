package model.proxy.customBookmarks
{
	import model.proxy.busy.ProxyBusyManager;

	import org.apache.royale.net.events.FaultEvent;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	import services.BrowseMyServerDelegate;
	import model.vo.ServerVO;
	import model.vo.ApplicationVO;
	import classes.topMenu.model.TopMenuVO;
			
	public class ProxyBrowseMyServer extends Proxy
	{
		public static const NAME:String = "ProxyBrowseMyServer";

		public static const NOTE_SERVERS_LIST_FETCHED:String = NAME + "NoteServersListFetched";
		public static const NOTE_SERVERS_LIST_FETCH_FAILED:String = NAME + "NoteServersListFetchFailed";
		
		private var browseMyServerDelegate:BrowseMyServerDelegate;
		private var busyManagerProxy:ProxyBusyManager;
		
		public function ProxyBrowseMyServer()
		{
			super(NAME);
			
			browseMyServerDelegate = new BrowseMyServerDelegate();
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			busyManagerProxy = facade.retrieveProxy(ProxyBusyManager.NAME) as ProxyBusyManager;
		}
		
		private var _menuItems:Object;

		public function get menuItems():Object
		{
			return _menuItems;
		}
		
		public function getServersList():void
		{
			//var successCallback:Function = this.busyManagerProxy.wrapSuccessFunction(onServersListFetched);
			//var failureCallback:Function = this.busyManagerProxy.wrapFailureFunction(onServersListFetchFailed);
		
			//browseMyServerDelegate.getServers(successCallback, failureCallback);
			this.parseServers();
			
			sendNotification(NOTE_SERVERS_LIST_FETCHED, _menuItems);
		}
		
		private function onServersListFetched(event:Event):void
		{
			var fetchedData:String = event.target["data"];
			if (fetchedData)
			{
				var jsonData:Object = JSON.parse(fetchedData);

				var errorMessage:String = jsonData["errorMessage"];
				
				if (errorMessage)
				{
					sendNotification(NOTE_SERVERS_LIST_FETCH_FAILED, "Getting servers list failed: " + errorMessage);
				}
				else
				{
				/*	var apps:Array = ParseCentral.parseGenesisCatalogList(jsonData.apps);
					setData(apps);
					sendNotification(NOTE_GENESIS_APPS_LIST_FETCHED);
					
					var installedApps:Array = filterInstalledApps(apps);
					sendNotification(ApplicationConstants.COMMAND_REFRESH_NAV_INSTALLED_APPS, installedApps);*/
				}
			}
			else
			{
				sendNotification(NOTE_SERVERS_LIST_FETCH_FAILED, "Getting servers list failed.");
			}
		}
		
		private function onServersListFetchFailed(event:FaultEvent):void
		{
			sendNotification(NOTE_SERVERS_LIST_FETCH_FAILED, "Getting servers list failed: " + event.message.toLocaleString());
		}
		
		private function parseServers():void
		{
			var servers:Array = [
				new ServerVO("IBM Traveler", ApplicationVO.LINK_DATABASE, "demo.startcloud.com", "", "LotusTraveler.nsf"),
				new ServerVO("Oil Services Products", ApplicationVO.LINK_DATABASE, "demo.startcloud.com", "", "Clariant/MultiRegion/OLD_Products.nsf"),
				new ServerVO("RegionPatch", ApplicationVO.LINK_DATABASE, "demo.startcloud.com", "", "Clariant/Products.nsf"),
				new ServerVO("Custom Mapping Database Directory", ApplicationVO.LINK_DATABASE, "demo.startcloud.com", "", "traveler/map/custom/MapDir.nsf"),
				new ServerVO("Flex IDP Example", ApplicationVO.LINK_DATABASE, "demo.startcloud.com", "", "agentshelper.nsf"),
			]
			var serversList:Array = [];

			var childrenRoot:Array = [];
			_menuItems = {
				menu: { id: "menu", label: "Menu", hash: "", parent: null, children: childrenRoot }
			};
			
			do
			{
				var server:ServerVO = servers.pop();
				if (server.serverPath)
				{
					for (var i:int = 0; i < server.serverPath.length; i++)
					{
						if (childrenRoot.some(function(child:String, index:int, arr:Array):Boolean {
								return child == server.serverPath[i];
							}))
						{
							continue;	
						}
						
						var item:Object = {};			
							item.id = server.serverPath[i];
							item.label = server.serverPath[i];
							item.children = [];
						if (i == 0)
						{
							item.parent = "menu";
							childrenRoot.push(server.serverPath[i]);
						}
						else
						{
							item.parent = server.serverPath[i - 1];
							menuItems[item.parent].children.push(item.id);
						}
	
						if (i == server.serverPath.length - 1)
						{
							item.data = server;	
						}
						
						menuItems[server.serverPath[i]] = item;
					}
				}
				//for each (var )
				serversList.push(server);
				
			} while(servers.length > 0);
			
			this.setData(serversList);
		}
	}
}