package model.proxy.customBookmarks
{
	import classes.managers.ParseCentral;

	import constants.ApplicationConstants;

	import interfaces.IDisposable;

	import model.proxy.ProxySessionCheck;
	import model.proxy.busy.ProxyBusyManager;

	import org.apache.royale.net.events.FaultEvent;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	import services.CustomBookmarksDelegate;
						
	public class ProxyBookmarks extends Proxy implements IDisposable
	{
		public static const NAME:String = "ProxyBookmarks";
		
		public static const NOTE_CUSTOM_BOOKMARKS_LIST_FETCHED:String = NAME + "NoteCustomBookmarksListFetched";
		public static const NOTE_CUSTOM_BOOKMARKS_LIST_FAILED:String = NAME + "NoteCustomBookmarksListFailed";

		private var customBookmarksDelegate:CustomBookmarksDelegate;
		private var sessionCheckProxy:ProxySessionCheck;
		private var busyManagerProxy:ProxyBusyManager;
		
		public function ProxyBookmarks()
		{
			super(NAME);
			
			customBookmarksDelegate = new CustomBookmarksDelegate();
		}
		
		private var _selectedGroup:String;

		public function get selectedGroup():String
		{
			return _selectedGroup;
		}

		public function set selectedGroup(value:String):void
		{
			_selectedGroup = value;
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

		public function getCustomBookmarksList():void
		{
			var successCallback:Function = this.busyManagerProxy.wrapSuccessFunction(onCustomBookmarksListFetched);
			var failureCallback:Function = this.busyManagerProxy.wrapFailureFunction(onCustomBookmarksListFailed);
		
			customBookmarksDelegate.getCustomBookmarksList(successCallback, failureCallback);
		}

		private function onCustomBookmarksListFetched(event:Event):void
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
					sendNotification(NOTE_CUSTOM_BOOKMARKS_LIST_FAILED, "Getting custom bookmarks list failed: " + errorMessage);
				}
				else
				{
					var bookmarks:Array = ParseCentral.parseCustomBookmarksList(jsonData.documents);
					setData(bookmarks);
					sendNotification(NOTE_CUSTOM_BOOKMARKS_LIST_FETCHED);
					sendNotification(ApplicationConstants.COMMAND_REFRESH_NAV_BOOKMARKS, bookmarks);
				}
			}
			else
			{
				sendNotification(NOTE_CUSTOM_BOOKMARKS_LIST_FAILED, "Getting custom bookmarks list failed.");
			}
		}
		
		private function onCustomBookmarksListFailed(event:FaultEvent):void
		{
			sendNotification(NOTE_CUSTOM_BOOKMARKS_LIST_FAILED, "Getting custom bookmarks list failed: " + event.message.toLocaleString());
		}
	}
}