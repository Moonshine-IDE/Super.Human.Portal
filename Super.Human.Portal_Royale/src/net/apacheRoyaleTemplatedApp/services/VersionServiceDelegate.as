package services
{
	import classes.managers.UrlProvider;

	import org.apache.royale.html.Alert;
	import org.apache.royale.net.HTTPService;
	import org.apache.royale.net.events.FaultEvent;

	public class VersionServiceDelegate
	{
		public function VersionServiceDelegate() 
		{

		}
		
		public function loadLocalVersionInformation(resultCallback:Function, faultCallback:Function=null):void
		{
			if (faultCallback == null)
			{
				faultCallback = onFault;
			}
			
			var service:HTTPService = new HTTPService();
			service.url = UrlProvider.APP_LOCAL_VERSION_URL;
			service.method = "GET";
			service.addEventListener("complete", resultCallback);
			service.addEventListener("ioError", faultCallback);
			service.send();
		}
		
		public function onFault(event:FaultEvent):void {
			Alert.show(event.message.toLocaleString(), this);
		}
	}
}