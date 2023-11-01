package model.proxy.customBookmarks
{
	import model.proxy.busy.ProxyBusyManager;

	import org.apache.royale.net.events.FaultEvent;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	import services.BrowseMyServerDelegate;
	import model.vo.ServerVO;
	import model.vo.ApplicationVO;
	import classes.topMenu.model.TopMenuVO;
	import classes.managers.ParseCentral;
			
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
			var successCallback:Function = this.busyManagerProxy.wrapSuccessFunction(onServersListFetched);
			var failureCallback:Function = this.busyManagerProxy.wrapFailureFunction(onServersListFetchFailed);
		
			browseMyServerDelegate.getServers(successCallback, failureCallback);
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
					var servers:Array = ParseCentral.parseDatabases(jsonData.databases);
					this.setData(servers);
					this.parseServersToUIItems(servers);
					
					sendNotification(NOTE_SERVERS_LIST_FETCHED, _menuItems);
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
		
		private function parseServersToUIItems(servers:Array):void
		{
			var serversList:Array = [];

			var childrenRoot:Array = [];
			_menuItems = {
				menu: { id: "menu", label: "Menu", hash: "", parent: null, children: childrenRoot }
			};
			
			for each (var server:ServerVO in servers)
			{
				if (server.databasePath)
				{
					for (var i:int = 0; i < server.databasePath.length; i++)
					{
						if (childrenRoot.some(function(child:String, index:int, arr:Array):Boolean {
								return child == server.databasePath[i];
							}))
						{
							continue;	
						}
						
						var item:Object = {};			
							item.id = server.databasePath[i];
							item.label = server.databasePath[i];
							item.children = [];
						if (i == 0)
						{
							item.parent = "menu";
							childrenRoot.push(server.databasePath[i]);
						}
						else
						{
							item.parent = server.databasePath[i - 1];
							menuItems[item.parent].children.push(item.id);
						}
	
						if (i == server.databasePath.length - 1)
						{
							item.data = server;	
						}
						
						menuItems[server.databasePath[i]] = item;
					}
				}
			}
		}
	}
}