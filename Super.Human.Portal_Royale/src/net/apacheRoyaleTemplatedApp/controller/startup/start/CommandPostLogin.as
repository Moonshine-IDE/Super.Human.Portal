package controller.startup.start
{
	import model.proxy.urlParams.ProxyUrlParameters;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import constants.ApplicationConstants;
				
	public class CommandPostLogin extends SimpleCommand
	{
		override public function execute(note:INotification):void 
		{	
			var proxyParams:ProxyUrlParameters = facade.retrieveProxy(ProxyUrlParameters.NAME) as ProxyUrlParameters;

			if (proxyParams.target == "Register") return;
			
			sendNotification(ApplicationConstants.NOTE_OPEN_VIEW_HELLO);
			sendNotification(ApplicationConstants.COMMAND_SHOW_BROWSER_WARNING);
		}
	}
}