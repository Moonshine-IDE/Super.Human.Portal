package controller.startup.prepareModel
{
	import model.proxy.ProxyCreateAccount;
	import model.proxy.ProxyPasswordStrength;
	import model.proxy.ProxySessionCheck;
	import model.proxy.ProxyVersion;
	import model.proxy.applicationsCatalog.ProxyGenesisApps;
	import model.proxy.busy.ProxyBusyManager;
	import model.proxy.login.ProxyLogin;
	import model.proxy.login.ProxyNewRegistration;
	import model.proxy.login.ProxyPasswordReset;
	import model.proxy.urlParams.ProxyUrlParameters;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import model.proxy.customBookmarks.ProxyBookmarks;
				
	public class CommandPrepareModel extends SimpleCommand
	{
		/**
		 * Register the Proxies.
		 */
		override public function execute(note:INotification):void 
		{	
			var dataUrl:String = "";
			
			facade.registerProxy(new ProxyBusyManager());
			facade.registerProxy(new ProxyVersion());

			facade.registerProxy(new ProxyUrlParameters());
			facade.registerProxy(new ProxyLogin());
			facade.registerProxy(new ProxyNewRegistration());
			facade.registerProxy(new ProxySessionCheck());
			facade.registerProxy(new ProxyPasswordReset());

			facade.registerProxy(new ProxyCreateAccount());
			
			facade.registerProxy(new ProxyPasswordStrength());
			facade.registerProxy(new ProxyGenesisApps());
			facade.registerProxy(new ProxyBookmarks());
		}
	}
}