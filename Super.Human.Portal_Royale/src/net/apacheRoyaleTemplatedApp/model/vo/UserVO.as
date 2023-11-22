package model.vo
{
	public class UserVO  
	{
		public function UserVO(username:String, serverUsername:String, commonName:String, status:String, roles:Array = null)
		{
			this.username = username;
			this.serverUsername = serverUsername;
			this.commonName = commonName;
			this.status = status;
			this.roles = roles;
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
		
		private var _roles:Array;

		public function get roles():Array
		{
			return _roles;
		}
		
		public function set roles(value:Array):void
		{
			_roles = value;
		}
	}
}