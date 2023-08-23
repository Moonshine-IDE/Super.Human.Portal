package classes.com.devexpress.js.dataGrid.beads.models
{
    import org.apache.royale.html.beads.models.DataGridModel;
    import classes.com.devexpress.js.dataGrid.interfaces.IGridModel;
        
	public class DataGridModel extends org.apache.royale.html.beads.models.DataGridModel implements IGridModel
	{
		public function DataGridModel()
		{
			super();
		}
		
		private var _keyExpr:Array;

		public function get keyExpr():Array
		{
			return _keyExpr;
		}
		
		public function set keyExpr(value:Array):void
		{
			if (this._keyExpr != value)
			{
				this._keyExpr = value;	
				
				dispatchEvent(new Event("optionsChanged"));
			}				
		}
		
		private var _selection:Object = { mode: "single" };

		/**
		 *  Configures runtime selection.
		 *  
		 *  Possible options:
		 *   - allowSelectAll | Boolean
		 *   - deferred | Boolean
		 *   - mode | String | 'multiple', 'none', 'single'
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.9
		 */
		public function get selection():Object
		{
			return _selection;
		}
		
		public function set selection(value:Object):void
		{
			if (_selection != value) 
			{
				_selection = value;
				dispatchEvent( new Event("optionsChanged"));
			}
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
		
		private var _filterRow:Object = { visible: false };

		public function get filterRow():Object
		{
			return _filterRow;
		}
		
		public function set filterRow(value:Object):void
		{
			if (this._filterRow != value)
			{
				this._filterRow = value;	
				
				dispatchEvent(new Event("optionsChanged"));
			}				
		}
		
		private var _headerFilter:Object = { visible: false };

		public function get headerFilter():Object
		{
			return _headerFilter;
		}
		
		public function set headerFilter(value:Object):void
		{
			if (this._headerFilter != value)
			{
				this._headerFilter = value;	
				
				dispatchEvent(new Event("optionsChanged"));
			}				
		}
		
		private var _wordWrapEnabled:Boolean;

		public function get wordWrapEnabled():Boolean
		{
			return _wordWrapEnabled;
		}
		
		public function set wordWrapEnabled(value:Boolean):void
		{
			if (this._wordWrapEnabled != value)
			{
				this._wordWrapEnabled= value;	
				
				dispatchEvent(new Event("optionsChanged"));
			}				
		}
		
		private var _searchPanel:Object = { visible: false };

		public function get searchPanel():Object
		{
			return _searchPanel;
		}
		
		public function set searchPanel(value:Object):void
		{
			if (this._searchPanel != value)
			{
				this._searchPanel = value;	
				
				dispatchEvent(new Event("optionsChanged"));
			}				
		}
		
		private var _scrolling:Object = { mode: "standard" };

		public function get scrolling():Object
		{
			return _scrolling;
		}
		
		public function set scrolling(value:Object):void
		{
			if (this._scrolling != value)
			{
				this._scrolling = value;	
				
				dispatchEvent(new Event("optionsChanged"));
			}				
		}
		
		private var _showColumnLines:Boolean = true;
		
		public function get showColumnLines():Boolean
		{
			return _showColumnLines;
		}
		
		public function set showColumnLines(value:Boolean):void
		{
			if (this._showColumnLines != value)
			{
				this._showColumnLines = value;	
				
				dispatchEvent(new Event("optionsChanged"));
			}				
		}

		private var _noDataText:String = "No data";
		
		public function set noDataText(value:String):void
		{
			if (_noDataText != value)
			{
				_noDataText = value;
				
				dispatchEvent(new Event("optionsChanged"));
			}
		}
		
		/**
		 * Specifies a text string shown when the DataGrid does not display any data.
		 * @default: "No data"
		 **/
		public function get noDataText():String
		{
			return _noDataText;
		}
	}
}