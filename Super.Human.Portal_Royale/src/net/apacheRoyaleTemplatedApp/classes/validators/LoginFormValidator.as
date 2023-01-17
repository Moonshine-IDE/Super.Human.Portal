package classes.validators
{
    import org.apache.royale.core.IPopUpHost;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.jewel.beads.validators.Validator;
    import org.apache.royale.utils.UIUtils;

	public class LoginFormValidator extends Validator
	{
		public function LoginFormValidator()
		{
			super();
		}
		
		private var _loginFailed:Boolean;

		public function get loginFailed():Boolean
		{
			return _loginFailed;
		}

		public function set loginFailed(value:Boolean):void
		{
			_loginFailed = value;
		}
		
		override public function validate(event:Event = null):Boolean 
		{		
			if (loginFailed) 
			{
				createErrorTip(requiredFieldError);
				hostComponent.dispatchEvent(new Event("invalidLogin"));
				
				return false;
			} 
			else 
			{
				var host:IPopUpHost = UIUtils.findPopUpHost(hostComponent);
				(host as IUIBase).dispatchEvent(new Event("cleanValidationErrors"));
				
				hostComponent.dispatchEvent(new Event("validLogin"));
				
				return true;
			}
		}	
	}
}