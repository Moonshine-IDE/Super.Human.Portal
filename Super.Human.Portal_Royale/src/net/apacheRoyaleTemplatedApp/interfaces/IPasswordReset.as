package interfaces
{
	import model.vo.PasswordResetVO;

	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.utils.IClassSelectorListSupport;

	public interface IPasswordReset extends IResetView, IPasswordStrength
	{
		function get passwordResetModel():PasswordResetVO;
		function set passwordResetModel(value:PasswordResetVO):void;
		
		function get emailPage():IEventDispatcher;
		function get passwordResetPage():IEventDispatcher;
		function get loginPage():IEventDispatcher;
		function get currentStep():String;
		
		function get formEmail():IEventDispatcher;		
		function get formCode():IEventDispatcher;
		
		function get recoveryCode():IEventDispatcher;

		function get login():IEventDispatcher;
		function get backToLogin():IEventDispatcher;
		
		function set backToLoginVisible(value:Boolean):void;	
		function set nextStepLabelVisible(value:Boolean):void;
		
		function get wizardCard():IClassSelectorListSupport;
		
		function get nextStep():IEventDispatcher;		
		function set nextStepLabel(value:String):void;
		
		function set emailFormError(value:String):void;
		function set codeFormError(value:String):void;
		
		function get newPasswordInput():Object;
		function get confirmPasswordInput():Object;
	}
}