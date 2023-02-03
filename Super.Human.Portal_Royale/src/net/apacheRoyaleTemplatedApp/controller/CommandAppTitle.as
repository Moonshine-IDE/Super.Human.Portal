package controller
{
	import mediator.MediatorMainContentView;

	import model.proxy.login.ProxyLogin;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class CommandAppTitle extends SimpleCommand
	{
		override public function execute(note:INotification):void 
		{
			var mainMediator:MediatorMainContentView = facade.retrieveMediator(MediatorMainContentView.NAME)
			 											as MediatorMainContentView;		
			var proxy:ProxyLogin = facade.retrieveProxy(ProxyLogin.NAME) as ProxyLogin;
			
			var element:Object = mainMediator.view["element"];
	
			if (proxy.config)
			{
				element.ownerDocument.title = proxy.config.config.ui_title;
				mainMediator.view.title = proxy.config.config.ui_title;
			}
		}
	}
}