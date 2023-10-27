package classes.breadcrump.events
{
    import org.apache.royale.events.Event;

	public class BreadcrumpEvent extends Event 
	{
		public static const ITEM_CLICK:String = "itemClick";
		public static const BREADCRUMP_ITEM_CLICK:String = "breadcrumpItemClick";
		
		public function BreadcrumpEvent(type:String, item:Object = null)
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