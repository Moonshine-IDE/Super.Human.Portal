package classes.com.devexpress.js.tileView.beads.models
{
    import classes.com.devexpress.js.tileView.interfaces.ITileViewModel;

    import org.apache.royale.core.IFactory;
    import org.apache.royale.jewel.beads.models.DataProviderModel;

	public class TileViewModel extends DataProviderModel implements ITileViewModel
	{
		public function TileViewModel()
		{
			super();
		}
		
		private var _dataSource:Object;

		public function get dataSource():Object
		{
			return _dataSource;
		}
		
		public function set dataSource(value:Object):void
		{
			if (this._dataSource != value)
			{
				this._dataSource = value;	
				
				dispatchEvent(new Event("dataProviderChanged"));
			}				
		}
		
		private var _itemRenderer:IFactory;

		public function get itemRenderer():IFactory
		{
			return _itemRenderer;
		}

		public function set itemRenderer(value:IFactory):void
		{
			if (this._itemRenderer != value)
			{
				_itemRenderer = value;
			
				dispatchEvent(new Event("itemRendererChanged"));
			}
		}
		
		private var _direction:String;

		public function get direction():String
		{
			return _direction;
		}

		public function set direction(value:String):void
		{
			if (this._direction != value)
			{
				_direction = value;
				
				dispatchEvent(new Event("optionsChanged"));
			}
		}
		
		private var _baseItemHeight:Number = 100;
		
		public function get baseItemHeight():Number
		{
			return _baseItemHeight;
		}
		
		public function set baseItemHeight(value:Number):void
		{
			if (this._baseItemHeight != value)
			{
				_baseItemHeight = value;
				
				dispatchEvent(new Event("optionsChanged"));
			}
		}
		
		private var _baseItemWidth:Number = 100;
		
		public function get baseItemWidth():Number
		{
			return _baseItemWidth;
		}
		
		public function set baseItemWidth(value:Number):void
		{
			if (this._baseItemWidth != value)
			{
				_baseItemWidth = value;
				
				dispatchEvent(new Event("optionsChanged"));
			}
		}
		
		private var _itemMargin:Number;
		
		public function get itemMargin():Number
		{
			return _itemMargin;
		}
		
		public function set itemMargin(value:Number):void
		{
			
			if (this._itemMargin != value)
			{
				_itemMargin = value;
				
				dispatchEvent(new Event("optionsChanged"));
			}
		}

		private var _selectedIndex:int = -1;
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		public function set selectedIndex(value:int):void
		{
			if (this._selectedIndex != value)
			{
				_selectedIndex = value;
				dispatchEvent(new Event("selectedIndexChanged"));
			}
		}

		private var _selectedItem:Object;
		
		public function get selectedItem():Object
		{
			return _selectedItem;
		}

		public function set selectedItem(value:Object):void
		{
			if (this._selectedItem != value)
			{
				_selectedItem = value;
				dispatchEvent(new Event("selectedItemChanged"));
			}
		}
	}
}