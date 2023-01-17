package model.vo
{
	[Bindable]
	public class NewAccountRequestVO  
	{
		private var _accountName:String;
		public function get accountName():String
		{
			return _accountName;
		}

		public function set accountName(value:String):void
		{
			_accountName = value;
		}
		
		private var _companyName:String;
		public function get companyName():String
		{
			return _companyName;
		}
		public function set companyName(value:String):void
		{
			_companyName = value;
		}

		private var _companyWebURL:String;
		public function get companyWebURL():String
		{
			return _companyWebURL;
		}
		public function set companyWebURL(value:String):void
		{
			_companyWebURL = value;
		}

		private var _cardType:String;
		public function get cardType():String
		{
			return _cardType;
		}
		public function set cardType(value:String):void
		{
			_cardType = value;
		}
		
		private var _cardNumber:String;
		public function get cardNumber():String
		{
			return _cardNumber;
		}
		public function set cardNumber(value:String):void
		{
			_cardNumber = value;
		}
		
		private var _cardHolderName:String;
		public function get cardHolderName():String
		{
			return _cardHolderName;
		}
		public function set cardHolderName(value:String):void
		{
			_cardHolderName = value;
		}
		
		private var _cardExpirationMonth:String;
		public function get cardExpirationMonth():String
		{
			return _cardExpirationMonth;
		}
		public function set cardExpirationMonth(value:String):void
		{
			_cardExpirationMonth = value;
		}
		
		private var _cardExpirationYear:String;
		public function get cardExpirationYear():String
		{
			return _cardExpirationYear;
		}
		public function set cardExpirationYear(value:String):void
		{
			_cardExpirationYear = value;
		}

		private var _dunAndBradstreetNumber:String;
		public function get dunAndBradstreetNumber():String
		{
			return _dunAndBradstreetNumber;
		}
		public function set dunAndBradstreetNumber(value:String):void
		{
			_dunAndBradstreetNumber = value;
		}
		
		private var _securityCode:String;
		public function get securityCode():String
		{
			return _securityCode;
		}
		public function set securityCode(value:String):void
		{
			_securityCode = value;
		}
		
		private var _billingAddress:BillingVO;
		public function get billingAddress():BillingVO
		{
			return _billingAddress;
		}
		public function set billingAddress(value:BillingVO):void
		{
			_billingAddress = value;
		}

		public function toRequestObject():Object
		{
			return {
				AccountName: accountName,
				CompanyName: companyName,
				CompanyWebURL: companyWebURL,
				addressBillingName: billingAddress.userName,
				addressBillingCompany: billingAddress.companyName,
				addressBillingStreet1: billingAddress.addressPrimaryStreet1,
				addressBillingStreet2: billingAddress.addressPrimaryStreet2,
				addressBillingCity: billingAddress.addressPrimaryCity,
				addressBillingRegion: billingAddress.addressPrimaryRegion,
				addressBillingPostCode: billingAddress.addressPrimaryPostCode,
				addressBillingCountry: billingAddress.addressPrimaryCountry,
				cardType: cardType,
				cardNumber: cardNumber,
				cardHolderName: cardHolderName,
				cardExpirationMonth: cardExpirationMonth,
				cardExpirationYear: cardExpirationYear,
				dunAndBradstreetNumber: dunAndBradstreetNumber,
				cardCVV2Code: securityCode,
				CancellationTerms: true
			}
		}
	}
}