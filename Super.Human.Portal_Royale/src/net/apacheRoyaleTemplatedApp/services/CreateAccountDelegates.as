package services
{
	import classes.managers.UrlProvider;

	import org.apache.royale.html.Alert;
	import org.apache.royale.net.HTTPService;
	import org.apache.royale.net.beads.CORSCredentialsBead;
	import org.apache.royale.net.events.FaultEvent;
	
	public class CreateAccountDelegates
	{
		public function CreateAccountDelegates()
		{

		}
		
		public function submitRequest(submitObject:Object, resultCallback:Function, faultCallback:Function=null):void
		{
			if (faultCallback == null)
			{
				faultCallback = onFault;
			}
			
			var urlParams:URLSearchParams = new URLSearchParams();
			for (var property:String in submitObject) 
			{
				urlParams.set(property, submitObject[property]);
			}
			
			var service:HTTPService = new HTTPService();
			service.addBead(new CORSCredentialsBead(true));
			service.url = UrlProvider.getInstance().accountsposturl;
			service.contentData = urlParams;
			service.method = "POST";
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