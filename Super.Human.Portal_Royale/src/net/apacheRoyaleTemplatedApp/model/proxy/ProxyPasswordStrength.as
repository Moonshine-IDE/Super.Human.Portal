package model.proxy
{
	import interfaces.IDisposable;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	public class ProxyPasswordStrength extends Proxy implements IDisposable
	{
		public static const NAME:String = "ProxyPasswordStrength";
		
		private static const SPECIAL_CHARS:String = "\"_-!#\\?<>\',*/&%()$:=;¦|^`~£[]{}.@+";
		
		public function ProxyPasswordStrength()
		{
			super(NAME);
		}
		
		public function dispose(force:Boolean):void
		{
			_valid = false;
		}
		
		private var _passwordMessage:String;
		public function get passwordMessage():String
		{
			return _passwordMessage;	
		}
		
		private var _valid:Boolean;
		public function get valid():Boolean
		{
			return _valid;
		}
		
		public function getPasswordStrength(password:String):Number
		{
			_passwordMessage = "";
			_valid = false;
	
			var barSize:int = 0;
			var pwdLength:Number = password.length;
			
			if (password == "")
			{
				_passwordMessage = "Please enter a password";
				barSize = 0;
			}
			else
			{
				_passwordMessage = "";
				_valid = true;
				
				if (password.indexOf("\t") > -1)
				{
					_passwordMessage = "INVALID - One or more characters are invalid";
					barSize = 200;
					_valid = false;
				}
				
				if (containsNumbers(password) == false) 
				{
					_passwordMessage = "WEAK - Use one or more numbers";
					barSize = 98;
					_valid = false;
				}
				
				if (isNumeric(password) == true) 
				{
					_passwordMessage = "WEAK - Use one or more characters, not just numbers";
					barSize = 40;
					_valid = false;
				}

				if (pwdLength < 6) 
				{
					_passwordMessage = "INVALID -Too short";
					barSize = 10;
					_valid=false;
				}
				
				if (_valid == true && pwdLength < 8) 
				{
					barSize = 160;
					_passwordMessage = "OK - Add a few more characters to make more secure";
				}
				if (_valid == true && pwdLength < 10) 
				{
					barSize = 190;
					_passwordMessage = "OK - Add a few more characters to make more secure";
				}
				if (_valid == true && pwdLength >= 10 && containsSpecial(password))
				{
					barSize = 200;
					_passwordMessage = "OK - Excellent choice";
				}
				if (_valid == true && pwdLength >= 10 && !containsSpecial(password))
				{
					barSize = 196;
					_passwordMessage = "OK - Consider adding a punctuation symbol to enhance security"
				}
			}
			
			return barSize;
		}
	
		private function containsNumbers(value:String):Boolean 
		{
			for (var i:int = 0; i < value.length; i++)
			{
				for (var j:int = 0; j < 10; j++)
				{
					if (value.charAt(i) == String(j))
					{
						return true;
					}
				} 
			}
			return false;
		}
		
		private function isNumeric(value:String):Boolean
		{
			var isAllNumbers:Boolean = true;
			for (var i:int = 0; i < value.length; i++)
			{
				if ( isNaN(Number(value.charAt(i))) ) 
				{
					isAllNumbers = false;
					break;
				}
			}
			return isAllNumbers;
		}
		
		private function containsSpecial(value:String):Boolean
		{
			for (var i:int = 0; i < value.length; i++)
			{
				for (var j:int = 0; j < SPECIAL_CHARS.length; j++)
				{
					if (value.charAt(i) == SPECIAL_CHARS.charAt(j))
					{
						return true;
					}
				} 
			}
			return false;
		}	
	}
}