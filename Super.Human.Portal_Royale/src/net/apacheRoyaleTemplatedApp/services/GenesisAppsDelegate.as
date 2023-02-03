package services
{
	import classes.managers.UrlProvider;

	import org.apache.royale.html.Alert;
	import org.apache.royale.net.HTTPService;
	import org.apache.royale.net.beads.CORSCredentialsBead;
	import org.apache.royale.net.events.FaultEvent;
	
	public class GenesisAppsDelegate
	{
		protected var ipAddress:String;
		
		public function GenesisAppsDelegate(ipAddress:String)
		{
			this.ipAddress = ipAddress;
		}
		
		public function getGenesisCatalogList(resultCallback:Function, faultCallback:Function=null):void 
		{
			if (faultCallback == null)
			{
				faultCallback = onFault;
			}
			
			var service:HTTPService = new HTTPService();
			service.addBead(new CORSCredentialsBead(true));
			service.url = this.ipAddress + UrlProvider.getInstance().genesisCatalogGetAll;
			service.method = "GET";
			service.addEventListener("complete", resultCallback);
			service.addEventListener("ioError", faultCallback);
			service.send();
		}
	
		public function getGenesisCatalogInstall(customerId:String, itemId:int, appId:String, resultCallback:Function, faultCallback:Function=null):void 
		{
			if (faultCallback == null)
			{
				faultCallback = onFault;
			}
			
			var service:HTTPService = new HTTPService();
			service.addBead(new CORSCredentialsBead(true));
			service.url = ""//UrlProvider.getInstance().genesisCatalogInstall +"&CustID="+ customerId +"&ItemID="+ itemId + "&AppID=" + appId;
			service.method = "GET";
			service.addEventListener("complete", resultCallback);
			service.addEventListener("ioError", faultCallback);
			service.send();
		}
		
		public function onFault(event:FaultEvent):void 
		{
			Alert.show(event.message.toLocaleString(), this);
		}
	}
}