package controller
{
	import model.proxy.ProxySessionCheck;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class CommandGetLTPAToken extends SimpleCommand
	{
		override public function execute(note:INotification):void 
		{
			var sessionProxy:ProxySessionCheck = facade.retrieveProxy(ProxySessionCheck.NAME) as ProxySessionCheck;
			sessionProxy.getLTPATokenFromServer();
		}
	}
}