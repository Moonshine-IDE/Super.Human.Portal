package services.login
{
	import org.apache.royale.html.Alert;
	import org.apache.royale.net.HTTPService;
	import org.apache.royale.net.beads.CORSCredentialsBead;
	import org.apache.royale.net.events.FaultEvent;

	public class NewRegistrationServiceDelegate
	{
		protected var ipAddress:String;

		public function NewRegistrationServiceDelegate() 
		{
		}
		
		public function register(register:Object, resultCallback:Function, faultCallback:Function=null, apiKey:String = "knopigan09oeiuqp09jpiog"):void
		{
			if (faultCallback == null)
			{
				faultCallback = onFault;
			}
			
			var urlParams:URLSearchParams = new URLSearchParams();
			
			for (var property:String in register) 
			{
				urlParams.set(property, register[property]);
			}
			
			urlParams.set("APIKey", apiKey);
			
			var service:HTTPService = new HTTPService();
			service.addBead(new CORSCredentialsBead(true));
			service.url = "/webcm.nsf/APIRegister?CreateDocument";
			service.contentData = urlParams;
			service.method = "POST";
			service.addEventListener("complete", resultCallback);
			service.addEventListener("ioError", faultCallback);
            service.send();
		}
		
		public function fetchPhoneCountries(resultCallback:Function, faultCallback:Function=null):void
		{
			var countryUrl:String = "/webcm.nsf/Countries?ReadViewEntries&Count=10000";
			
			if (faultCallback == null)
			{
				faultCallback = onFault;
			}
			
			var service:HTTPService = new HTTPService();
			service.addBead(new CORSCredentialsBead(true));
			service.url = countryUrl;
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