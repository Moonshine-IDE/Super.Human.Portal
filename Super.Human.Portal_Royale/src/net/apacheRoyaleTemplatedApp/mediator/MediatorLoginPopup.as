package mediator
{
    import constants.ApplicationConstants;

    import interfaces.ILoginView;

    import model.proxy.login.ProxyLogin;
    import model.vo.PasswordResetVO;

    import org.apache.royale.events.Event;
    import org.apache.royale.events.MouseEvent;
    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
    
    public class MediatorLoginPopup extends Mediator implements IMediator
    {
		public static const NAME:String = 'MediatorLoginPopup';

		private var loginProxy:ProxyLogin;
		private var forceShow:Boolean;

		public function MediatorLoginPopup(component:ILoginView, forceShow:Boolean = false) 
		{
			super(NAME, component);		
			
			this.forceShow = forceShow;		
		}
		
		override public function onRegister():void 
		{			
			super.onRegister();

			view.usernameText.addEventListener(Event.CHANGE, onTextChange);
			view.passwordText.addEventListener(Event.CHANGE, onTextChange);
			view.usernameText["element"].addEventListener("keypress", onTextKeyDown);
			view.passwordText["element"].addEventListener("keypress", onTextKeyDown);
			
			view.forgotPassword.addEventListener(MouseEvent.CLICK, onForgotPassword);
			view.newRegistration.addEventListener(MouseEvent.CLICK, onNewRegistration);
			
			loginProxy = facade.retrieveProxy(ProxyLogin.NAME) as ProxyLogin;
				
			view["visible"] = this.forceShow;
			view.resetView();
			this.refreshLoginState(null);
		}

		override public function onRemove():void 
		{			
			super.onRemove();
			
			view.form.removeEventListener("valid", onFormValid);
			view.usernameText.removeEventListener(Event.CHANGE, onTextChange);
			view.passwordText.removeEventListener(Event.CHANGE, onTextChange);
			view.usernameText["element"].removeEventListener("keypress", onTextKeyDown);
			view.passwordText["element"].removeEventListener("keypress", onTextKeyDown);
			
			view.forgotPassword.removeEventListener(MouseEvent.CLICK, onForgotPassword);
			view.newRegistration.removeEventListener(MouseEvent.CLICK, onNewRegistration);
			
			facade.removeMediator(MediatorNewRegistration.NAME);
			
			loginProxy = null;
		}	
		
		override public function listNotificationInterests():Array 
		{
			var interests:Array = super.listNotificationInterests();
			interests.push(ProxyLogin.NOTE_LOGIN_SUCCESS);
			interests.push(ProxyLogin.NOTE_LOGIN_FAILED);
			interests.push(ProxyLogin.NOTE_LOGOUT_SUCCESS);
			interests.push(ProxyLogin.NOTE_ANONYMOUS_USER);
			interests.push(ProxyLogin.NOTE_ACCOUNTS_LOAD_FAILED);
			
			return interests;
		}

		override public function handleNotification(note:INotification):void 
		{
			switch (note.getName()) 
			{
				case ProxyLogin.NOTE_LOGIN_SUCCESS:
					view.errorMessage = null;
					view.loginFailed = false;
					view.loginBusyOperator.hideBusy();
					break;	
				case ProxyLogin.NOTE_LOGIN_FAILED:
				case ProxyLogin.NOTE_ACCOUNTS_LOAD_FAILED:
					view["visible"] = true;
					view.errorMessage = String(note.getBody());
					view.loginFailed = true;
					view.loginBusyOperator.hideBusy();
					break;
				case ProxyLogin.NOTE_ANONYMOUS_USER:
					sendNotification(ProxyLogin.NOTE_LOGOUT_SUCCESS);
					sendNotification(ApplicationConstants.COMMAND_LOGOUT_CLEANUP);
					
					refreshLoginState(note.getBody());
					break;
				case ProxyLogin.NOTE_LOGOUT_SUCCESS:
					view["visible"] = true;
					view.resetView();
					refreshLoginState(note.getBody());
					break;					
			}
		}

		public function get view():ILoginView
		{
			return viewComponent as ILoginView;
		}
		
		private function onFormValid(event:Event):void
		{
			view.loginBusyOperator.showBusy();
			loginProxy.signin(view.username, view.password);
		}
		
		private function onTextChange(event:Event):void
		{
			view.loginFailed = false;	
		}		
		
		private function onTextKeyDown(event:Event):void
		{
			if (event["keyCode"] == 13)
			{
				view.loginFailed = false;
				view.formValidator.validate();
			}
		}
			
		private function onForgotPassword(event:MouseEvent):void
		{
			sendNotification(ApplicationConstants.NOTE_OPEN_FORGOTPASSWORD, new PasswordResetVO());
		}
		
		private function onNewRegistration(event:MouseEvent):void
		{
			sendNotification(ApplicationConstants.NOTE_OPEN_NEWREGISTRATION);
		}				

		private function onRefreshPageClick(event:MouseEvent):void
		{
			location.reload();	
		}
		
		private function refreshLoginState(data:Object):void
		{
			var loginUrl:String = null;
			
			if (data && data.loginUrl)
			{
				loginUrl = data.loginUrl;
			}
			else if (loginProxy.user && loginProxy.user.loginUrl)
			{
				loginUrl = loginProxy.user.loginUrl;
			}
			
			if (loginUrl)
			{
				if (view.form)
				{
					view.form.removeEventListener("valid", onFormValid);
					view.formValidator.triggerEvent = "";
					view.formValidator.trigger = null;
				}
				
				view.loginButton.html = "<a href='" + loginUrl + "' target='_blank'>Open Login Page</a>";
				view.currentState = "loginExternal";
				view.refreshPageButton.addEventListener("click", onRefreshPageClick);
			}
			else
			{
				view.currentState = "loginInternal";
				if (view.form)
				{
					view.form.addEventListener("valid", onFormValid);
					view.formValidator.triggerEvent = "click";
					view.formValidator.trigger = view.loginButton;
				}
				
				if (view.refreshPageButton)
				{
					view.refreshPageButton.removeEventListener("click", onRefreshPageClick);
				}
			}
		}
    }
}
