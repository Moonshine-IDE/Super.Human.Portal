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
		function set selectedApp(value:String):void;
		
		function get learnMore():IEventDispatcher;
		
		function installationResult(message:String):void;
		
		
	}
}