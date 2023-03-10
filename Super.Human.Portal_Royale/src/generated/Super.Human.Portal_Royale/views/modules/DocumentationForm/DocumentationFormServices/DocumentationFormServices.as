package Super.Human.Portal_Royale.views.modules.DocumentationForm.DocumentationFormServices
{
	import Super.Human.Portal_Royale.classes.vo.Constants;
	import org.apache.royale.net.HTTPService;
	import org.apache.royale.net.beads.CORSCredentialsBead;
	import org.apache.royale.net.events.FaultEvent;
    import org.apache.royale.jewel.Snackbar;
	
	public class DocumentationFormServices
	{
		public static const LISTING_AGENT:String = "/DocumentationFormRead?OpenAgent";
		public static const ADD_AGENT:String = "/DocumentationFormCreate?OpenAgent";
		public static const EDIT_AGENT:String = "/DocumentationFormUpdate?OpenAgent";
		public static const REMOVE_AGENT:String = "/DocumentationFormDelete?OpenAgent";
		
		public function DocumentationFormServices()
		{
		}
		
		public function getDocumentationFormList(resultCallback:Function, faultCallback:Function=null):void
		{
			if (faultCallback == null)
			{
				faultCallback = onFault;
			}
			
			var service:HTTPService = new HTTPService();
			service.addBead(new CORSCredentialsBead(true));
			service.url = Constants.AGENT_BASE_URL + LISTING_AGENT;
			service.method = "GET";
			service.addEventListener("complete", resultCallback);
			service.addEventListener("ioError", faultCallback);
			service.send();
		}
		
		public function addNewDocumentationForm(submitObject:Object, resultCallback:Function, faultCallback:Function=null):void 
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
			service.url = Constants.AGENT_BASE_URL + ADD_AGENT;
			service.contentData = urlParams;
			service.method = "POST";
			service.addEventListener("complete", resultCallback);
			service.addEventListener("ioError", faultCallback);
			service.send();
		}

		public function updateDocumentationForm(submitObject:Object, resultCallback:Function, faultCallback:Function=null):void
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
            service.url = Constants.AGENT_BASE_URL + EDIT_AGENT;
            service.contentData = urlParams;
            service.method = "POST";
            service.addEventListener("complete", resultCallback);
            service.addEventListener("ioError", faultCallback);
            service.send();
        }

		public function removeDocumentationForm(submitObject:Object, resultCallback:Function, faultCallback:Function=null):void
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
            service.url = Constants.AGENT_BASE_URL + REMOVE_AGENT;
            service.contentData = urlParams;
            service.method = "POST";
            service.addEventListener("complete", resultCallback);
            service.addEventListener("ioError", faultCallback);
            service.send();
        }
		
		public function onFault(event:FaultEvent):void 
		{
			Snackbar.show(event.message.toLocaleString(), 4000, null);
		}
	}
}