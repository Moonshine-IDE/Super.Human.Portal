package classes.com.devexpress.js.dataGrid
{
    import classes.com.devexpress.js.dataGrid.events.DataGridEvent;
    import classes.com.devexpress.js.dataGrid.interfaces.IGridModel;

    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IDataGrid;
    import org.apache.royale.core.IDataGridModel;
    import org.apache.royale.core.IDataGridPresentationModel;
    import org.apache.royale.events.MouseEvent;
    import org.apache.royale.jewel.Group;
                    
	public class DataGrid extends Group implements IDataGrid
	{
		public function DataGrid()
		{
			super();
		}

		/**
		 *  @royaleignorecoercion classes.com.devexpress.js.dataGrid.beads.models.IDataGridModel
		 */
		public function get keyExpr():Array
		{
			return model["keyExpr"];
		}
		
		/**
		 * @royaleignorecoercion classes.com.devexpress.js.dataGrid.beads.models.IDataGridModel
		 */
		public function set keyExpr(value:Array):void
		{
			model["keyExpr"] = value;
		}
		
		[Bindable("columnsChanged")]
		/**
		 *  The array of org.apache.royale.html.supportClasses.DataGridColumns used to 
		 *  describe each column.
		 *  @royaleignorecoercion org.apache.royale.core.IDataGridModel
		 */
		public function get columns():Array
		{			
			return IDataGridModel(model).columns;
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.IDataGridModel
		 */
		public function set columns(value:Array):void
		{
			IDataGridModel(model).columns = value;			
		}
		
		/**
		 *  The object used to provide data to the org.apache.royale.html.DataGrid.
		 *  @royaleignorecoercion org.apache.royale.core.IDataGridModel
		 */
		public function get dataProvider():Object
		{
			return IDataGridModel(model).dataProvider;
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.IDataGridModel
		 */
		public function set dataProvider(value:Object):void
		{
			IDataGridModel(model).dataProvider = value;
		}

		/**
		 *  If dataSource is provided it takes precendces over dataProvider
		 
		 *  @royaleignorecoercion classes.com.devexpress.js.dataGrid.beads.models.IDataGridModel
		 */
		public function get dataSource():Object
		{
			return model["dataSource"];
		}
		
		/**
		 * @royaleignorecoercion classes.com.devexpress.js.dataGrid.beads.models.IDataGridModel
		 */
		public function set dataSource(value:Object):void
		{
			model["dataSource"] = value;
		}
		
		/**
		 * @royaleignorecoercion classes.com.devexpress.js.dataGrid.beads.models.IDataGridModel
		 */
		public function get filterRow():Object
		{
			return model["filterRow"];
		}

		/**
		 * @royaleignorecoercion classes.com.devexpress.js.dataGrid.beads.models.IDataGridModel
		 */
		public function set filterRow(value:Object):void
		{
			model["filterRow"] = value;
		}
		
		/**
		 * @royaleignorecoercion classes.com.devexpress.js.dataGrid.beads.models.IDataGridModel
		 */
		public function get headerFilter():Object
		{
			return model["headerFilter"];
		}

		/**
		 * @royaleignorecoercion classes.com.devexpress.js.dataGrid.beads.models.IDataGridModel
		 */
		public function set headerFilter(value:Object):void
		{
			model["headerFilter"] = value;
		}
		
		public function get wordWrapEnabled():Boolean
		{
			return model["wordWrapEnabled"];
		}
		
		public function set wordWrapEnabled(value:Boolean):void
		{
			model["wordWrapEnabled"] = value;
		}
		
		/**
		 * @royaleignorecoercion classes.com.devexpress.js.dataGrid.beads.models.IDataGridModel
		 */
		public function set searchPanel(value:Object):void
		{
			model["searchPanel"] = value;
		}
		
		/**
		 * @royaleignorecoercion classes.com.devexpress.js.dataGrid.beads.models.IDataGridModel
		 */
		public function get searchPanel():Object
		{
			return model["searchPanel"];
		}

		/**
		 * property: mode - 'infinite' | 'standard' | 'virtual'
		 * 
		 * @royaleignorecoercion classes.com.devexpress.js.dataGrid.beads.models.IDataGridModel
		 */
		public function set scrolling(value:Object):void
		{
			model["scrolling"] = value;
		}
		
		/**
		 * @royaleignorecoercion classes.com.devexpress.js.dataGrid.beads.models.IDataGridModel
		 */
		public function get scrolling():Object
		{
			return model["scrolling"];
		}
		
		/**
		 * Showing vertical lines in DataGrid
		 *
		 * @default: true
		 * @royaleignorecoercion classes.com.devexpress.js.dataGrid.beads.models.IDataGridModel
		 */
		public function set showColumnLines(value:Object):void
		{
			model["showColumnLines"] = value;
		}
		
		/**
		 * @royaleignorecoercion classes.com.devexpress.js.dataGrid.beads.models.IDataGridModel
		 */
		public function get showColumnLines():Object
		{
			return model["showColumnLines"];
		}
		
		/**
		 * @private
		 */
		private var _presentationModel:IDataGridPresentationModel;
		
		/**
		 *  The DataGrid's presentation model
		 *  @royaleignorecoercion org.apache.royale.core.IDataGridPresentationModel
		 *  @royaleignorecoercion org.apache.royale.core.IBead
		 */
		public function get presentationModel():IBead
		{
			return null;
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.IDataGridPresentationModel
		 */
		public function set presentationModel(value:IBead):void
		{
			
		}
		
		/*
		* Method should be called when you add/remove some item from dataProvider
		**/
		public function refreshDataProvider():void
		{
			model.dispatchEvent(new Event("refreshChangedDataProvider"));
		}
		
		public function set selection(value:Object):void
		{
			IGridModel(model).selection = value;
		}

		override public function addEventListener(type:String, handler:Function, opt_capture:Boolean = false, opt_handlerScope:Object = null):void
		{
			super.addEventListener(type, handler, opt_capture, opt_handlerScope);
			
			if (type == MouseEvent.DOUBLE_CLICK)
			{
				model.onRowDblClick = handler;
			}
			
			if (type == DataGridEvent.SELECTION_CHANGED)
			{
				model.onSelectionChanged = handler;
			}
		}
		
		override public function removeEventListener(type:String, handler:Function, opt_capture:Boolean = false, opt_handlerScope:Object = null):void
		{
			super.removeEventListener(type, handler, opt_capture, opt_handlerScope);
			
			if (type == MouseEvent.DOUBLE_CLICK)
			{
				model.onRowDblClick = null;
			}
			
			if (type == DataGridEvent.SELECTION_CHANGED)
			{
				model.onSelectionChanged = null;
			}
		}
	}
}