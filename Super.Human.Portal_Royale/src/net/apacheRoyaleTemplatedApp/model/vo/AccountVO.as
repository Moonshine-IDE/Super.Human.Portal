/**
 * AccountVO
 * 
 *
 * Copyright @ - Prominic
 * @author santanu.k
 *
 * @date 04.20.2009
 * @version 0.1
 */
package model.vo {
	
	import org.apache.royale.collections.ArrayList;
	
	[Bindable] 
	public class AccountVO {
		
		// ---------------------------------------
		// PRIVATE VARIABLES
		// ---------------------------------------
		
		private var _itemID:int;
		private var _customerID:String;
		private var _nickName:String;
		private var _companyName:String;
		private var _companyURL:String;
		private var _roles:String;
		private var _isVBOXavailable:Boolean;
		private var _isAutoInstallAvailable:Boolean;
		private var _isCloseAccountEnabled:Boolean = false;
		private var _isUpdateCreditCardEnabled:Boolean = false;
		private var _isAllowNet30:Boolean = false;

		private var _isVMNebulaAccess:Boolean;
		private var _billingAddress:BillingVO;
		private var _shippingAddress:BillingVO;
		private var _cardType:String;
		private var _cardNumber:Number;
		private var _holderName:String;
		private var _expMonth:String;
		private var _expYear:String;
		private var _contracts:ArrayList = new ArrayList();
		
		/**
		 * CONSTRUCTOR
		 */
		public function AccountVO(itemID:int, customerID:String, nickName:String, companyName:String, companyURL:String ) 
		{
			this.itemID = itemID;
			this.customerID = customerID;
			this.nickName = nickName;
			this.companyName = companyName;
			this.companyURL = companyURL;
		}
		
		
		// ---------------------------------------
		// GET / SET
		// ---------------------------------------
		
		public function set itemID(value:int):void 
		{
			_itemID = value;
		}
		
		public function get itemID():int 
		{
			return _itemID;
		}
		
		public function set customerID(value:String):void 
		{
			_customerID = value;
		}
		
		public function get customerID():String 
		{
			return _customerID;
		}
		
		public function set nickName(value:String):void 
		{
			_nickName = value;
		}
		
		public function get nickName():String 
		{
			return _nickName;
		}
		
		public function set companyName(value:String):void 
		{
			_companyName = value;
		}
		
		public function get companyName():String 
		{
			return _companyName;
		}
		
		public function set companyURL(value:String):void
		{
			_companyURL = value;
		}
		
		public function get companyURL():String 
		{
			return _companyURL;
		}
		
		public function set roles(value:String):void 
		{
			_roles = value;
		}
		
		public function get roles():String 
		{
			return _roles;
		}
		
		public function set isVBOXavailable(value:Boolean):void 
		{
			_isVBOXavailable = value;
		}
		
		public function get isVBOXavailable():Boolean 
		{
			return _isVBOXavailable;
		}
		
		public function set isAutoInstallAvailable(value:Boolean):void
		{
			_isAutoInstallAvailable = value;
		}
		
		public function get isAutoInstallAvailable():Boolean 
		{
			return _isAutoInstallAvailable;
		}
		
		public function set isCloseAccountEnabled(value:Boolean):void
		{
			_isCloseAccountEnabled = value;
		}
		
		public function get isCloseAccountEnabled():Boolean 
		{
			return _isCloseAccountEnabled;
		}
			
		public function get isUpdateCreditCardEnabled():Boolean 
		{
			return _isUpdateCreditCardEnabled;
		}		
		
		public function set isUpdateCreditCardEnabled(value:Boolean):void 
		{
			_isUpdateCreditCardEnabled = value;
		}
		
		
		public function get isAllowNet30():Boolean
		{
			return _isAllowNet30;
		}

		public function set isAllowNet30(value:Boolean):void
		{
			_isAllowNet30 = value;
		}
		
		public function set isVMNebulaAccess(value:Boolean):void 
		{
			_isVMNebulaAccess = value;
		}
		
		public function get isVMNebulaAccess():Boolean 
		{
			return _isVMNebulaAccess;
		}
		
		public function set cardType(value:String):void 
		{
			_cardType = value;
		}
		
		public function get cardType():String 
		{
			return _cardType;
		}
		
		public function set cardNumber(value:Number):void 
		{
			_cardNumber = value;
		}
		
		public function get cardNumber():Number 
		{
			return _cardNumber;
		}
		
		public function set holderName(value:String):void 
		{
			_holderName = value;
		}
		
		public function get holderName():String 
		{
			return _holderName;
		}
		
		public function set expMonth(value:String):void
		{
			_expMonth = value;
		}
		
		public function get expMonth():String 
		{
			return _expMonth;
		}
		
		public function set expYear(value:String):void
		{
			_expYear = value;
		}
		
		public function get expYear():String 
		{
			return _expYear;
		}
		
		public function set contracts(value:ArrayList):void 
		{
			_contracts = value;
		}
		
		public function get contracts():ArrayList
		{
			return _contracts;
		}
		
		public function set billingAddress(value:BillingVO):void 
		{
			_billingAddress = value;
		}
		
		public function get billingAddress():BillingVO 
		{
			return _billingAddress;
		}
		
		public function set shippingAddress(value:BillingVO):void 
		{
			_shippingAddress = value;
		}
		
		public function get shippingAddress():BillingVO 
		{
			return _shippingAddress;
		}
		
		public function get displayLabel():String
		{
			if (this.nickName)
			{
				if (this.customerID)
				{
					return this.customerID + ' - ' + this.nickName;
				}
				else
				{
					return this.nickName;
				}
			}
			else
			{
				return this.customerID;
			}
		}
	}
	
}