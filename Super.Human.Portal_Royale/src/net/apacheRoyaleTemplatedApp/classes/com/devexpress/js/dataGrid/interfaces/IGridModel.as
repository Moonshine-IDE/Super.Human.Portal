package classes.com.devexpress.js.dataGrid.interfaces
{
	public interface IGridModel
	{
		function get keyExpr():Array;
		function set keyExpr(value:Array):void;
		
		function get selection():Object;
		function set selection(value:Object):void;
		
		function get dataSource():Object;
		function set dataSource(value:Object):void;
		
		function get filterRow():Object;
		function set filterRow(value:Object):void;
		
		function get headerFilter():Object;
		function set headerFilter(value:Object):void;
		
		function get wordWrapEnabled():Boolean;
		function set wordWrapEnabled(value:Boolean):void;
		
		function get searchPanel():Object;
		function set searchPanel(value:Object):void;
		
		function get scrolling():Object;
		function set scrolling(value:Object):void;
		
		function get showColumnLines():Boolean;
		function set showColumnLines(value:Boolean):void;
		
		function set noDataText(value:String):void;
		function get noDataText():String;
	}
}