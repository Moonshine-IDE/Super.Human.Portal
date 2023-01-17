package interfaces.popup
{
	import org.apache.royale.events.IEventDispatcher;

	public interface ISimplePopup extends IEventDispatcher
	{
		function set message(value:String):void;
		function get ok():IEventDispatcher;
	}
}