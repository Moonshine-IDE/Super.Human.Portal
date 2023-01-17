package interfaces
{
	public interface IPasswordStrength 
	{
		function get passwordStrength():int;
		function set passwordStrength(value:int):void;
		function get passwordStrengthMessage():String;
		function set passwordStrengthMessage(value:String):void;
	}
}