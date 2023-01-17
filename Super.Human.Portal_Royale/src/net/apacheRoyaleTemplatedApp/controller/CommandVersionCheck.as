package controller
{
	import model.proxy.ProxySessionCheck;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import model.proxy.ProxyVersion;
		
	public class CommandVersionCheck extends SimpleCommand
	{
		override public function execute(note:INotification):void 
		{
			var versionProxy:ProxyVersion = facade.retrieveProxy(ProxyVersion.NAME) as ProxyVersion;
			versionProxy.loadVersionInformation();
		}
	}
}