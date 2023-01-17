/**
 * BillingVO
 * 
 *
 * Copyright @ - Prominic
 * @author santanu.k
 *
 * @date 04.20.2009
 * @version 0.1
 */
package model.vo {
	
	public class BillingVO {
		
		// ---------------------------------------
		// PRIVATE VARIABLES
		// ---------------------------------------
		
		private var _billingID				: int;
		private var _typeID					: int;
		private var _addressPrimaryType		: String;
		private var _userName				: String;
		private var _companyName			: String;
		private var _addressPrimaryCountry	: String;
		private var _addressPrimaryStreet1	: String;
		private var _addressPrimaryStreet2	: String;
		private var _addressPrimaryCity		: String;
		private var _addressPrimaryRegion	: String;
		private var _addressPrimaryPostCode	: String;
		private var _isSelected	: Boolean;
		
		/**
		 * CONSTRUCTOR
		 */
		public function BillingVO() {	}
		
		/**
		 * Parse a data object
		 */
		public function loadData( product:Object, tempID:int, tempCatID:int ) : void {
			
			billingID = tempID;
			typeID = tempCatID;
			addressPrimaryType = product.addressPrimaryType;
			
			//if ( product.individualName == undefined ) userName = appModelLocator.userFName;
			//else userName = product.individualName;
			userName = product.individualName;

			companyName = product.companyName;
			addressPrimaryCountry = product.addressPrimaryCountry;
			addressPrimaryStreet1 = product.addressPrimaryStreet1;
			addressPrimaryStreet2 = product.addressPrimaryStreet2;
			addressPrimaryCity = product.addressPrimaryCity;
			addressPrimaryRegion = product.addressPrimaryRegion;
			addressPrimaryPostCode = product.addressPrimaryPostCode;
			
		}
		
		/**
		 * GETTER SETTER
		 */
		[Bindable] 
		public function get typeID():int
		{
			return _typeID;
		}
		public function set typeID(value:int):void
		{
			_typeID = value;
		}
		
		[Bindable] 
		public function get billingID():int
		{
			return _billingID;
		}
		
		public function set billingID(value:int):void
		{
			_billingID = value;
		}
		
		[Bindable] 
		public function set isSelected( value:Boolean ) : void 
		{
			_isSelected = value;
		}
		
		public function get isSelected() : Boolean {
			return _isSelected;
		}
		
		[Bindable] 
		public function get addressPrimaryType():String
		{
			return _addressPrimaryType;
		}

		public function set addressPrimaryType(value:String):void
		{
			_addressPrimaryType = value;
		}
		
		[Bindable] 
		public function get userName():String
		{
			return _userName;
		}

		public function set userName(value:String):void
		{
			_userName = value;
		}
		
		[Bindable] 
		public function get companyName():String
		{
			return _companyName;
		}

		public function set companyName(value:String):void
		{
			_companyName = value;
		}
		
		[Bindable] 
		public function get addressPrimaryCountry():String
		{
			return _addressPrimaryCountry;
		}

		public function set addressPrimaryCountry(value:String):void
		{
			_addressPrimaryCountry = value;
		}
		
		[Bindable] 
		public function get addressPrimaryStreet1():String
		{
			return _addressPrimaryStreet1;
		}

		public function set addressPrimaryStreet1(value:String):void
		{
			_addressPrimaryStreet1 = value;
		}
		
		[Bindable] 
		public function get addressPrimaryStreet2():String
		{
			return _addressPrimaryStreet2;
		}

		public function set addressPrimaryStreet2(value:String):void
		{
			_addressPrimaryStreet2 = value;
		}
		
		[Bindable] 
		public function get addressPrimaryCity():String
		{
			return _addressPrimaryCity;
		}

		public function set addressPrimaryCity(value:String):void
		{
			_addressPrimaryCity = value;
		}
		
		[Bindable] 
		public function get addressPrimaryRegion():String
		{
			return _addressPrimaryRegion;
		}

		public function set addressPrimaryRegion(value:String):void
		{
			_addressPrimaryRegion = value;
		}
		
		[Bindable] 
		public function get addressPrimaryPostCode():String
		{
			return _addressPrimaryPostCode;
		}

		public function set addressPrimaryPostCode(value:String):void
		{
			_addressPrimaryPostCode = value;
		}
	}
}