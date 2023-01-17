package interfaces
{
	import org.apache.royale.events.IEventDispatcher;
	import model.vo.NewRegistrationVO;
	import org.apache.royale.collections.ArrayList;
		
	public interface INewRegistration extends IResetView, IPasswordStrength
	{
		function get newRegistration():NewRegistrationVO;
		function set newRegistration(value:NewRegistrationVO):void;
		function get phoneCountries():ArrayList;
		function set phoneCountries(value:ArrayList):void;
		function get newPasswordInput():IEventDispatcher;
		function get formRegister():IEventDispatcher;
		function get backToLogin():IEventDispatcher;
		function set mobileType(value:ArrayList):void;
		function set idcCountries(value:ArrayList):void;
		
		function get registrationFailed():Boolean;
    	function set registrationFailed(value:Boolean):void;
		function set errorMessage(value:String):void
		
		function get dropDownTypePrimaryPhone():IEventDispatcher;		
		function get dropDownTypeSecondaryPhone():IEventDispatcher;
		
		function updateViewInfo():void;
	}
}