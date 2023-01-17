package controller.startup.start
{
	import constants.ApplicationConstants;

	import model.proxy.login.ProxyLogin;
	import model.proxy.urlParams.ProxyUrlParameters;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
		
	public class CommandStartNewRegistration extends SimpleCommand
	{
		override public function execute(note:INotification):void 
		{	
			var urlParametersProxy:ProxyUrlParameters = 
				facade.retrieveProxy(ProxyUrlParameters.NAME) as ProxyUrlParameters;	
			if (urlParametersProxy.isRegister)
			{
				var loginProxy:ProxyLogin = facade.retrieveProxy(ProxyLogin.NAME) as ProxyLogin;
				loginProxy.forceLogout();
				
				sendNotification(ApplicationConstants.NOTE_OPEN_NEWREGISTRATION);
				sendNotification(ProxyLogin.NOTE_LOGOUT_SUCCESS);				
			}
		}
	}
}