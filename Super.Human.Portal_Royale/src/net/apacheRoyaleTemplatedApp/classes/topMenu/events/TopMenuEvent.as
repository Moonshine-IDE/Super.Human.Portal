package classes.topMenu.events
{
    import org.apache.royale.events.Event;

	public class TopMenuEvent extends Event 
	{
		public static const MENU_LOADED:String = "menuLoaded";
		public static const MENU_ITEM_CHANGE:String = "menuItemChange";
		
		public function TopMenuEvent(type:String, item:Object = null)
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