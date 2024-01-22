package classes.com.devexpress.js.dataGrid.beads
{
    import classes.com.devexpress.js.dataGrid.beads.models.DataGridColumnModel;
    import classes.com.devexpress.js.dataGrid.beads.models.DataGridModel;
    import classes.com.devexpress.js.dataGrid.events.DataGridEvent;
    import classes.com.devexpress.js.dataGrid.interfaces.IGridModel;

    import org.apache.royale.collections.ArrayList;
    import org.apache.royale.core.IChild;
    import org.apache.royale.core.IDataGrid;
    import org.apache.royale.core.IDataGridModel;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.events.Event;
    import org.apache.royale.html.beads.GroupView;
    import org.apache.royale.jewel.View;
                                                
	public class DataGridView extends GroupView 
	{
		public function DataGridView()
		{
			super();
		}

		private var _model:IDataGridModel;
		
		override public function set strand(value:IStrand):void
	    {
	        super.strand = value;

	        this._model = (host as IDataGrid).model as IDataGridModel;

	        this._model.addEventListener("columnsChanged", handleColumnsChanged);
        	    this._model.addEventListener("optionsChanged", handleOptionsChanged);
        	    this._model.addEventListener("dataProviderChanged", handleDataProviderChanged);
        	    this._model.addEventListener("refreshChangedDataProvider", handleRefreshChangedDataProvider);
        }
		
        override protected function handleInitComplete(event:org.apache.royale.events.Event):void
        	{
        	    window["$"](host.element).dxDataGrid({});	
        	}        	    
        	
		protected function handleColumnsChanged(event:Event):void
		{
			columnsChanged();			
		}
		
		private function handleOptionsChanged(event:Event):void
		{
			optionsChanged();	
		}
		
		protected function handleDataProviderChanged(event:Event):void
		{
			columnsChanged();
			listenersChanged();
			optionsChanged();
			dpChanged();
		}

		private function handleRefreshChangedDataProvider(event:Object):void
		{
			dpChanged();
		}

		private function columnsChanged():void
		{
			 if (!_model.columns) return;
			 
 			 var columns:Array = [];
			_model.columns.forEach(function (model:DataGridColumnModel, index:int, array:Array):void {
				
				if (model.itemRenderer) 
				{
					model.cellTemplate = function(container:Object, options:Object):void {
						var renderer:Object = model.itemRenderer.newInstance();
						var div:View = new View();
								
						renderer.dataField = options.column.dataField;
						renderer.data = options.data;
						
						if (!isNaN(model.width) && model.width > 0)
						{
							renderer.maxWidth = model.width;
						}
						
						div.addElement(renderer as IChild);	
						window["$"]('<div/>').append(div.element)
											 .appendTo(container);
					};	
				}
				
				columns.push(model.toColumnObject());
			});
			
			window["$"](host.element).dxDataGrid({
				columns: columns
			});	
		}
				
		private function listenersChanged():void
		{
			window["$"](host.element).dxDataGrid({
				onRowDblClick: function(event:Object):void {
					host.dispatchEvent(new DataGridEvent(DataGridEvent.DOUBLE_CLICK_ROW, event.data));
				},
				onCellClick: function(event:Object):void {
					var rowIndex:int = event.rowIndex;
					var columnIndex:int = -1;
					var column:Object = {};
					if (event.column)
					{
						columnIndex = event.columnIndex;
						column = host["columns"][event.columnIndex];
					}
					
					host.dispatchEvent(new DataGridEvent(DataGridEvent.CLICK_CELL, event.data, {
							rowIndex: rowIndex,
							columnIndex: columnIndex,
							column: column
						}));
				},
				onSelectionChanged: function(items:Object):void {
					var selectedData:Object = items.selectedRowsData[0];
					
					host.dispatchEvent(new DataGridEvent(DataGridEvent.SELECTION_CHANGED, selectedData));
				}
			});
		}
		
		private function optionsChanged():void
		{
			var grModel:IGridModel = (_model as IGridModel);
			
			window["$"](host.element).dxDataGrid({
				keyExpr: grModel.keyExpr,
				filterRow: grModel.filterRow,
				headerFilter: grModel.headerFilter,
				selection: grModel.selection,
				wordWrapEnabled: grModel.wordWrapEnabled,
				searchPanel: grModel.searchPanel,
				scrolling: grModel.scrolling,
				showColumnLines: grModel.showColumnLines,
				showRowLines: grModel.showRowLines,
				showBorders: grModel.showBorders,
				noDataText: grModel.noDataText
			});		
		}
		
		private function dpChanged():void
		{
			var dp:Object;
			
			if (!(_model as DataGridModel).dataSource)
			{
				if (this._model.dataProvider is ArrayList) 
				{
					dp = this._model.dataProvider.source;
				}			
				else
				{
					dp = this._model.dataProvider as Array;
				}			
			}
			else
			{
				dp = (_model as DataGridModel).dataSource;
			}
		
			var grModel:IGridModel = (_model as IGridModel);
			window["$"](host.element).dxDataGrid({
				dataSource: dp,
				noDataText: grModel.noDataText
			});
		}
	}
}