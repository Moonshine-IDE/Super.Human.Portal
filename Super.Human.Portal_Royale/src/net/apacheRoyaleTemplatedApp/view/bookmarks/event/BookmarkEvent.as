package view.bookmarks.event
{
	import model.vo.BookmarkVO;
	import org.apache.royale.events.Event;

	public class BookmarkEvent extends Event 
	{
		public static const EDIT_BOOKMARK:String = "editBookmark";
		public static const DELETE_BOOKMARK:String = "deleteBookmark";
		
		public function BookmarkEvent(type:String, bookmark:BookmarkVO)
		{
			super(type);
			
			_bookmark = bookmark;
		}
		
		private var _bookmark:BookmarkVO;

		public function get bookmark():BookmarkVO
		{
			return _bookmark;
		}
	}
}