package classes.com.devexpress.js.dataGrid.beads.models
{
	import org.apache.royale.core.IFactory;

	[Bindable]
	public class DataGridColumnModel 
	{
		public var dataField:String = "";
        public var dataType:String;
        public var caption:String = " ";
        
        /**
         * The format property only works for columns with a number, date, or datetime data type.
         **/
        public var format:Object;
        
        public var alignment:String;
        public var allowGrouping:Boolean = false;
        public var cellTemplate:Function = null;
        public var headerCellTemplate:Function = null;
        public var cssClass:String = "";
		public var width:Number;
		
		public var calculateCellValue:Function = null;
		public var calculateSortValue:Object = null;
		
		public var allowSorting:Boolean = true;
		
		/**
		 * Specifies whether data can be filtered by this column. Applies only if filterRow.visible is true.
		 *  Default is false
		 **/
		public var allowFiltering:Boolean = false;
		public var allowHeaderFiltering:Boolean = false;
		public var filterType:String = "include";
		
		public var itemRenderer:IFactory;
		
		public function toColumnObject():Object 
		{
			var columnObject:Object = {
				allowFiltering: this.allowFiltering,
				allowHeaderFiltering: this.allowHeaderFiltering,
				filterType: this.filterType,
				allowSorting: this.allowSorting
			}
			
			if (this.dataField)
			{
				columnObject.dataField = this.dataField;
			} 
			
			if (this.dataField)
			{
				columnObject.dataType = this.dataType;
			} 
			
			if (this.caption)
			{
				columnObject.caption = this.caption;
			} 
			
			if (this.format)
			{
				columnObject.format = this.format;
			} 
			
			if (this.alignment)
			{
				columnObject.alignment = this.alignment;
			} 
			
			if (this.width)
			{
				columnObject.width = this.width;
			} 
			
			if (this.calculateCellValue != null)
			{
				columnObject.calculateCellValue = this.calculateCellValue;
			}
			
			if (this.calculateSortValue != null)
			{
				columnObject.calculateSortValue = this.calculateSortValue;
			}
			
			if (this.headerCellTemplate != null)
			{
				columnObject.headerCellTemplate = this.headerCellTemplate;
			}
			
			if (this.cellTemplate != null)
			{
				columnObject.cellTemplate = this.cellTemplate;	
			}
			
			if (this.cssClass)
			{
				columnObject.cssClass = this.cssClass;	
			}
			
			return columnObject;
		}
	}
}