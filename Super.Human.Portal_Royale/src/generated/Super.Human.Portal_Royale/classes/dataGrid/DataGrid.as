package Super.Human.Portal_Royale.classes.dataGrid
{
	import org.apache.royale.jewel.Group;
	import org.apache.royale.events.Event;

	[Event(name="rowDoubleClick", type="org.apache.royale.events.Event")]
	[Event(name="selectionChanged", type="org.apache.royale.events.Event")]
	public class DataGrid extends Group
	{
		private var dg:Object;

		public function DataGrid()
		{
			super();

			this.addEventListener("initComplete", onDgInitComplete);
		}

		private var _selectedItem:Object;

		[Bindable]
		public function get selectedItem():Object
		{
			return _selectedItem;
		}

		public function set selectedItem(value:Object):void
		{
			_selectedItem = value;
		}

		private var _selectedIndex:int = -1;

		[Bindable]
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		public function set selectedIndex(value:int):void
		{
			_selectedIndex = value;
		};

		private var _columns:Array;

		public function get columns():Array
		{
			return _columns;
		}

		public function set columns(value:Array):void
		{
			if (_columns != value)
			{
				_columns = value;

				refreshColumns();
			}
		}

		private var _filterRow:Object = {};

		public function get filterRow():Object
		{
			return _filterRow;
		}

		public function set filterRow(value:Object):void
		{
			if (_filterRow != value)
			{
				_filterRow = value;
				
				refreshFilterRow();
			}
		}
		
		private var _searchPanel:Object = {};

		public function get searchPanel():Object
		{
			return _searchPanel;
		}

		public function set searchPanel(value:Object):void
		{
			if (_searchPanel != value)
			{
				_searchPanel = value;
				
				refreshSearchPanel();
			}
		}
		
		private var _dataProvider:Object;

		public function get dataProvider():Object
		{
			return _dataProvider;
		}

		public function set dataProvider(value:Object):void
		{
			if (_dataProvider != value)
			{
				_dataProvider = value;

				refreshCurrentDataProvider();
			}
		}

		private function onDgInitComplete(event:Event):void
		{
			this.dg = window['$'](this.element).dxDataGrid({
				onRowDblClick: function(event:Object):void {
					selectedItem = event.data;
					selectedIndex = event.dataIndex;

					dispatchEvent(new Event("rowDoubleClick"));
				},
				onSelectionChanged: function(options:Object):void {
					selectedItem = options.selectedRowsData[0];
					selectedIndex = options.component.getRowIndexByKey(selectedItem);

					dispatchEvent(new Event("selectionChanged"));
				},
				selection: {
					mode: 'single'
				}
			});

			this.refreshColumns();
			this.refreshFilterRow();
			this.refreshSearchPanel();
			this.refreshCurrentDataProvider();
		}

		private function refreshColumns():void
		{
			if (this.dg && this.columns && this.columns.length > 0)
			{
				window["$"](this.element).dxDataGrid({
					columns: this.columns
				});
			}
		}

		private function refreshFilterRow():void
		{
			if (this.dg && this.filterRow)
			{
				window["$"](this.element).dxDataGrid({
					filterRow: this.filterRow
				});
			}	
		}
		
		private function refreshSearchPanel():void
		{
			if (this.dg && this.searchPanel)
			{
				window["$"](this.element).dxDataGrid({
					searchPanel: this.searchPanel
				});
			}
		}
		
		public function refreshCurrentDataProvider():void
		{
			if (this.dg)
			{
				window["$"](this.element).dxDataGrid({
					dataSource: this.dataProvider
				});
			}
		}
	}
}