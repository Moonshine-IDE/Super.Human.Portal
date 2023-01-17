package controller.startup.start
{
	import constants.ApplicationConstants;

	import model.proxy.login.ProxyLogin;
	import model.proxy.urlParams.ProxyUrlParameters;
	import model.vo.PasswordResetVO;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
		
	public class CommandStartPasswordReset extends SimpleCommand
	{
		override public function execute(note:INotification):void 
		{	
			var urlParametersProxy:ProxyUrlParameters = 
				facade.retrieveProxy(ProxyUrlParameters.NAME) as ProxyUrlParameters;	

			var loginProxy:ProxyLogin = facade.retrieveProxy(ProxyLogin.NAME) as ProxyLogin;
			loginProxy.forceLogout();
			
			var urlParams:Object = urlParametersProxy.getData().params;
			var passwordReset:PasswordResetVO = new PasswordResetVO(urlParams.email, urlParams.code);

			sendNotification(ApplicationConstants.NOTE_OPEN_FORGOTPASSWORD, passwordReset);
		}
	}
}