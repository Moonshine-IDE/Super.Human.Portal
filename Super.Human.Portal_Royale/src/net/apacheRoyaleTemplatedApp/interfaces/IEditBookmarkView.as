package interfaces
{
	import org.apache.royale.events.IEventDispatcher;
	import model.vo.BookmarkVO;

	public interface IEditBookmarkView
	{
		function get bookmark():BookmarkVO;
		function set bookmark(value:BookmarkVO):void;
		function get saveBookmark():IEventDispatcher;
		function get cancelBookmark():IEventDispatcher;
		function get titleBookmark():String;
		function set titleBookmark(value:String):void;
		function get typeBookmark():Object;
		function get browserForm():Object;
		function get databaseForm():Object;
	}
}