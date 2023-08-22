package model.proxy.applicationsCatalog
{
	import classes.managers.ParseCentral;

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
		
		public function createDir():void
		{
			var successCallback:Function = this.busyManagerProxy.wrapSuccessFunction(onCreateDirSuccess);
			var failureCallback:Function = this.busyManagerProxy.wrapFailureFunction(onCreateDirFailed);
			
			genesisPrivteDirDelegate.createDir(this.selectedDir.toRequestObject(), successCallback, failureCallback);	
		}

		public function updateDir():void
		{
			var successCallback:Function = this.busyManagerProxy.wrapSuccessFunction(onUpdateDirSuccess);
			var failureCallback:Function = this.busyManagerProxy.wrapFailureFunction(onUpdateDirFailed);
			
			genesisPrivteDirDelegate.updateGenesisDir(this.selectedDir.dominoUniversalID, this.selectedDir.toRequestObject(), successCallback, failureCallback);	
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
					var dirs:Array = ParseCentral.parseGenesisPrivDirsList(jsonData.documents);
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
		
		private function onCreateDirSuccess(event:Event):void
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
					sendNotification(NOTE_GENESIS_DIR_CREATE_FAILED, "Creating Genesis directory failed: " + errorMessage);
				}
				else
				{
					sendNotification(NOTE_GENESIS_DIR_CREATE_SUCCESS);
				}
			}
			else
			{
				sendNotification(NOTE_GENESIS_DIR_CREATE_FAILED, "Creating Genesis directory failed");
			}
		}
		
		private function onCreateDirFailed(event:FaultEvent):void
		{
			sendNotification(NOTE_GENESIS_DIR_CREATE_FAILED, "Creating Genesis directory failed: " + event.message.toLocaleString());
		}
		
		private function onUpdateDirSuccess(event:Event):void
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
					sendNotification(NOTE_GENESIS_DIR_UPDATE_FAILED, "Updating Genesis directory failed: " + errorMessage);
				}
				else
				{
					var updatedGenesisDir:Object = jsonData.document;				
					sendNotification(NOTE_GENESIS_DIR_UPDATE_SUCCESS);
				}
			}
			else
			{
				sendNotification(NOTE_GENESIS_DIR_UPDATE_FAILED, "Updating Genesis directory failed");
			}
		}
		
		private function onUpdateDirFailed(event:FaultEvent):void
		{
			sendNotification(NOTE_GENESIS_DIR_UPDATE_FAILED, "Updating Genesis directory failed: " + event.message.toLocaleString());
		}
	}
}