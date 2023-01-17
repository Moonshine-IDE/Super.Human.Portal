package classes.com.devexpress.js.dataGrid.events
{
	import org.apache.royale.events.Event;

	public class DataGridEvent extends Event
	{
		public static const DOUBLE_CLICK_ROW:String = "DOUBLE_CLICK_ROW_DG";
		
		public static const CLICK_CELL:String = "CLICK_ROW_DG";
		
		public static const SELECTION_CHANGED:String = "SELECTION_CHANGED_DG";
		
		public function DataGridEvent(type:String, item:Object = null, dataGridData:Object = null)
		{
			super(type);
			
			_item = item;
			_dataGridData = dataGridData;
		}
		
		private var _item:Object;
		
		public function get item():Object
		{
			return _item;
		}
		
		private var _dataGridData:Object;
		
		public function get dataGridData():Object
		{
			return _dataGridData;
		}
	}
}