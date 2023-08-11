package model.proxy.customBookmarks
{
	import classes.managers.ParseCentral;

	import constants.ApplicationConstants;

	import interfaces.IDisposable;

	import model.proxy.ProxySessionCheck;
	import model.proxy.busy.ProxyBusyManager;
	import model.vo.BookmarkVO;

	import org.apache.royale.net.events.FaultEvent;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	import services.BookmarksDelegate;
						
	public class ProxyBookmarks extends Proxy implements IDisposable
	{
		public static const NAME:String = "ProxyBookmarks";
		
		public static const NOTE_CUSTOM_BOOKMARKS_LIST_FETCHED:String = NAME + "NoteCustomBookmarksListFetched";
		public static const NOTE_CUSTOM_BOOKMARKS_LIST_FAILED:String = NAME + "NoteCustomBookmarksListFailed";
		
		public static const NOTE_BOOKMARK_DELETE_SUCCESS:String = NAME + "NoteBookmarkDeleteSuccess";
		public static const NOTE_BOOKMARK_DELETE_FAILED:String = NAME + "NoteBookmarkDeleteFailed";

		public static const NOTE_BOOKMARK_CREATE_SUCCESS:String = NAME + "NoteBookmarkCreateSuccess";
		public static const NOTE_BOOKMARK_CREATE_FAILED:String = NAME + "NoteBookmarkCreateFailed";
		
		public static const NOTE_BOOKMARK_UPDATE_SUCCESS:String = NAME + "NoteBookmarkUpdateSuccess";
		public static const NOTE_BOOKMARK_UPDATE_FAILED:String = NAME + "NoteBookmarkUpdateFailed";
		
		private var customBookmarksDelegate:BookmarksDelegate;
		private var sessionCheckProxy:ProxySessionCheck;
		private var busyManagerProxy:ProxyBusyManager;
		
		public function ProxyBookmarks()
		{
			super(NAME);
			
			customBookmarksDelegate = new BookmarksDelegate();
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
		
		private var _selectedBookmark:BookmarkVO;

		public function get selectedBookmark():BookmarkVO
		{
			return _selectedBookmark;
		}

		public function set selectedBookmark(value:BookmarkVO):void
		{
			_selectedBookmark = value;
		}
		
		private var _groups:Array = [];

		public function get groups():Array
		{
			return _groups;
		}

		public function set groups(value:Array):void
		{
			_groups = value;
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

		public function deleteBookmark():void
		{
			var successCallback:Function = this.busyManagerProxy.wrapSuccessFunction(onBookmarkDeleteSuccess);
			var failureCallback:Function = this.busyManagerProxy.wrapFailureFunction(onBookmarkDeleteFailed);
			
			customBookmarksDelegate.deleteBookmark(this.selectedBookmark.dominoUniversalID, successCallback, failureCallback);
		}
		
		public function createBookmark():void
		{
			var successCallback:Function = this.busyManagerProxy.wrapSuccessFunction(onCreateBookmarkSuccess);
			var failureCallback:Function = this.busyManagerProxy.wrapFailureFunction(onCreateBookmarkFailed);
			
			customBookmarksDelegate.createBookmark(this.selectedBookmark.toRequestObject(), successCallback, failureCallback);	
		}
		
		public function updateBookmark():void
		{
			var successCallback:Function = this.busyManagerProxy.wrapSuccessFunction(onUpdateBookmarkSuccess);
			var failureCallback:Function = this.busyManagerProxy.wrapFailureFunction(onUpdateBookmarkFailed);
			
			customBookmarksDelegate.updateBookmark(this.selectedBookmark.dominoUniversalID, this.selectedBookmark.toRequestObject(), successCallback, failureCallback);	
		}
		
		public function hasGroup(groupName:String):Boolean
		{
			return this.groups.some(function(item:Object, index:int, arr:Array):Boolean {
				return item.name == groupName;
			});
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
					sendNotification(ApplicationConstants.COMMAND_REFRESH_NAV_BOOKMARKS, bookmarks);
					sendNotification(NOTE_CUSTOM_BOOKMARKS_LIST_FETCHED);
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
		
		private function onBookmarkDeleteSuccess(event:Event):void
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
					sendNotification(NOTE_BOOKMARK_DELETE_FAILED, "Deleting Bookmark failed: " + errorMessage);
				}
				else
				{
					var bookmarks:Array = getData() as Array;
					var deleteBookmarkIndex:int = bookmarks.indexOf(this.selectedBookmark);
						bookmarks.splice(deleteBookmarkIndex, 1);
						
					sendNotification(NOTE_BOOKMARK_DELETE_SUCCESS);
				}
			}
			else
			{
				sendNotification(NOTE_BOOKMARK_DELETE_FAILED, "Deleting Bookmark failed");
			}
		}
		
		private function onBookmarkDeleteFailed(event:FaultEvent):void
		{
			sendNotification(NOTE_BOOKMARK_DELETE_FAILED, "Deleting Bookmark failed: " + event.message.toLocaleString());
		}
		
		private function onCreateBookmarkSuccess(event:Event):void
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
					sendNotification(NOTE_BOOKMARK_CREATE_FAILED, "Creating Bookmark failed: " + errorMessage);
				}
				else
				{
					sendNotification(NOTE_BOOKMARK_CREATE_SUCCESS);
				}
			}
			else
			{
				sendNotification(NOTE_BOOKMARK_CREATE_FAILED, "Creating Bookmark failed");
			}
		}
		
		private function onCreateBookmarkFailed(event:FaultEvent):void
		{
			sendNotification(NOTE_BOOKMARK_CREATE_FAILED, "Creating Bookmark failed: " + event.message.toLocaleString());
		}
		
		private function onUpdateBookmarkSuccess(event:Event):void
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
					sendNotification(NOTE_BOOKMARK_UPDATE_FAILED, "Updating Bookmark failed: " + errorMessage);
				}
				else
				{
					sendNotification(NOTE_BOOKMARK_UPDATE_SUCCESS);
				}
			}
			else
			{
				sendNotification(NOTE_BOOKMARK_UPDATE_FAILED, "Updating Bookmark failed");
			}
		}
		
		private function onUpdateBookmarkFailed(event:FaultEvent):void
		{
			sendNotification(NOTE_BOOKMARK_UPDATE_FAILED, "Updating Bookmark failed: " + event.message.toLocaleString());
		}
	}
}