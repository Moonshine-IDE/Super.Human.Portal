package view.bookmarks.event
{
	import model.vo.BookmarkVO;
	import org.apache.royale.events.Event;

	public class BookmarkEvent extends Event 
	{
		public static const EDIT_BOOKMARK:String = "editBookmark";
		public static const DELETE_BOOKMARK:String = "deleteBookmark";
		public static const BOOKMARK_TYPE_CHANGE:String = "bookmarkTypeChange";
		
		public function BookmarkEvent(type:String, bookmark:BookmarkVO = null, bookmarkType:String = "")
		{
			super(type);
			
			_bookmark = bookmark;
			_bookmarkType = bookmarkType;
		}
		
		private var _bookmark:BookmarkVO;

		public function get bookmark():BookmarkVO
		{
			return _bookmark;
		}
		
		private var _bookmarkType:String;
		
		public function get bookmarkType():String
		{
			return _bookmarkType;
		}
	}
}