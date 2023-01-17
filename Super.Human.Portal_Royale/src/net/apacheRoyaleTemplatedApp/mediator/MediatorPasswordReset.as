package mediator
{
    import constants.ApplicationConstants;

    import interfaces.IPasswordReset;

    import model.proxy.ProxyPasswordStrength;
    import model.proxy.login.ProxyPasswordReset;
    import model.proxy.urlParams.ProxyUrlParameters;

    import org.apache.royale.events.Event;
    import org.apache.royale.events.MouseEvent;
    import org.apache.royale.jewel.beads.validators.FormValidator;
    import org.apache.royale.jewel.events.WizardEvent;
    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
    import model.proxy.login.ProxyLogin;
            
    public class MediatorPasswordReset extends Mediator implements IMediator
    {
		public static const NAME:String = 'MediatorPasswordReset';

		private var passwordResetProxy:ProxyPasswordReset;
		private var passwordStrengthProxy:ProxyPasswordStrength;
		
		public function MediatorPasswordReset(component:IPasswordReset) 
		{
			super(NAME, component);				
		}
		
		override public function onRegister():void 
		{			
			super.onRegister();
			
			passwordResetProxy = facade.retrieveProxy(ProxyPasswordReset.NAME) as ProxyPasswordReset;
			passwordStrengthProxy = facade.retrieveProxy(ProxyPasswordStrength.NAME) as ProxyPasswordStrength;
			
			view.newPasswordInput.addEventListener(Event.CHANGE, onNewPasswordChange);
			
			view.passwordResetModel = passwordResetProxy.passwordReset;
			
			view.nextStepLabelVisible = true;
			view.backToLoginVisible = true;
			view.formCode.addEventListener("valid", onFormCodeValid);
			view.nextStepLabel = "I already have a code";
						
			view.recoveryCode.addEventListener(MouseEvent.CLICK, onRecoveryCodeClick);
			view.nextStep.addEventListener(MouseEvent.CLICK, onNextStepClick);

			view.login.addEventListener(MouseEvent.CLICK, onLoginClick);
			view.backToLogin.addEventListener(MouseEvent.CLICK, onLoginClick);
			
			view.emailPage["showNextButton"] = view.emailPage["showPreviousButton"] = false;
			view.passwordResetPage["showNextButton"] = view.passwordResetPage["showPreviousButton"] = false;
			view.passwordResetPage["showNextButton"] = view.passwordResetPage["showPreviousButton"] = false;
			
			var passwordResetWithParams:ProxyUrlParameters = facade.retrieveProxy(ProxyUrlParameters.NAME)
																	    as ProxyUrlParameters;
			var nameOfTheNextStep:String = "emailPage";
			if (passwordResetWithParams.isPasswordReset)
			{
				nameOfTheNextStep = "passwordResetPage";
				view.nextStepLabel = "I did not get a code";
			}																
			
			var nextStep:WizardEvent = new WizardEvent(WizardEvent.REQUEST_NAVIGATE_TO_STEP, nameOfTheNextStep);
			view.emailPage.dispatchEvent(nextStep);
			
			refreshWizardSize(view.currentStep);
			
			sendNotification(ApplicationConstants.NOTE_DRAWER_CLOSE);
		}

		override public function onRemove():void 
		{			
			super.onRemove();
			
			view.formCode.removeEventListener("valid", onFormCodeValid);
			
			view.newPasswordInput.removeEventListener(Event.CHANGE, onNewPasswordChange);
			
			view.recoveryCode.removeEventListener(MouseEvent.CLICK, onRecoveryCodeClick);
			view.nextStep.removeEventListener(MouseEvent.CLICK, onNextStepClick);
			
			view.login.removeEventListener(MouseEvent.CLICK, onLoginClick);
			view.backToLogin.removeEventListener(MouseEvent.CLICK, onLoginClick);
			
			view.passwordResetModel.email = null;
			view.passwordResetModel.code = null;
			view.passwordResetModel.password = null;
			view.passwordResetModel.passwordConfirm = null;
			
			view.resetView();
			
			passwordResetProxy = null;
		}	
		
		override public function listNotificationInterests():Array 
		{
			var interests:Array = super.listNotificationInterests();
				interests.push(ProxyPasswordReset.RETRIEVE_CODE_SUCCESS);
				interests.push(ProxyPasswordReset.RETRIEVE_CODE_FAILED);
				interests.push(ProxyPasswordReset.PASSWORD_RESET_SUCCESS);
				interests.push(ProxyPasswordReset.PASSWORD_RESET_FAILED);
			
			return interests;
		}

		override public function handleNotification(note:INotification):void 
		{
			switch (note.getName()) 
			{
				case ProxyPasswordReset.RETRIEVE_CODE_SUCCESS:
					var nextStepCode:WizardEvent = new WizardEvent(WizardEvent.REQUEST_NAVIGATE_NEXT_STEP);
					view.emailPage.dispatchEvent(nextStepCode);
					refreshWizardSize(view.currentStep);
					break;	
				case ProxyPasswordReset.RETRIEVE_CODE_FAILED:
					view.emailFormError = String(note.getBody());
					break;		
				case ProxyPasswordReset.PASSWORD_RESET_SUCCESS:
					var nextStepLogin:WizardEvent = new WizardEvent(WizardEvent.REQUEST_NAVIGATE_NEXT_STEP);
					view.passwordResetPage.dispatchEvent(nextStepLogin);
					view.nextStepLabelVisible = false;
					view.backToLoginVisible = false;
					refreshWizardSize(view.currentStep);
					break;				
				case ProxyPasswordReset.PASSWORD_RESET_FAILED:
					view.codeFormError = String(note.getBody());
					break;		
			}
		}
		
		public function get view():IPasswordReset
		{
			return viewComponent as IPasswordReset;
		}		
		
		private function onRecoveryCodeClick(event:MouseEvent):void
		{
			if (isEmailFormValid())
			{
				passwordResetProxy.retrieveCode();
			}
		}
		
		private function onNextStepClick(event:MouseEvent):void
		{
			var nextStep:WizardEvent = null;
			if (view.currentStep == "emailPage")	
			{
				if (isEmailFormValid())
				{
					view.nextStepLabel = "I did not get a code";
					nextStep = new WizardEvent(WizardEvent.REQUEST_NAVIGATE_NEXT_STEP);
					view.emailPage.dispatchEvent(nextStep);
					
					refreshWizardSize(view.currentStep);
				}
			}
			else if (view.currentStep == "passwordResetPage")
			{
				view.nextStepLabel = "I already have a code";
				nextStep = new WizardEvent(WizardEvent.REQUEST_NAVIGATE_PREVIOUS_STEP);
				view.passwordResetPage.dispatchEvent(nextStep);
				
				refreshWizardSize(view.currentStep);
			}
		}		
	
		private function onFormCodeValid(event:MouseEvent):void
		{
			if (passwordStrengthProxy.valid)
			{
				if (view.newPasswordInput["text"] != view.confirmPasswordInput["text"])
				{
					view.passwordStrengthMessage = "INVALID-Confirm Password do not match";
				}
				else
				{
					passwordResetProxy.resetPassword();
				}
			}
		}
		
		private function onLoginClick(event:MouseEvent):void
		{
			var urlParametersProxy:ProxyUrlParameters = facade.retrieveProxy(ProxyUrlParameters.NAME) as ProxyUrlParameters;
			
			if (urlParametersProxy.isPasswordReset || urlParametersProxy.isForgotPassword)
			{
				urlParametersProxy.cleanParams();
			}
			
			sendNotification(ProxyLogin.NOTE_LOGOUT_SUCCESS);
			facade.removeMediator(NAME);
		}
		
		private function onNewPasswordChange(event:Event):void
		{
			var pass:String = event.target.text;
			view.passwordStrength = passwordStrengthProxy.getPasswordStrength(pass);
			view.passwordStrengthMessage = passwordStrengthProxy.passwordMessage;
		}		
		
		private function isEmailFormValid():Boolean
		{
			var formValidator:FormValidator = view.formEmail["getBeadByType"](FormValidator) as FormValidator;
			formValidator.validate();
			return !formValidator.isError;
		}

		private function refreshWizardSize(step:String):void
		{
			if (step == "passwordResetPage")
			{
				view.wizardCard.removeClass("wizardPasswordResetEmail");
				view.wizardCard.addClass("wizardPasswordReset");
			}
			else
			{
				view.wizardCard.removeClass("wizardPasswordReset");
				view.wizardCard.addClass("wizardPasswordResetEmail");
			}
		}
    }
}
