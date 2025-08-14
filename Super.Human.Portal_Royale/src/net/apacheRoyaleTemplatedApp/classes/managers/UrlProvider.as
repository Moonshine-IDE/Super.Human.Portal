package classes.managers
{
	public class UrlProvider  
	{
		public static const LOGIN_REDIRECTION:String = "SuperHumanPortal.nsf/XMLAuthenticationTest?OpenAgent"; // Authentication Check
		public static const APP_LOCAL_VERSION_URL:String = "resources/version.xml";
		public static const NOMAD_HELPER_FILE_URL:String = "resources/nomadhelper.html";
		public static const DEFAULT_LOGOUT_URL:String = "/names.nsf?logout";

		private static var _instance:UrlProvider;
				
    		public function UrlProvider() 
		{
	        if(_instance) 
			{
	            throw new Error("UrlProvider... use getInstance()");
	        	} 
        		_instance = this;
    		}

	    public static function getInstance():UrlProvider 
		{
	        if(!_instance)
			{
	            new UrlProvider();
	        } 
  
	        return _instance;
	    }
	
		private var _loginUser:String = "/names.nsf?login";
		
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
		
		private var _logoutUser:String = DEFAULT_LOGOUT_URL;
		
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

		private var _configagent:String = "/SuperHumanPortal.nsf/ConfigRead?OpenAgent";

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
		
		private var _genesisDirsGetAll:String = "/SuperHumanPortal.nsf/GenesisDirectoryRead?OpenAgent";

		public function get genesisDirsGetAll():String
		{
			return _genesisDirsGetAll;
		}
		
		private var _genesisDirCreate:String = "/SuperHumanPortal.nsf/GenesisDirectoryCreate?OpenAgent";

		public function get genesisDirCreate():String
		{
			return _genesisDirCreate;
		}
		
		private var _genesisDirUpdate:String = "/SuperHumanPortal.nsf/GenesisDirectoryUpdate?OpenAgent";

		public function get genesisDirUpdate():String
		{
			return _genesisDirUpdate;
		}
		
		private var _genesisDirDelete:String = "/SuperHumanPortal.nsf/GenesisDirectoryDelete?OpenAgent";

		public function get genesisDirDelete():String
		{
			return _genesisDirDelete;
		}
		
		private var _genesisCatalogInstall:String = "/SuperHumanPortal.nsf/GenesisInstall?OpenAgent";

		public function get genesisCatalogInstall():String
		{
			return _genesisCatalogInstall;
		}
		
		private var _bookmarksGetAll:String = "/SuperHumanPortal.nsf/CustomBookmarkRead?OpenAgent";

		public function get bookmarksGetAll():String
		{
			return _bookmarksGetAll;
		}
		
		private var _bookmarksDelete:String = "/SuperHumanPortal.nsf/CustomBookmarkDelete?OpenAgent";

		public function get bookmarksDelete():String
		{
			return _bookmarksDelete;
		}
		
		private var _bookmarksCreate:String = "/SuperHumanPortal.nsf/CustomBookmarkCreate?OpenAgent";

		public function get bookmarksCreate():String
		{
			return _bookmarksCreate;
		}
		
		private var _bookmarksUpdate:String = "/SuperHumanPortal.nsf/CustomBookmarkUpdate?OpenAgent";

		public function get bookmarksUpdate():String
		{
			return _bookmarksUpdate;
		}
		
		private var _databaseRead:String = "/SuperHumanPortal.nsf/DatabaseRead?OpenAgent";

		public function get databaseRead():String
		{
			return _databaseRead;
		}
		
		private var _categoriesRead:String = "/SuperHumanPortal.nsf/CategoryRead?OpenAgent";

		public function get categoriesRead():String
		{
			return _categoriesRead;
		}
		
		private var _appVersion:String;
		
		public function setAppVersion(value:String):void
		{
			_appVersion = value == null || value.indexOf("${pom.version}") > -1 ? "5.6.0" : value;
		}
	}
}