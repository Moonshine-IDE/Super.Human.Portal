package classes.com.devexpress.js.dataGrid.beads
{
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IStrand;
    import classes.com.devexpress.js.dataGrid.DataGrid;
    import classes.com.devexpress.js.dataGrid.beads.models.DataGridColumnModel;
    
	public class JewelDataGridHeader implements IBead
	{
		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			this._strand = value;
			
			var columns:Array = (value as DataGrid).columns;
			
			if (columns) {
				columns.forEach(function(col:DataGridColumnModel, index:int, arr:Array):void {
					col.headerCellTemplate = headerTemplateFunction;
				});
				
				(value as DataGrid).dispatchEvent(new Event("columnsChanged"));
			}
		}
		
		private function headerTemplateFunction(container:Object, info:Object, element:Object = null):void
		{
			window["$"](container[0].parentElement).css("background", "linear-gradient(#e6e6e6, #cccccc)");
			window["$"](container[0].parentElement).css("border", "1px solid #b3b3b3");
			window["$"](container[0].parentElement).css("padding", "10px");
			window["$"](container[0].parentElement).css("box-shadow", "inset 0 1px 0 white");
			
			
			window["$"]('<div>')
					.css("font-weight", "bold")
					.css("color", "#808080")
                    .html(info.column.caption)
                    .appendTo(container);
		}
	}
}