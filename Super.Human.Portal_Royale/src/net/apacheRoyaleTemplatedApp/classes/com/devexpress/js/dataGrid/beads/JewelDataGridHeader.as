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
			var currentTheme:String = window["DevExpress"].ui.themes.current();
			if (currentTheme && currentTheme.indexOf("dark") > 0)
			{
				window["$"]('<div>')
						.css("font-weight", "bold")
						.css("color", "#dedede")
						.html(info.column.caption)
						.appendTo(container);
			}
			else
			{
				window["$"]('<div>')
						.css("font-weight", "bold")
						.css("color", "#808080")
						.html(info.column.caption)
						.appendTo(container);
			}
			
			window["$"](container[0].parentElement).css("padding", "10px");
		}
	}
}