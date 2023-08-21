package interfaces
{
	import org.apache.royale.events.IEventDispatcher;

	public interface IGenesisDirsView
	{
		function get newDir():IEventDispatcher;
		function get genesisDirsList():IEventDispatcher;
		function set genesisDirsListProvider(value:Array):void;
	}
}