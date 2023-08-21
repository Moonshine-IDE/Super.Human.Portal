package interfaces
{
	import org.apache.royale.events.IEventDispatcher;

	public interface IGenesisAdditionalDirView
	{
		function get newDir():IEventDispatcher;
		function get genesisDirsList():IEventDispatcher;
		function set genesisDirsListProvider(value:Array):void;
	}
}