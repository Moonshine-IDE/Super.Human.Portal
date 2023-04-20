package interfaces
{
	import org.apache.royale.events.IEventDispatcher;

	public interface IInstalledAppView
	{
		function get seeMoreDetails():IEventDispatcher;
		function set applicationName(value:String):void;
	}
}