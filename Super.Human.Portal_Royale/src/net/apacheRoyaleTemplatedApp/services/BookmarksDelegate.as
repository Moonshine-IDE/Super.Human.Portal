package services
{
	import classes.managers.UrlProvider;

	import org.apache.royale.html.Alert;
	import org.apache.royale.net.HTTPService;
	import org.apache.royale.net.beads.CORSCredentialsBead;
	import org.apache.royale.net.events.FaultEvent;
	
	public class BookmarksDelegate
	{
		public function BookmarksDelegate()
		{
		}
		
		public function getCustomBookmarksList(resultCallback:Function, faultCallback:Function=null):void 
		{
			if (faultCallback == null)
			{
				faultCallback = onFault;
			}
			
			var service:HTTPService = new HTTPService();
			service.addBead(new CORSCredentialsBead(true));
			service.url = UrlProvider.getInstance().bookmarksGetAll;
			service.method = "GET";
			service.addEventListener("complete", resultCallback);
			service.addEventListener("ioError", faultCallback);
			service.send();
		}
		
		public function deleteBookmark(dominoUniversalID:String, resultCallback:Function, faultCallback:Function=null):void 
		{
			if (faultCallback == null)
			{
				faultCallback = onFault;
			}
			
			var service:HTTPService = new HTTPService();
			service.addBead(new CORSCredentialsBead(true));
			service.url = UrlProvider.getInstance().bookmarksDelete + "&DominoUniversalID=" + dominoUniversalID;
			service.method = "GET";
			service.addEventListener("complete", resultCallback);
			service.addEventListener("ioError", faultCallback);
			service.send();
		}
		
		public function createBookmark(bookmark:Object, resultCallback:Function, faultCallback:Function=null):void 
		{
			if (faultCallback == null)
			{
				faultCallback = onFault;
			}
			
			var urlParams:URLSearchParams = new URLSearchParams();
			for (var property:String in bookmark) 
			{
				urlParams.set(property, bookmark[property]);
			}
			
			var service:HTTPService = new HTTPService();
			service.addBead(new CORSCredentialsBead(true));
			service.url = UrlProvider.getInstance().bookmarksCreate;
			service.method = "POST";
			service.contentData = urlParams;
			service.addEventListener("complete", resultCallback);
			service.addEventListener("ioError", faultCallback);
			service.send();
		}
		
		public function updateBookmark(dominoUniversalID:String, bookmark:Object, resultCallback:Function, faultCallback:Function=null):void 
		{
			if (faultCallback == null)
			{
				faultCallback = onFault;
			}
			
			var urlParams:URLSearchParams = new URLSearchParams();
			for (var property:String in bookmark) 
			{
				urlParams.set(property, bookmark[property]);
			}
			
			var service:HTTPService = new HTTPService();
			service.addBead(new CORSCredentialsBead(true));
			service.url = UrlProvider.getInstance().bookmarksUpdate + "&DominoUniversalID=" + dominoUniversalID;
			service.method = "POST";
			service.contentData = urlParams;
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