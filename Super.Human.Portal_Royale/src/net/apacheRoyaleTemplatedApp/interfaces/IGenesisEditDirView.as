package interfaces
{
	import model.vo.GenesisDirVO;

	import org.apache.royale.events.IEventDispatcher;

	public interface IGenesisEditDirView extends IResetView
	{
		function get genesisDir():GenesisDirVO;
		function set genesisDir(value:GenesisDirVO):void;
		function get genesisDirForm():IEventDispatcher;
		function get cancelGenesisEdit():IEventDispatcher;
		function get titleGenesisDir():String;
		function set titleGenesisDir(value:String):void;
		function get isPasswordDisabled():Boolean;
		function set isPasswordDisabled(value:Boolean):void;
		function get passwordChange():IEventDispatcher;
		function set passwordPrompt(value:String):void;
		
		function get labelText():String;	
		function get urlText():String;
		function get passwordText():String;
	}
}