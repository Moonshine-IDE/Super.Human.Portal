package services.login
{
	import classes.managers.UrlProvider;

	import org.apache.royale.html.Alert;
	import org.apache.royale.net.HTTPService;
	import org.apache.royale.net.beads.CORSCredentialsBead;
	import org.apache.royale.net.events.FaultEvent;
	import utils.UtilsCore;

	public class LoginServiceDelegate
	{
		private const LOGIN_REDIRECTION:String = "/SuperHumanPortal.nsf/XMLAuthenticationTest?OpenAgent";
		
		public function LoginServiceDelegate() 
		{
		}
		
		public function testAuthentication(resultCallback:Function, faultCallback:Function=null):void
		{
			if (faultCallback == null)
			{
				faultCallback = onFault;
			}
			
			var service:HTTPService = new HTTPService();
			service.addBead(new CORSCredentialsBead(true));
			service.url = this.LOGIN_REDIRECTION;
			service.method = "GET";
			service.addEventListener("complete", resultCallback);
			service.addEventListener("ioError", faultCallback);
            service.send();
		}
		
		public function signin(username:String, password:String, resultCallback:Function, faultCallback:Function=null):void 
		{
			if (faultCallback == null)
			{
				faultCallback = onFault;
			}
			

			var urlParams:URLSearchParams = new URLSearchParams();
				urlParams.set("redirectto", this.LOGIN_REDIRECTION);
				urlParams.set("username", username);
				urlParams.set("password", password);
			
			var service:HTTPService = new HTTPService();
			service.addBead(new CORSCredentialsBead(true));
			service.url = UrlProvider.getInstance().loginUser;
			service.contentData = urlParams;
			service.method = "POST";
			service.addEventListener("complete", resultCallback);
			service.addEventListener("ioError", faultCallback);
            service.send();
		}
		
		public function loadGeneralConfiguration(resultCallback:Function, faultCallback:Function=null):void
		{
			if (faultCallback == null)
			{
				faultCallback = onFault;
			}
			
			var service:HTTPService = new HTTPService();
			service.addBead(new CORSCredentialsBead(true));
			service.url = UrlProvider.getInstance().configagent;
			service.method = "GET";
			service.addEventListener("complete", resultCallback);
			service.addEventListener("ioError", faultCallback);
			service.send();
		}
	
		public function logout(logoutUrl:String, resultCallback:Function, faultCallback:Function=null):void
		{
			if (faultCallback == null)
			{
				faultCallback = onFault;
			}

			var urlParams:URLSearchParams = new URLSearchParams();
				urlParams.set("redirectto", this.LOGIN_REDIRECTION);
			
			var service:HTTPService = new HTTPService();
			service.addBead(new CORSCredentialsBead(true));
			service.url = logoutUrl;
			service.method = "POST";
			service.contentData = urlParams;
			service.addEventListener("complete", resultCallback);
			service.addEventListener("ioError", faultCallback);
            service.send();	
		}
		
		public function loadAccountsData(resultCallback:Function, faultCallback:Function=null):void
		{
			if (faultCallback == null)
			{
				faultCallback = onFault;
			}
			
			var service:HTTPService = new HTTPService();
			service.addBead(new CORSCredentialsBead(true));
			service.url = UrlProvider.getInstance().accountsdataurl;
			service.method = "GET";
			service.addEventListener("complete", resultCallback);
			service.addEventListener("ioError", faultCallback);
			service.send();
		}
		
		public function onFault(event:FaultEvent):void {
			Alert.show(UtilsCore.getHttpServiceFaultMessage(event), this);
		}
	}
}