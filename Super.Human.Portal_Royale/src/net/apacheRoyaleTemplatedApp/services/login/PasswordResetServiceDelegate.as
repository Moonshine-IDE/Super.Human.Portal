package services.login
{
	import org.apache.royale.html.Alert;
	import org.apache.royale.net.HTTPService;
	import org.apache.royale.net.events.FaultEvent;
	import org.apache.royale.net.beads.CORSCredentialsBead;

	public class PasswordResetServiceDelegate
	{
		protected var ipAddress:String;
		
		private static const API_KEY:String = "knopigan09oeiuqp09jpiog";
		private static const RECOVERY_CODE:String = "/webcm.nsf/APIGetRecoveryCode?CreateDocument";
		private static const PASSWORD_RESET:String = "/webcm.nsf/APIPasswordReset?CreateDocument";
		
		public function PasswordResetServiceDelegate(ipAddress:String) 
		{
			this.ipAddress = ipAddress;
		}
		
		public function retrieveRecoveryCode(email:String, resultCallback:Function, faultCallback:Function=null):void 
		{
			if (faultCallback == null)
			{
				faultCallback = onFault;
			}

			var urlParams:URLSearchParams = new URLSearchParams();
				urlParams.set("APIKey", API_KEY);
				urlParams.set("EmailAddress", email);
				
			var service:HTTPService = new HTTPService();
			service.addBead(new CORSCredentialsBead(true));
			service.url = this.ipAddress + RECOVERY_CODE;
			service.contentData = urlParams;
			service.method = "POST";
			service.addEventListener("complete", resultCallback);
			service.addEventListener("ioError", faultCallback);
            service.send();
		}		
		
		public function passwordReset(email:String, code:String, password:String, passwordConfirm:String, resultCallback:Function, faultCallback:Function=null):void 
		{
			if (faultCallback == null)
			{
				faultCallback = onFault;
			}
			
			var urlParams:URLSearchParams = new URLSearchParams();
				urlParams.set("APIKey", API_KEY);
				urlParams.set("EmailAddress", email);
				urlParams.set("Code", code);
				urlParams.set("Password", password);
				urlParams.set("PasswordConfirm", passwordConfirm);
				
			var service:HTTPService = new HTTPService();
			service.addBead(new CORSCredentialsBead(true));
			service.url = this.ipAddress + PASSWORD_RESET;
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