package controller.startup.prepareModel
{
	import model.proxy.ProxyCreateAccount;
	import model.proxy.ProxyPasswordStrength;
	import model.proxy.ProxySessionCheck;
	import model.proxy.ProxyVersion;
	import model.proxy.busy.ProxyBusyManager;
	import model.proxy.login.ProxyLogin;
	import model.proxy.login.ProxyNewRegistration;
	import model.proxy.login.ProxyPasswordReset;
	import model.proxy.urlParams.ProxyUrlParameters;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
				
	public class CommandPrepareModel extends SimpleCommand
	{
		/**
		 * Register the Proxies.
		 */
		override public function execute(note:INotification):void 
		{	
			var dataUrl:String = "http://127.0.0.1:8080";
			
			facade.registerProxy(new ProxyBusyManager());
			facade.registerProxy(new ProxyVersion(dataUrl));

			facade.registerProxy(new ProxyUrlParameters());
			facade.registerProxy(new ProxyLogin(dataUrl));
			facade.registerProxy(new ProxyNewRegistration(dataUrl));
			facade.registerProxy(new ProxySessionCheck(dataUrl));
			facade.registerProxy(new ProxyPasswordReset(dataUrl));

			facade.registerProxy(new ProxyCreateAccount(dataUrl));
			
			facade.registerProxy(new ProxyPasswordStrength());
		}
	}
}