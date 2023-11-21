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
		
		private var _itemsOrder:Array = [];

		public function get itemsOrder():Array
		{
			return _itemsOrder;
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
					var servers:Array = null;//ParseCentral.parseDatabases(jsonData.databases);
					
					if (servers && servers.length > 0)
					{
						this.setData(servers);
						this.parseServersToUIItems(servers);
						this.sortParsedItems();
						this.depthFirstSearch();
					}
					
					sendNotification(NOTE_SERVERS_LIST_FETCHED, menuItems);
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
						var dbPath:String = server.databasePath[i];
						var item:Object = {};
						
						var slicedIds:Array = server.databasePath.slice(0, i + 1);			
							item.id = slicedIds.join("/");
							
						var hasPathInChildrenRoot:Boolean = childrenRoot.some(function(child:String, index:int, arr:Array):Boolean {
															return child == item.id;
														});
						var hasPathInMenuItems:Boolean = menuItems.hasOwnProperty(item.id);
						if (hasPathInChildrenRoot || hasPathInMenuItems)
						{
							if (i > 0 && hasPathInMenuItems)
							{
								slicedIds = server.databasePath.slice(0, i);
								item.parent = slicedIds.join("/");
								var parentChildren:Array = menuItems[item.parent].children;
								if (!parentChildren.some(function(child:String, index:int, arr:Array):Boolean {
															return child == item.id;
														}))
								{
									menuItems[item.parent].children.push(item.id);
								}
							}
							
							continue;	
						}

						item.label = dbPath;
						item.children = [];
						if (i == 0)
						{
							item.parent = "menu";
							childrenRoot.push(item.id);
						}
						else
						{
							slicedIds = server.databasePath.slice(0, i);
							item.parent = slicedIds.join("/");
							menuItems[item.parent].children.push(item.id);
						}
	
						if (i == server.databasePath.length - 1)
						{
							item.data = server;	
						}
						
						menuItems[item.id] = item;
					}
				}
			}
		}
		
		private function sortParsedItems():void
		{		
			for each (var menuItem:Object in this.menuItems)
			{
				menuItem.children.sort(ord);
			}
		}
		
		private function depthFirstSearch():void 
		{
			var visited:Object = {};
			dfsVisit(this.menuItems["menu"], visited);
		}
		
		private function dfsVisit(item:Object, visited:Object):void 
		{
			if (visited[item.id] == true) return;
			visited[item.id] = true;
	
			itemsOrder.push(item.id);
			for each (var childId:String in item.children) 
			{
				var child:Object = this.menuItems[childId];
				dfsVisit(child, visited);
			}
		}

		private function ord(idA:String, idB:String):int 
		{
			// Nodes with children come first
			var a:Object = this.menuItems[idA];
			var b:Object = this.menuItems[idB];
			if (a.children.length > 0 && b.children.length == 0) return -1;
			if (a.children.length == 0 && b.children.length > 0) return 1;
	
			// Then sort by label
			if (a.label < b.label) return -1;
			if (a.label > b.label) return 1;
			return 0;
		}
	}
}