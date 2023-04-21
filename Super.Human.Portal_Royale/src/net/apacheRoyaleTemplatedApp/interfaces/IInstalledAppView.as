package interfaces
{
	import org.apache.royale.events.IEventDispatcher;

	public interface IInstalledAppView
	{
		function get seeMoreDetails():IEventDispatcher;
		function set applicationName(value:String):void;
		function set appDescription(value:String):void;
		function get installedAppLinksContainer():Object;
		function get installedAppLinks():Object;
		function get installedAppLinksLayout():Object;
	}
}