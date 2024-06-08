package  classes.com.devexpress.js.tileView.events
{
	import org.apache.royale.events.Event;

	public class TileViewEvent extends Event 
	{
		public static const CLICK_ITEM:String = "clickItemTileView";
		
		public function TileViewEvent(type:String, item:Object = null)
		{
			super(type);
			
			_item = item;
		}
		
		private var _item:Object;
		
		public function get item():Object
		{
			return _item;
		}
	}
}