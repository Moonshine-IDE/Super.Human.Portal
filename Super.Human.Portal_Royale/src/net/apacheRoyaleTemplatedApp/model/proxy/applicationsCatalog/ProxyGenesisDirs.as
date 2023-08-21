package model.proxy.applicationsCatalog
{
	import interfaces.IDisposable;

	import model.proxy.ProxySessionCheck;
	import model.proxy.busy.ProxyBusyManager;
	import model.vo.GenesisDirVO;

	import org.apache.royale.net.events.FaultEvent;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	import services.GenesisDirsDelegate;
						
	public class ProxyGenesisDirs extends Proxy implements IDisposable
	{
		public static const NAME:String = "ProxyGenesisDirs";
		
		public static const NOTE_GENESIS_DIRS_LIST_FETCHED:String = NAME + "NoteGenesisDirsListFetched";
		public static const NOTE_GENESIS_DIRS_LIST_FETCH_FAILED:String = NAME + "NoteGenesisDirsListFetchFailed";

		public static const NOTE_GENESIS_DIR_CREATE_SUCCESS:String = NAME + "NoteGenesisDirCreateSuccess";
		public static const NOTE_GENESIS_DIR_CREATE_FAILED:String = NAME + "NoteGenesisDirCreateFailed";
		
		public static const NOTE_GENESIS_DIR_UPDATE_SUCCESS:String = NAME + "NoteGenesisDirUpdateSuccess";
		public static const NOTE_GENESIS_DIR_UPDATE_FAILED:String = NAME + "NoteGenesisDirUpdateFailed";
		
		private var genesisPrivteDirDelegate:GenesisDirsDelegate;
		private var sessionCheckProxy:ProxySessionCheck;
		private var busyManagerProxy:ProxyBusyManager;
		
		public function ProxyGenesisDirs()
		{
			super(NAME);
			
			genesisPrivteDirDelegate = new GenesisDirsDelegate();
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

		private var _selectedDir:GenesisDirVO;

		public function get selectedDir():GenesisDirVO
		{
			return _selectedDir;
		}

		public function set selectedDir(value:GenesisDirVO):void
		{
			_selectedDir = value;
		}

		public function getDirsList():void
		{
			var successCallback:Function = this.busyManagerProxy.wrapSuccessFunction(onGenesisDirsListFetched);
			var failureCallback:Function = this.busyManagerProxy.wrapFailureFunction(onGenesisDirsListFetchFailed);
		
			genesisPrivteDirDelegate.getGenesisDirsList(successCallback, failureCallback);
		}

		private function onGenesisDirsListFetched(event:Event):void
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
					sendNotification(NOTE_GENESIS_DIRS_LIST_FETCH_FAILED, "Getting Genesis directories list failed: " + errorMessage);
				}
				else
				{
					var dirs:Array = [
						new GenesisDirVO("Local", ""),
						new GenesisDirVO("Private Remote", "https://soundcloud.com/discover")
					]
					//ParseCentral.parseGenesisPrivDirsList(jsonData.dirs);
					setData(dirs);
					sendNotification(NOTE_GENESIS_DIRS_LIST_FETCHED, dirs);
				}
			}
			else
			{
				sendNotification(NOTE_GENESIS_DIRS_LIST_FETCH_FAILED, "Getting Genesis directories list failed.");
			}
		}
		
		private function onGenesisDirsListFetchFailed(event:FaultEvent):void
		{
			sendNotification(NOTE_GENESIS_DIRS_LIST_FETCH_FAILED, "Getting Genesis directories list failed: " + event.message.toLocaleString());
		}
	}
}