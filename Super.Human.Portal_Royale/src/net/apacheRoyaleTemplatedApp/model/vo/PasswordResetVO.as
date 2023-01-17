package model.vo
{
	[Bindable]
	public class PasswordResetVO  
	{
		public function PasswordResetVO(email:String = null, code:String = null, password:String = null):void
		{
			this.email = email;
			this.code = code;
			this.code = code;	
		}		
		
		private var _email:String;
		public function get email():String
		{
			return _email;
		}

		public function set email(value:String):void
		{
			_email = value;
		}
		
		private var _code:String;
		public function get code():String
		{
			return _code;
		}

		public function set code(value:String):void
		{
			_code = value;
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
		
		private var _passwordConfirm:String;
		public function get passwordConfirm():String
		{
			return _passwordConfirm;
		}

		public function set passwordConfirm(value:String):void
		{
			_passwordConfirm = value;
		}
	}
}