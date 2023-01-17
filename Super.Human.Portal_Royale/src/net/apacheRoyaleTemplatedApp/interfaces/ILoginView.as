package interfaces
{
	import interfaces.busy.IBusyOperator;

	import org.apache.royale.events.IEventDispatcher;

	public interface ILoginView 
	{
		function get isFormValid():Boolean;
		function get formValidator():Object;
		function get username():String;
		function get password():String;
		function get usernameText():IEventDispatcher;
		function get passwordText():IEventDispatcher;
		function get form():IEventDispatcher;
		function get forgotPassword():IEventDispatcher;
		function get newRegistration():IEventDispatcher;
	    function get loginFailed():Boolean;
    		function set loginFailed(value:Boolean):void;
	    function get loginBusyOperator():IBusyOperator;
		function set errorMessage(value:String):void;
		function resetView():void;
	}
}