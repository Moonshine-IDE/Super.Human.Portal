package services
{
	import classes.managers.UrlProvider;

	import org.apache.royale.html.Alert;
	import org.apache.royale.net.HTTPService;
	import org.apache.royale.net.beads.CORSCredentialsBead;
	import org.apache.royale.net.events.FaultEvent;
	
	public class GenesisDirsDelegate
	{
		public function GenesisDirsDelegate()
		{
		}
		
		public function getGenesisDirsList(resultCallback:Function, faultCallback:Function=null):void 
		{
			if (faultCallback == null)
			{
				faultCallback = onFault;
			}
			
			var service:HTTPService = new HTTPService();
			service.addBead(new CORSCredentialsBead(true));
			service.url = UrlProvider.getInstance().genesisDirsGetAll;
			service.method = "GET";
			service.addEventListener("complete", resultCallback);
			service.addEventListener("ioError", faultCallback);
			service.send();
		}
	
		public function createDir(directory:Object, resultCallback:Function, faultCallback:Function=null):void 
		{
			if (faultCallback == null)
			{
				faultCallback = onFault;
			}
			
			var urlParams:URLSearchParams = new URLSearchParams();
			for (var property:String in directory) 
			{
				urlParams.set(property, directory[property]);
			}
			
			var service:HTTPService = new HTTPService();
			service.addBead(new CORSCredentialsBead(true));
			service.url = UrlProvider.getInstance().genesisDirCreate;
			service.method = "POST";
			service.contentData = urlParams;
			service.addEventListener("complete", resultCallback);
			service.addEventListener("ioError", faultCallback);
			service.send();
		}
		
		public function updateGenesisDir(dominoUniversalID:String, directory:Object, resultCallback:Function, faultCallback:Function=null):void 
		{
			if (faultCallback == null)
			{
				faultCallback = onFault;
			}
			
			var urlParams:URLSearchParams = new URLSearchParams();
			for (var property:String in directory) 
			{
				urlParams.set(property, directory[property]);
			}
			
			var service:HTTPService = new HTTPService();
			service.addBead(new CORSCredentialsBead(true));
			service.url = UrlProvider.getInstance().genesisDirUpdate + "&DominoUniversalID=" + dominoUniversalID;
			service.method = "POST";
			service.contentData = urlParams;
			service.addEventListener("complete", resultCallback);
			service.addEventListener("ioError", faultCallback);
			service.send();
		}
		
		public function deleteDir(dominoUniversalID:String, resultCallback:Function, faultCallback:Function=null):void 
		{
			if (faultCallback == null)
			{
				faultCallback = onFault;
			}
			
			var service:HTTPService = new HTTPService();
			service.addBead(new CORSCredentialsBead(true));
			service.url = UrlProvider.getInstance().genesisDirDelete + "&DominoUniversalID=" + dominoUniversalID;
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