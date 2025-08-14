package model.vo
{
	public class UserVO  
	{
		public function UserVO(username:String, serverUsername:String, commonName:String, status:String, roles:Array = null, loginUrl:String = null, logoutUrl:String = null)
		{
			this.username = username;
			this.serverUsername = serverUsername;
			this.commonName = commonName;
			this.status = status;
			this.roles = roles;
			this.loginUrl = loginUrl;
			this.logoutUrl = logoutUrl;
		}
		
		private var _serverUsername:String;

		public function get serverUsername():String
		{
			return _serverUsername;
		}

		public function set serverUsername(value:String):void
		{
			_serverUsername = value;
		}
		
		private var _commonName:String;

		public function get commonName():String
		{
			return _commonName;
		}

		public function set commonName(value:String):void
		{
			_commonName = value;
		}
		
		private var _username:String;

		public function get username():String
		{
			return _username;
		}

		public function set username(value:String):void
		{
			_username = value;
		}
		
		private var _status:String;

		public function get status():String
		{
			return _status;
		}

		public function set status(value:String):void
		{
			_status = value;
		}
		
		private var _display:DisplayVO;

		[Bindable]
		public function get display():DisplayVO
		{
			return _display;
		}

		public function set display(value:DisplayVO):void
		{
			_display = value;
		}
		
		private var _roles:Array;

		public function get roles():Array
		{
			return _roles;
		}
		
		public function set roles(value:Array):void
		{
			_roles = value;
		}
		
		private var _loginUrl:String;

		public function get loginUrl():String
		{
			return _loginUrl;
		}
		
		public function set loginUrl(value:String):void
		{
			_loginUrl = value;
		}
		
		private var _logoutUrl:String;

		public function get logoutUrl():String
		{
			return _logoutUrl;
		}
		
		public function set logoutUrl(value:String):void
		{
			_logoutUrl = value;
		}

		public function hasRole(role:String):Boolean
		{
			if (!_roles || _roles.length == 0) return false;
			
			var someRole:Boolean = _roles.some(function(item:String, index:int, arr:Array):Boolean {
				return item == role;
			});
			
			return someRole;
		}
	}
}