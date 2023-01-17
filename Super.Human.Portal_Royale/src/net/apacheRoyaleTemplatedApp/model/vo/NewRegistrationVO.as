package model.vo
{
	[Bindable]
	public class NewRegistrationVO
	{
		private var _firstName:String;
		public function get firstName():String
		{
			return _firstName;
		}

		public function set firstName(value:String):void
		{
			_firstName = value;
		}
		
		private var _lastName:String;
		public function get lastName():String
		{
			return _lastName;
		}

		public function set lastName(value:String):void
		{
			_lastName = value;
		}
		
		private var _primaryEmailAddress:String;
		public function get primaryEmailAddress():String
		{
			return _primaryEmailAddress;
		}

		public function set primaryEmailAddress(value:String):void
		{
			_primaryEmailAddress = value;
		}
		
		private var _alternateEmailAddress:String;
		public function get alternateEmailAddress():String
		{
			return _alternateEmailAddress;
		}

		public function set alternateEmailAddress(value:String):void
		{
			_alternateEmailAddress = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  PRIMARY PHONE NUMBER
		//
		//--------------------------------------------------------------------------
		
		private var _typePrimaryPhone:String;
		public function get typePrimaryPhone():String
		{
			return _typePrimaryPhone;
		}
		
		public function set typePrimaryPhone(value:String):void 
		{
			_typePrimaryPhone = value;
		}
		
		private var _idcPrimaryPhone:String;
		public function get idcPrimaryPhone():String
		{
			return _idcPrimaryPhone;
		}
		
		public function set idcPrimaryPhone(value:String):void 
		{
			_idcPrimaryPhone = value;
		}
		
		private var _areaCodePrimaryPhone:String;
		public function get areaCodePrimaryPhone():String 
		{
			return _areaCodePrimaryPhone;
		}
		
		public function set areaCodePrimaryPhone(value:String):void 
		{
			_areaCodePrimaryPhone = value;
		}
				
		private var _primaryPhoneNumber:String;
		public function get primaryPhoneNumber():String
		{
			return _primaryPhoneNumber;
		}

		public function set primaryPhoneNumber(value:String):void
		{
			_primaryPhoneNumber = value;
		}
		
		private var _extensionPrimaryPhone:String;
		public function set extensionPrimaryPhone(value:String):void 
		{
			_extensionPrimaryPhone = value;
		}
		
		public function get extensionPrimaryPhone():String 
		{
			return _extensionPrimaryPhone;
		}
		
		//--------------------------------------------------------------------------
		//
		//  SECONDARY PHONE NUMBER
		//
		//--------------------------------------------------------------------------
		
		private var _typeSecondaryPhone:String;
		public function get typeSecondaryPhone():String
		{
			return _typeSecondaryPhone;
		}
		
		public function set typeSecondaryPhone(value:String):void 
		{
			_typeSecondaryPhone = value;
		}
		
		private var _idcSecondaryPhone:String;
		public function get idcSecondaryPhone():String
		{
			return _idcSecondaryPhone;
		}
		
		public function set idcSecondaryPhone(value:String):void 
		{
			_idcSecondaryPhone = value;
		}
		
		private var _areaCodeSecondaryPhone:String;
		public function get areaCodeSecondaryPhone():String 
		{
			return _areaCodeSecondaryPhone;
		}
		
		public function set areaCodeSecondaryPhone(value:String):void 
		{
			_areaCodeSecondaryPhone = value;
		}
				
		private var _secondaryPhoneNumber:String;
		public function get secondaryPhoneNumber():String
		{
			return _secondaryPhoneNumber;
		}

		public function set secondaryPhoneNumber(value:String):void
		{
			_secondaryPhoneNumber = value;
		}
		
		private var _extensionSecondaryPhone:String;
		public function set extensionSecondaryPhone(value:String):void 
		{
			_extensionSecondaryPhone = value;
		}
		
		public function get extensionSecondaryPhone():String 
		{
			return _extensionSecondaryPhone;
		}
		
		private var _supportPin:String;
		public function get supportPin():String
		{
			return _supportPin;
		}

		public function set supportPin(value:String):void
		{
			_supportPin = value;
		}
		
		private var _password:String;
		public function get password():String
		{
			return _password;
		}

		public function set password(value:String):void
		{
			_password = value;
		}
		
		private var _confirmPassword:String;
		public function get confirmPassword():String
		{
			return _confirmPassword;
		}

		public function set confirmPassword(value:String):void
		{
			_confirmPassword = value;
		}
		
		private var _secretQuestion:String;
		public function get secretQuestion():String
		{
			return _secretQuestion;
		}

		public function set secretQuestion(value:String):void
		{
			_secretQuestion = value;
		}
		
		private var _secretAnswer:String;
		public function get secretAnswer():String
		{
			return _secretAnswer;
		}

		public function set secretAnswer(value:String):void
		{
			_secretAnswer = value;
		}
		
		public function toRequestObject():Object
		{
			var requestObj:Object = {
				nameFirst: this.firstName,
				nameLast: this.lastName,
				emailPrimary: this.primaryEmailAddress,
				emailAlternate: this.alternateEmailAddress,
				phonePrimaryType: this.typePrimaryPhone,
				phonePrimaryIDCPick: this.idcPrimaryPhone,
				phonePrimaryAreaCode: this.areaCodePrimaryPhone,
				phonePrimaryNumber: this.primaryPhoneNumber,
				phonePrimaryExtension: this.extensionPrimaryPhone,
				phoneAlternate1Type: this.typeSecondaryPhone,
				phoneAlternate1IDCPick: this.idcSecondaryPhone,
				phoneAlternate1AreaCode: this.areaCodeSecondaryPhone,
				phoneAlternate1Number: this.secondaryPhoneNumber,
				phoneAlternate1Extension: this.extensionSecondaryPhone,
				SupportPIN: this.supportPin,
				password: this.password,
				passwordConfirm: this.confirmPassword,
				secretQuestion: this.secretQuestion,
				secretAnswer: this.secretAnswer
			};
			
			if (!this.secondaryPhoneNumber)
			{
				requestObj.phoneAlternate1Type = "";
				requestObj.phoneAlternate1IDCPick = "";
				requestObj.phoneAlternate1AreaCode = "";
				requestObj.phoneAlternate1Number = "";
				requestObj.phoneAlternate1Extension = "";
			}
			
			return requestObj;
		}
	}
}