package interfaces.busy
{
	public interface IBusyOperator
	{
		function showBusy():void;
		function hideBusy():void;
		function setMessage(message:String):void;
	}
}