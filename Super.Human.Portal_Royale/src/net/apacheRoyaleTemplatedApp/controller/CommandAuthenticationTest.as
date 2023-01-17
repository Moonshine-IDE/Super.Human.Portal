package controller
{
	import model.proxy.login.ProxyLogin;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
		
	public class CommandAuthenticationTest extends SimpleCommand
	{
		override public function execute(note:INotification):void 
		{
			var loginProxy:ProxyLogin = facade.retrieveProxy(ProxyLogin.NAME) as ProxyLogin;
			loginProxy.testAuthentication();
		}
	}
}