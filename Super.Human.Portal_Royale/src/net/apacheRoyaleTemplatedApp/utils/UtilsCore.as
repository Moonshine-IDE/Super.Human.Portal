package utils
{
	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.collections.CompareUtils;
	
	public class UtilsCore
	{
		private static var _specialCharDict:Object;
		private static var _presentSortField:String;
		
		/**
		 * Sorting of any arrayCollection object
		 * by it's date field value
		 * 
		 * format (mm/dd/yyyy)
		 */
		public static function sortByDateString( collection:ArrayList, field:String ) : void {
			
			// need to adjust for Royale
			_presentSortField = field;
			collection.source.sort(dateSorter);
		}
		
		/**
		 * Supportive method of 'sortByDateString'
		 * comparefunction for date string sort
		 */
		public static function dateSorter( objA:Object, objB:Object ) : int {
			
			// need to adjust for Royale
			// possible termination
			if ( !_presentSortField ) return 0;
			
			var dateA : Date = new Date( Date.parse(objA[_presentSortField]) );
			var dateB : Date = new Date( Date.parse(objB[_presentSortField]) );
			
			return CompareUtils.dateCompare(dateB, dateA);
		}
		
		/**
		 * Items sorter
		 */
		public static function sortItems(collection:Array, fieldName:String=null, descending:Boolean=false, numeric:Boolean=false):void
		{
			collection.sortOn(fieldName, (descending ? Array.DESCENDING : null) | (numeric ? Array.NUMERIC : null));
		}
	}
}