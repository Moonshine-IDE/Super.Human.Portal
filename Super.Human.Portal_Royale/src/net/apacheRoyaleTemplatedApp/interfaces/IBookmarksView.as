package interfaces
{
	import org.apache.royale.events.IEventDispatcher;

	public interface IBookmarksView
	{
		function get currentState():String;
		function set currentState(value:String):void;
		function get addBookmark():IEventDispatcher;
		function get bookmarksList():Object;
		function set groupName(value:String):void;
		function set title(value:String):void;
		function get browseMyServerView():IBrowseMyServerView;
		function get refreshButton():IEventDispatcher;
	}
}