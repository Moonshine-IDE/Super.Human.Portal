package Super.Human.Portal_Royale.classes.htmlEditor.helpers
{
	public class ToolbarItems  
	{
		public static const SEPARATOR:Object = { name: "separator" };
		
		public static const UNDO:Object = { name: "undo" };	
		public static const REDO:Object = { name: "redo" };	
		public static const FONT:Object = { name: "font", 
										   acceptedValues: ['Arial', 'Courier New', 'Georgia', 'Impact', 'Lucida Console', 'Tahoma', 'Times New Roman', 'Verdana'] };
		public static const SIZE:Object = { name: "size",
										   acceptedValues: ['8pt', '10pt', '12pt', '14pt', '18pt', '24pt', '36pt'] };
				
		public static const BOLD:Object = { name: "bold" };
		public static const ITALIC:Object = { name: "italic" };
		public static const STRIKE:Object = { name: "strike" };	
		public static const UNDERLINE:Object = { name: "underline" };	
		public static const SUBSCRIPT:Object = { name: "subscript" };
		public static const SUPERSCRIPT:Object = { name: "superscript" };	
		
		public static const ALIGNLEFT:Object = { name: "alignLeft" };	
		public static const ALIGNCENTER:Object = { name: "alignCenter" };	
		public static const ALIGNRIGHT:Object = { name: "alignRight" };	
		public static const ALIGNJUSTIFY:Object = { name: "alignJustify" };
		
		public static const ORDEREDLIST:Object = { name: "orderedList" };
		public static const BULLETLIST:Object = { name: "bulletList" };	
		public static const DECREASEINDENT:Object = { name: "decreaseIndent" };	
		public static const INCREASEINDENT:Object = { name: "increaseIndent" };	
		
		public static const HEADER:Object = { name: "header", acceptedValues: [false, 1, 2, 3, 4, 5] };	
				
		public static const COLOR:Object = { name: "color" };							   
		public static const BACKGROUND:Object = { name: "background" };
	
		public static const LINK:Object = { name: "link" };
		public static const IMAGE:Object = { name: "image" };
		
		public static const CLEAR:Object = { name: "clear" };	
		public static const CODEBLOCK:Object = { name: "codeBlock" };
		public static const BLOCKQUOTE:Object = { name: "blockquote" };	

		public static const INSERTTABLE:Object = { name: "insertTable" };	
		public static const DELETETABLE:Object = { name: "deleteTable" };
		public static const INSERTROWABOVE:Object = { name: "insertRowAbove" };	
		public static const INSERTROWBELOW:Object = { name: "insertRowBelow" };	
		public static const DELETEROW:Object = { name: "deleteRow" };		
		public static const INSERTCOLUMNLEFT:Object = { name: "insertColumnLeft" };
		public static const INSERTCOLUMNRIGHT:Object = { name: "insertColumnRight" };	
		public static const DELETECOLUMN:Object = { name: "deleteColumn" };
		public static const CELLPROPERTIES:Object = { name: "cellProperties" };
		public static const TABLEPROPERTIES:Object = { name: "tableProperties" };	
		public static const INSERTHEADERROW:Object = { name: "insertHeaderRow" };	
				
		public static const VARIABLE:Object = { name: "variable" };

		public static const ALL_ITEMS:Array = [
							UNDO, REDO, FONT, SIZE, SEPARATOR,
							BOLD, ITALIC, STRIKE, UNDERLINE, SUBSCRIPT, SUPERSCRIPT, SEPARATOR,
							ALIGNLEFT, ALIGNCENTER, ALIGNRIGHT, ALIGNJUSTIFY, SEPARATOR,
							ORDEREDLIST, BULLETLIST, SEPARATOR,
							DECREASEINDENT, INCREASEINDENT, SEPARATOR,
							HEADER, SEPARATOR,
							COLOR, BACKGROUND, SEPARATOR,
							LINK, IMAGE, SEPARATOR,
							CLEAR, CODEBLOCK, BLOCKQUOTE, SEPARATOR,
							INSERTTABLE, DELETETABLE, INSERTROWABOVE, INSERTROWBELOW, DELETEROW, INSERTCOLUMNLEFT, INSERTCOLUMNRIGHT, DELETECOLUMN, 
							INSERTHEADERROW, CELLPROPERTIES, TABLEPROPERTIES, SEPARATOR,
							VARIABLE
						];
	}
}