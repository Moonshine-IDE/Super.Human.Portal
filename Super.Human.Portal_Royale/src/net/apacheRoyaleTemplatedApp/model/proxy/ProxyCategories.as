package model.proxy
{
	import classes.managers.ParseCentral;

	import interfaces.IDisposable;

	import model.proxy.busy.ProxyBusyManager;

	import org.apache.royale.net.events.FaultEvent;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	import services.CategoriesDelegate;
						
	public class ProxyCategories extends Proxy implements IDisposable
	{
		public static const NAME:String = "ProxyCategories";
		
		public static const NOTE_CATEGORIES_LIST_FETCHED:String = NAME + "NoteCategoriesListFetched";
		public static const NOTE_CATEGORIES_LIST_FETCHED_FETCH_FAILED:String = NAME + "NoteCategoriesListFetchFailed";
	
		private var categoriesDelegate:CategoriesDelegate;
		private var busyManagerProxy:ProxyBusyManager;
		
		public function ProxyCategories()
		{
			super(NAME);
			
			categoriesDelegate = new CategoriesDelegate();
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			busyManagerProxy = facade.retrieveProxy(ProxyBusyManager.NAME) as ProxyBusyManager;
		}
		
		public function dispose(force:Boolean):void
		{
			setData(null);
		}

		public function get categories():Array
		{
			return getData() as Array;
		}
		
		public function getCategoriesList():void
		{
			var successCallback:Function = this.busyManagerProxy.wrapSuccessFunction(onCategoriesListFetched);
			var failureCallback:Function = this.busyManagerProxy.wrapFailureFunction(onCategoriesListFetchFailed);
		
			categoriesDelegate.getCategoriesList(successCallback, failureCallback);
		}

		private function onCategoriesListFetched(event:Event):void
		{
			var fetchedData:String = event.target["data"];
			if (fetchedData)
			{
				var jsonData:Object = JSON.parse(fetchedData);
				var errorMessage:String = jsonData["errorMessage"];
				
				if (errorMessage)
				{
					sendNotification(NOTE_CATEGORIES_LIST_FETCHED_FETCH_FAILED, "Getting application's categories list failed: " + errorMessage);
				}
				else
				{
					var categories:Array = ParseCentral.parseCategoriesList(jsonData.documents);
					setData(categories);
					sendNotification(NOTE_CATEGORIES_LIST_FETCHED);
				}
			}
			else
			{
				sendNotification(NOTE_CATEGORIES_LIST_FETCHED_FETCH_FAILED, "Getting application's categories list failed.");
			}
		}
		
		private function onCategoriesListFetchFailed(event:FaultEvent):void
		{
			sendNotification(NOTE_CATEGORIES_LIST_FETCHED_FETCH_FAILED, "Getting application's categories list failed: " + event.message.toLocaleString());
		}
	}
}