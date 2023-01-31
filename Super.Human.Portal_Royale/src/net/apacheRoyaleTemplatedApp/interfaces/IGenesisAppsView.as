package interfaces
{
	import org.apache.royale.events.IEventDispatcher;
	import model.vo.ApplicationVO;

	public interface IGenesisAppsView
	{
		function get genesisAppsList():IEventDispatcher;
		function set genesisAppsDataProvider(value:Array):void;
		function get seeMoreDetails():IEventDispatcher;
		function get installApplicationButton():IEventDispatcher;
		function get refreshButton():IEventDispatcher;
		
		function get learnMore():IEventDispatcher;
		
		function installationResult(message:String):void;
		
		
	}
}