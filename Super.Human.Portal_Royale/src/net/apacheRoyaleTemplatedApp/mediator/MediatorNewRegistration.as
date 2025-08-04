package mediator
{
    import constants.ApplicationConstants;
    import constants.PopupType;

    import interfaces.INewRegistration;

    import mediator.popup.MediatorPopup;

    import model.proxy.ProxyPasswordStrength;
    import model.proxy.login.ProxyLogin;
    import model.proxy.login.ProxyNewRegistration;
    import model.proxy.urlParams.ProxyUrlParameters;
    import model.vo.CountriesDataModelVO;
    import model.vo.NewRegistrationVO;
    import model.vo.PopupVO;

    import org.apache.royale.collections.ArrayList;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.MouseEvent;
    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
                                                            
    public class MediatorNewRegistration extends Mediator implements IMediator
    {
		public static const NAME:String = 'MediatorNewRegistration';
		
		private var newRegistrationProxy:ProxyNewRegistration;
		private var passwordStrengthProxy:ProxyPasswordStrength;
		
		public function MediatorNewRegistration(component:INewRegistration) 
		{
			super(NAME, component);				
		}
		
		override public function onRegister():void 
		{			
			super.onRegister();

			newRegistrationProxy = facade.retrieveProxy(ProxyNewRegistration.NAME) as ProxyNewRegistration;
			newRegistrationProxy.setData(new NewRegistrationVO());
			
			passwordStrengthProxy = facade.retrieveProxy(ProxyPasswordStrength.NAME) as ProxyPasswordStrength;
			
			view.formRegister.addEventListener("valid", onFormRegisterValid);
			view.backToLogin.addEventListener(MouseEvent.CLICK, onLoginClick);
			view.newPasswordInput.addEventListener(Event.CHANGE, onNewPasswordChange);
			
			sendNotification(ApplicationConstants.NOTE_DRAWER_CLOSE);

			updateView();	
			view.updateViewInfo();
		}

		override public function onRemove():void 
		{			
			super.onRemove();
			
			view.formRegister.removeEventListener("valid", onFormRegisterValid);
			view.backToLogin.removeEventListener(MouseEvent.CLICK, onLoginClick);
			view.newPasswordInput.removeEventListener(Event.CHANGE, onNewPasswordChange);
			
			view.resetView();
			
			view.newRegistration = null;
			newRegistrationProxy.setData(null);
			
			newRegistrationProxy = null;
			passwordStrengthProxy = null;
		}	
		
		override public function listNotificationInterests():Array 
		{
			var interests:Array = super.listNotificationInterests();
				interests.push(ProxyNewRegistration.NOTE_PHONE_COUNTRIES_LIST_FETCHED);
				interests.push(ProxyNewRegistration.NOTE_PHONE_COUNTRIES_LIST_FETCH_FAILED);
				interests.push(ProxyNewRegistration.NOTE_NEWREGISTRATION_SUCCESS);
				interests.push(ProxyNewRegistration.NOTE_NEWREGISTRATION_FAILED);
				interests.push(ApplicationConstants.NOTE_OK_POPUP + MediatorPopup.NAME + this.mediatorName);
				
			return interests;
		}

		override public function handleNotification(note:INotification):void 
		{
			switch (note.getName()) 
			{
				case ProxyNewRegistration.NOTE_PHONE_COUNTRIES_LIST_FETCHED:
					var phoneCountries:ArrayList = new ArrayList([]);
					phoneCountries.addItem(new CountriesDataModelVO(-1, "-Select one-", null, null, null));
					phoneCountries.source = phoneCountries.source.concat((note.getBody().source));
					
					view.phoneCountries = phoneCountries;
					break;	
				case ProxyNewRegistration.NOTE_NEWREGISTRATION_SUCCESS:
					view.registrationFailed = false;
					view.errorMessage = null;
					showSuccessfullRegistration();
					break;
				case ProxyNewRegistration.NOTE_NEWREGISTRATION_FAILED:
				    	view.errorMessage = String(note.getBody());
					view.registrationFailed = true;
					break;
				case ApplicationConstants.NOTE_OK_POPUP + MediatorPopup.NAME + this.mediatorName:
					sendNotification(ProxyLogin.NOTE_LOGOUT_SUCCESS);
					break;
			}
		}
		
		public function get view():INewRegistration
		{
			return viewComponent as INewRegistration;
		}		
		
		private function onFormRegisterValid(event:Event):void
		{
			if (passwordStrengthProxy.valid)
			{
				newRegistrationProxy.newRegistration.typePrimaryPhone = view.dropDownTypePrimaryPhone["selectedItem"];	
				newRegistrationProxy.newRegistration.typeSecondaryPhone = view.dropDownTypeSecondaryPhone["selectedItem"];
				
				view.registrationFailed = false;
				newRegistrationProxy.register();
			}	
		}		
				
		private function onNewPasswordChange(event:Event):void
		{
			var pass:String = event.target.text;
			view.passwordStrength = passwordStrengthProxy.getPasswordStrength(pass);
			view.passwordStrengthMessage = passwordStrengthProxy.passwordMessage;
		}	

		private function onLoginClick(event:MouseEvent):void
		{
			cleanUpRegisterParams();
			
			sendNotification(ProxyLogin.NOTE_LOGOUT_SUCCESS);
		}

		private function updateView():void
		{
			newRegistrationProxy.getPhoneCountries();
			
			view.newRegistration = this.newRegistrationProxy.newRegistration;
			view.mobileType = new ArrayList(["Mobile", "Home", "Office", "VoIP", "Other"]);
			
			view.newRegistration.typePrimaryPhone = "Mobile";
			view.newRegistration.typeSecondaryPhone = "Office";
			
			this.newRegistrationProxy.generateSupportPin();
		}	

		private function showSuccessfullRegistration():void
		{
			var thanksInfo:String = "<p>Thank you for registering with Prominic.NET!</p><p>We sent an e-mail to each e-mail address you provided. Please click the confirmation links to confirm each e-mail address and finalize your registration. You must confirm at least one address before you can login.</p>";
			sendNotification(ApplicationConstants.COMMAND_SHOW_POPUP, new PopupVO(PopupType.SUCCESS, this.mediatorName, thanksInfo, "Login", null, NaN, 320));
			
			cleanUpRegisterParams();
		}

		private function cleanUpRegisterParams():void
		{
			var urlParametersProxy:ProxyUrlParameters = facade.retrieveProxy(ProxyUrlParameters.NAME) as ProxyUrlParameters;
			
			if (urlParametersProxy.isRegister)
			{
				urlParametersProxy.cleanParams();
			}
		}
    }
}
