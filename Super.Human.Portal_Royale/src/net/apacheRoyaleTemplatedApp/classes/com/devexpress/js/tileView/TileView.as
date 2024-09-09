package classes.com.devexpress.js.tileView
{
    import org.apache.royale.core.IBead;
    import org.apache.royale.jewel.Group;
    import org.apache.royale.core.IFactory;
    import classes.com.devexpress.js.tileView.interfaces.ITileViewModel;
    import classes.com.devexpress.js.tileView.events.TileViewEvent;
              
    [Event(name="clickItemTileView", type="classes.com.devexpress.js.tileView.events.TileViewEvent")]
    [Event(name="doubleClickItemTileView", type="classes.com.devexpress.js.tileView.events.TileViewEvent")]
    
	public class TileView extends Group 
	{
		public function TileView()
		{
			super();
		}

		/**
		 *  The object used to provide data 
		 *  @royaleignorecoercion classes.com.devexpress.js.tileView.interfaces.ITileViewModel
		 */
		public function get dataProvider():Object
		{
			return ITileViewModel(model).dataProvider;
		}
		
		/**
		 * @royaleignorecoercion classes.com.devexpress.js.tileView.interfaces.ITileViewModel
		 */
		public function set dataProvider(value:Object):void
		{
			ITileViewModel(model).dataProvider = value;
		}

		/**
		 *  If dataSource is provided it takes precendces over dataProvider
		 
		 *  @royaleignorecoercion classes.com.devexpress.js.tileView.interfaces.ITileViewModel
		 */
		public function get dataSource():Object
		{
			return model["dataSource"];
		}
		
		/**
		 * @royaleignorecoercion classes.com.devexpress.js.tileView.interfaces.ITileViewModel
		 */
		public function set dataSource(value:Object):void
		{
			model["dataSource"] = value;
		}

		/**
		 *  
		 *  @royaleignorecoercion classes.com.devexpress.js.tileView.interfaces.ITileViewModel
		 */
		public function get itemRenderer():IFactory
		{
			return model["itemRenderer"];
		}
		
		/**
		 * @royaleignorecoercion classes.com.devexpress.js.tileView.interfaces.ITileViewModel
		 */
		public function set itemRenderer(value:IFactory):void
		{
			model["itemRenderer"] = value;
		}
		
		/**
		 *  
		 *  @royaleignorecoercion classes.com.devexpress.js.tileView.interfaces.ITileViewModel
		 */
		public function get direction():String
		{
			return model["direction"];
		}
		
		/**
		 * @royaleignorecoercion classes.com.devexpress.js.tileView.interfaces.ITileViewModel
		 */
		public function set direction(value:String):void
		{
			model["direction"] = value;
		}
		
		/**
		 *  
		 *  @royaleignorecoercion classes.com.devexpress.js.tileView.interfaces.ITileViewModel
		 */
		public function get baseItemHeight():Number
		{
			return model["baseItemHeight"];
		}
		
		/**
		 * @royaleignorecoercion classes.com.devexpress.js.tileView.interfaces.ITileViewModel
		 */
		public function set baseItemHeight(value:Number):void
		{
			model["baseItemHeight"] = value;
		}
		
		/**
		 *  
		 *  @royaleignorecoercion classes.com.devexpress.js.tileView.interfaces.ITileViewModel
		 */
		public function get baseItemWidth():Number
		{
			return model["baseItemWidth"];
		}
		
		/**
		 * @royaleignorecoercion classes.com.devexpress.js.tileView.interfaces.ITileViewModel
		 */
		public function set baseItemWidth(value:Number):void
		{
			model["baseItemWidth"] = value;
		}
		
		/**
		 *  
		 *  @royaleignorecoercion classes.com.devexpress.js.tileView.interfaces.ITileViewModel
		 */
		public function get itemMargin():Number
		{
			return model["itemMargin"];
		}
		
		/**
		 * @royaleignorecoercion classes.com.devexpress.js.tileView.interfaces.ITileViewModel
		 */
		public function set itemMargin(value:Number):void
		{
			model["itemMargin"] = value;
		}

		/**
		 * @royaleignorecoercion classes.com.devexpress.js.tileView.interfaces.ITileViewModel
		 */
		 [Bindable]
		public function get selectedIndex():int
		{
			return model["selectedIndex"];
		}

		/**
		 * @royaleignorecoercion classes.com.devexpress.js.tileView.interfaces.ITileViewModel
		 */
		public function set selectedIndex(value:int):void
		{
			model["selectedIndex"] = value;
		}

		/**
		 * @royaleignorecoercion classes.com.devexpress.js.tileView.interfaces.ITileViewModel
		 */
		 [Bindable]
		public function get selectedItem():Object
		{
			return model["selectedItem"];
		}

		/**
		 * @royaleignorecoercion classes.com.devexpress.js.tileView.interfaces.ITileViewModel
		 */
		public function set selectedItem(value:Object):void
		{
			model["selectedItem"] = value;
		}
		
		/**
		 * @royaleignorecoercion classes.com.devexpress.js.tileView.interfaces.ITileViewModel
		 */
		public function get showScrollbar():String
		{
			return model["showScrollbar"];
		}
		
		public function set showScrollbar(value:String):void
		{
			model["showScrollbar"] = value;
		}
		
		/*
		* Method should be called when you add/remove some item from dataProvider
		**/
		public function refreshDataProvider():void
		{
			model.dispatchEvent(new Event("refreshChangedDataProvider"));
		}
	}
}