package services
{	
	import org.apache.royale.html.Alert;
	import org.apache.royale.net.HTTPService;
	import org.apache.royale.net.beads.CORSCredentialsBead;
	import org.apache.royale.net.events.FaultEvent;
	import classes.managers.UrlProvider;

	public class SessionCheckDelegate
	{
		protected var ipAddress:String;
		
		public function SessionCheckDelegate(ipAddress:String)
		{
			this.ipAddress = ipAddress;
		}
		
		public function getLTPATokenFromServer(resultCallback:Function, faultCallback:Function=null):void 
		{
			if (faultCallback == null)
			{
				faultCallback = onFault;
			}
			
			var service:HTTPService = new HTTPService();
			service.addBead(new CORSCredentialsBead(true));
			service.url = UrlProvider.getInstance().serverMessage;
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