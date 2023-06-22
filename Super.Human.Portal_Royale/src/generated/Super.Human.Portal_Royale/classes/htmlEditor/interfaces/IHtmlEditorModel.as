package Super.Human.Portal_Royale.classes.htmlEditor.interfaces
{
	import org.apache.royale.events.IEventDispatcher;

	public interface IHtmlEditorModel extends IEventDispatcher
	{
		function get data():Object;
		function set data(value:Object):void;
		
		function get toolbar():Object;
		function set toolbar(value:Object):void;
		
		function get toolbarMultiline():Boolean;
		function set toolbarMultiline(value:Boolean):void;
		
		function get toolbarItems():Array;
		function set toolbarItems(value:Array):void;
		
		function get readOnly():Boolean;
		function set readOnly(value:Boolean):void;
	}
}