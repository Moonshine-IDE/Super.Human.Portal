package controller
{
	import model.proxy.login.ProxyLogin;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.apache.royale.utils.js.loadJavascript;
	import org.apache.royale.net.HTTPService;
	import org.apache.royale.net.beads.CORSCredentialsBead;
	import org.apache.royale.net.events.FaultEvent;
	import org.apache.royale.net.HTTPHeader;

	public class CommandLoadNomadHelper extends SimpleCommand
	{
		override public function execute(note:INotification):void 
		{
			/*window['fetch']("https://nomadweb.venus.startcloud.com/nomad/nomadhelper.js", { mode: 'cors' }).then(function(res:Object):Object {
				return {};
			}).catch(function(err:Object):void {
				
			});*/
			
			/*loadJavascript("https://nomadweb.venus.startcloud.com/nomad/nomadhelper.js", function():void {
				
			});*/
			window['openLink']("Some");
			/*var service:HTTPService = new HTTPService();
			service.addBead(new CORSCredentialsBead(true));
			service.url = "https://nomadweb.venus.startcloud.com/nomad/nomadhelper.js?openLink&link='Some'";

			service.method = "GET";
			service.addEventListener("complete", function(event:Event):void {
				var e:Event = event;
			});
			service.addEventListener("ioError", function(event:FaultEvent):void {
				var f:FaultEvent = event;
			});
			service.send();*/
		}
	}
}