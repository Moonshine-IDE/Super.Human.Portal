package classes.managers
{
	public class UrlProvider  
	{
		public static const LOGIN_REDIRECTION:String = "SuperHumanPortal.nsf/XMLAuthenticationTest?OpenAgent"; // Authentication Check
		public static const APP_LOCAL_VERSION_URL:String = "resources/version.xml";
		
		private static var _instance:UrlProvider;
				
    		public function UrlProvider() 
		{
	        if(_instance) 
			{
	            throw new Error("UrlProvider... use getInstance()");
	        	} 
        		_instance = this;
    		}

	    public static function getInstance(version:String = null):UrlProvider 
		{
	        if(!_instance)
			{
	            new UrlProvider();
	        } 
	        
	        if (version)
	        {
        		   _instance.setAppVersion(version);		
	        }	
	                
	        return _instance;
	    }
	
		private var _loginUser:String;
		
		/**
		 * authentication check
		 **/
		public function get loginUser():String
		{
			return _loginUser;
		}

		public function set loginUser(value:String):void
		{
			_loginUser = value;
		} 
		
		private var _logoutUser:String;
		
		/**
		 * logout an user
		 **/
		public function get logoutUser():String
		{
			return _logoutUser;
		}

		public function set logoutUser(value:String):void
		{
			_logoutUser = value;
		} 

		private var _configagent:String;

		/**
		 * general configuration
		 **/
		public function get configagent():String
		{
			return _configagent;
		}

		public function set configagent(value:String):void
		{
			_configagent = value;
		} 
		
		private var _configagentNative:String;
		
		/**
		 * LTPA token URL and other information
		 */
		private var _serverMessage:String;
		
		public function get serverMessage():String
		{
			return _serverMessage;
		}

		public function set serverMessage(value:String):void
		{
			_serverMessage = value;
		}

		private var _accountsdataurl:String;
		
		/**
		 * logged-n users accounts
		 **/
		public function get accountsdataurl():String
		{
			return _accountsdataurl;
		}

		public function set accountsdataurl(value:String):void
		{
			_accountsdataurl = value;
		} 

		private var _accountsposturl:String;
		
		/**
		 *   new account creation
		 **/
		public function get accountsposturl():String
		{
			return _accountsposturl;
		}

		public function set accountsposturl(value:String):void
		{
			_accountsposturl = value;
		} 

		private var _genesisCatalogGetAll:String = "/SuperHumanPortal.nsf/GenesisRead?OpenAgent";

		public function get genesisCatalogGetAll():String
		{
			return _genesisCatalogGetAll;
		}
		
		private var _genesisCatalogInstall:String = "/SuperHumanPortal.nsf/GenesisInstall?OpenAgent";

		public function get genesisCatalogInstall():String
		{
			return _genesisCatalogInstall;
		}
		
		private var _appVersion:String;
		
		public function setAppVersion(value:String):void
		{
			_appVersion = value == null || value.indexOf("${pom.version}") > -1 ? "5.6.0" : value;
		}
		/**
		 * Sets the domain and URLs
		 */
		public function setDomain(value:String):void
		{
			loginUser = value +"/names.nsf?login"; // Authentication Check
			logoutUser = value + "/names.nsf?logout"; // Logout an user	
			configagent = value + "/SuperHumanPortal.nsf/ConfigRead?OpenAgent";
		}
	}
}