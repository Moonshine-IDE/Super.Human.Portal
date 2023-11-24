package interfaces
{
	import model.vo.BookmarkVO;

	import org.apache.royale.events.IEventDispatcher;

	public interface IEditBookmarkView extends IEventDispatcher, IResetView
	{
		function set currentState(value:String):void;
		function get bookmark():BookmarkVO;
		function set bookmark(value:BookmarkVO):void;
		function get bookmarkForm():IEventDispatcher;
		function get saveBookmark():IEventDispatcher;
		function get cancelBookmark():IEventDispatcher;
		function get titleBookmark():String;
		function set titleBookmark(value:String):void;
		function get selectedBookmarkType():String;
		function setBookmarkTypes(types:Array):void;
		
		function get groupText():String;
		function get nameText():String;
		function get urlText():String;
		function get serverText():String;	
		function get databaseText():String;
		function get viewText():String;
		function get descriptionText():String;
	}
}