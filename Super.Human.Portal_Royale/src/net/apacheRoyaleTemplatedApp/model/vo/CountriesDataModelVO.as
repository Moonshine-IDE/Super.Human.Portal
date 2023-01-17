/**
 * CountriesDataModel
 * 
 *
 * Copyright @ - Prominic
 * @author santanu.k
 *
 * @date 04.13.2009
 * @version 0.1
 */
package model.vo 
{
	import org.apache.royale.collections.ArrayList;

	[Bindable] 
	public class CountriesDataModelVO
	{
		public var countryID		: int;
		public var countryName		: String;
		public var countryCode		: String;
		public var countryIDC		: String;
		public var countryRegion	: ArrayList;
		
		public function CountriesDataModelVO( _countryID:int, _countryName:String, _countryCode:String, _countryIDC:String, _countryRegion:ArrayList ) {
			
			countryID = _countryID;
			countryName = _countryName;
			countryCode = _countryCode;
			countryIDC = _countryIDC;
			countryRegion = _countryRegion;
			
		}
		
	}
	
}