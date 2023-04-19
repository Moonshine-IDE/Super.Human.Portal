package model.proxy.login
{
	import model.vo.PasswordResetVO;

	import org.apache.royale.events.Event;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	import services.login.PasswordResetServiceDelegate;
	
	public class ProxyPasswordReset extends Proxy
	{
		public static const NAME:String = "ProxyPasswordReset";
		public static const RETRIEVE_CODE_SUCCESS:String = NAME + "RetrieveCodeSuccess";
		public static const PASSWORD_RESET_SUCCESS:String = NAME + "PasswordResetSuccess";
		
		public static const RETRIEVE_CODE_FAILED:String = NAME + "RetrieveCodeFailed";
		public static const PASSWORD_RESET_FAILED:String = NAME + "PasswordResetFailed";
		
		protected var passwordResetServiceDelegate:PasswordResetServiceDelegate;

		public function ProxyPasswordReset()
		{
			super(NAME);

			passwordResetServiceDelegate = new PasswordResetServiceDelegate();
		}

		public function get passwordReset():PasswordResetVO
		{
			return getData() as PasswordResetVO;	
		}		
		
		public function retrieveCode():void
		{
			passwordResetServiceDelegate.retrieveRecoveryCode(passwordReset.email, onRetrieveCode);
		}
		
		public function resetPassword():void
		{
			passwordResetServiceDelegate.passwordReset(passwordReset.email, passwordReset.code, passwordReset.password,
			 passwordReset.passwordConfirm, onPasswordReset);	
		}		
		
		private function onRetrieveCode(event:Event):void
		{
			var updateData:String = event.target["data"];
			if (updateData)
			{
				var retrieveCodeResult:XML = new XML(updateData);
				var errorMessage:String = retrieveCodeResult["ErrorMessage"].toString();
				
				if (!errorMessage)
				{
					sendNotification(RETRIEVE_CODE_SUCCESS);
				}
				else
				{
					sendNotification(RETRIEVE_CODE_FAILED, errorMessage);
				}
			}
			else	
			{
				sendNotification(RETRIEVE_CODE_FAILED, "Resetting password failed");
			}
		}

		private function onPasswordReset(event:Event):void
		{
			var updateData:String = event.target["data"];
			if (updateData)
			{
				var passwordResetResult:XML = new XML(updateData);
				var errorMessage:String = passwordResetResult["ErrorMessage"].toString();
				
				if (!errorMessage)
				{
					sendNotification(PASSWORD_RESET_SUCCESS);
				}
				else
				{
					sendNotification(PASSWORD_RESET_FAILED, errorMessage);
				}
			}
			else
			{
				sendNotification(PASSWORD_RESET_FAILED, "Resetting password failed");
			}	
		}		
	}
}