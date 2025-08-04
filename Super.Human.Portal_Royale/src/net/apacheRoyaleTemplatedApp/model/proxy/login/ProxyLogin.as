package model.proxy.login
{
	import classes.managers.ParseCentral;

	import constants.ApplicationConstants;

	import model.proxy.busy.ProxyBusyManager;
	import model.proxy.urlParams.ProxyUrlParameters;
	import model.vo.UserVO;

	import org.apache.royale.events.Event;
	import org.apache.royale.net.events.FaultEvent;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	import services.login.LoginServiceDelegate;
	import model.vo.DisplayVO;
			
	public class ProxyLogin extends Proxy
	{
		public static const NAME:String = "ProxyLogin";
		public static const NOTE_LOGIN_SUCCESS:String = NAME + "NoteLoginSucces";
		public static const NOTE_LOGIN_FAILED:String = NAME + "NoteLoginFailed";
		public static const NOTE_LOGIN_FAILED_ON_SERVER:String = NAME + "NoteLoginFailedOnServer";
		public static const NOTE_LOGOUT_SUCCESS:String = NAME + "NoteLogoutSucces";
		public static const NOTE_ANONYMOUS_USER:String = NAME + "NoteAnonymousUser";
		public static const NOTE_INVALID_DOMINO_DOMAIN:String = NAME + "NoteInvalidDominoDomain";
		public static const NOTE_TEST_AUTHENTICATION_SUCCESS:String = NAME + "NoteTestAuthenticationSuccess";
		public static const NOTE_ACCOUNTS_LOAD_FAILED:String = NAME + "NoteAccountsLoadFailed";
		
		private const APP_IMPROVEMENT_REQUEST_BASE:String = "https://xd.prominic.net/app/apprequest.nsf/router";
		protected var loginServiceDelegate:LoginServiceDelegate;
	
		private var username:String;
		private var proxyUrlParams:ProxyUrlParameters;
		private var busyManagerProxy:ProxyBusyManager;
		
		public function ProxyLogin()
		{
			super(NAME);
			
			loginServiceDelegate = new LoginServiceDelegate();
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			busyManagerProxy = facade.retrieveProxy(ProxyBusyManager.NAME) as ProxyBusyManager;
			proxyUrlParams = facade.retrieveProxy(ProxyUrlParameters.NAME) as ProxyUrlParameters;
		}
		
		public function get user():UserVO
		{
			return this.getData() as UserVO;
		}
		
		private var _config:Object;
		
		public function get config():Object
		{
			return _config;	
		}
		
		public function getAppImprovementRequestUrl():URL
		{
			var url:URL = new URL(APP_IMPROVEMENT_REQUEST_BASE);
			url.searchParams.set("req", "sso");
			if (config)
			{
				url.searchParams.set("user", config.userInfo.name);
				url.searchParams.set("email", config.userInfo.email);
				url.searchParams.set("customerId", config.customer_id);
				url.searchParams.set("context", config.config.configuration_link.server + "|" +
															   config.config.configuration_link.database + "|" +
															   config.config.configuration_link.view);
			}
			
			// Manually construct the final URL to avoid '=' after openagent
			var finalUrl:String = url.href.replace("?", "?openagent&");
			return new URL(finalUrl);
		}
		
		public function isNomadHelperUrlExists():Boolean 
		{
			return config.config.nomad_helper_url != "";
		}
		
		public function testAuthentication():void
		{
			if (proxyUrlParams.isPasswordReset) return;
			
			var successCallback:Function = this.busyManagerProxy.wrapSuccessFunction(onXMLAuthTestSuccess);
			var failureCallback:Function = this.busyManagerProxy.wrapFailureFunction(onLoginFailed);
			
			loginServiceDelegate.testAuthentication(successCallback, failureCallback);
		}
		
		public function testAuthenticationWithoutBusyIndicator():void
		{
			if (proxyUrlParams.isPasswordReset) return;
			
			loginServiceDelegate.testAuthentication(onXMLAuthTestSuccess, onLoginFailed);
		}
		
		public function signin(userValue:String, passwordValue:String):void 
		{
			this.username = userValue;
            loginServiceDelegate.signin(userValue, passwordValue, onSignedIn, onLoginFailed);
		}
	
		public function logout():void
		{
			loginServiceDelegate.logout(onLogout);
		}
		
		public function forceLogout():void
		{
			//We are not interested in any logout results.
			loginServiceDelegate.logout(function (event:Event):void {
			
			 });	
		}
		
		public function getAccounts(resultCallback:Function=null):void
		{
			var successCallback:Function = this.busyManagerProxy.wrapSuccessFunction(resultCallback ? resultCallback : onAccountsLoadSuccess);
			var failureCallback:Function = this.busyManagerProxy.wrapFailureFunction(onAccountsLoadFailed);
			
			loginServiceDelegate.loadAccountsData(successCallback, failureCallback);
		}
		
		private function onXMLAuthTestSuccess(event:Event):void
		{
			var loginResult:Object = null;
			
			try
			{
				loginResult = JSON.parse(event.target.data);
			}
			catch (e:Object)
			{
				this.failOnServer(event.target.data);
				return;
			}
			
			var serverUserName:String = loginResult ? String(loginResult.username).toLowerCase() : null;
			
			if (serverUserName == "anonymous")
			{
				if (getData())
				{
					sendNotification(ProxyLogin.NOTE_LOGOUT_SUCCESS, {forceShow: false});
					sendNotification(ApplicationConstants.COMMAND_LOGOUT_CLEANUP);
				}
				else
				{
					parseUserAndConfigure(loginResult);
				}
			}
			else
			{
				// user have logged-in and session exists
				if (!getData())
				{
					this.onSignedIn(event);
				}
			}
		}		
		
		private function onSignedIn(event:Event):void
		{
			var eventData:String = String(event.target["data"]);
			if (eventData && eventData.indexOf("<html") != -1)
			{
				sendNotification(ProxyLogin.NOTE_LOGIN_FAILED, "You provided an invalid username or password. Please sign in again.");
				return;	
			}			
			
			var loginResult:Object = JSON.parse(event.target.data);
			parseUserAndConfigure(loginResult);
		}

		private function onGeneralConfigurationLoaded(event:Event):void
		{
			var config:Object = JSON.parse(event.target.data);
			if (!config) return;
			
			_config = config;
			
			sendNotification(ProxyLogin.NOTE_LOGIN_SUCCESS, this.getData() as UserVO);
			//ParseCentral.parseAppConfig(new XML(event.target["data"]));
		}

		private function onAccountsLoadSuccess(event:Event):void
		{
			ParseCentral.parseAccounts(new XML(event.target["data"]));
			sendNotification(ProxyLogin.NOTE_LOGIN_SUCCESS, this.getData() as UserVO);
		}
		
		private function onLoginFailed(event:FaultEvent):void
		{
			sendNotification(ProxyLogin.NOTE_LOGIN_FAILED, "You provided an invalid username or password. Please sign in again.");
		}
		
		private function onAccountsLoadFailed(event:FaultEvent):void
		{
			sendNotification(NOTE_ACCOUNTS_LOAD_FAILED, event.message.toLocaleString());
		}
		
		private function onLogout(event:Event):void
		{
			this.setData(null);
			this.username = null;
			sendNotification(ProxyLogin.NOTE_LOGOUT_SUCCESS, {forceShow: true});
			sendNotification(ApplicationConstants.COMMAND_LOGOUT_CLEANUP);
			proxyUrlParams.setData(null);
			
			this.testAuthenticationWithoutBusyIndicator();
		}

		private function failOnServer(data:Object):void
		{
			var eventData:String = String(data);
			if (eventData && eventData.indexOf("<html") != -1)
			{
				sendNotification(ProxyLogin.NOTE_LOGIN_FAILED_ON_SERVER, "You are logged in as an invalid user, or there is an error on the server. Please contact support if the problem persists.");
			}	
		}
		
		private function getGeneralConfiguration():void
		{
			loginServiceDelegate.loadGeneralConfiguration(onGeneralConfigurationLoaded, onLoginFailed);
		}

		private function parseUserAndConfigure(loginResult:Object):void
		{
			_config = null;
			
			var serverUserName:String = loginResult.username;
			var commonName:String = loginResult.common_name;
			var status:String = loginResult.status ? loginResult.state : "";
			var roles:Array = loginResult.roles ? loginResult.roles : [];
			
			if (status.toLowerCase() == "authenticated")
			{
				if (!username)
				{
					username = serverUserName;
				}
				
				var user:UserVO = new UserVO(username, serverUserName, commonName, status, roles, loginResult.loginURL);
					user.display = new DisplayVO();
				if (loginResult.display)
				{
					user.display.additionalGenesis = loginResult.display.additionalGenesis;
					user.display.browseMyServer = loginResult.display.browseMyServer;
					user.display.documentation = loginResult.display.documentation;
					user.display.installApps = loginResult.display.installApps;
					user.display.manageBookmarks = loginResult.display.manageBookmarks;
					user.display.manageDocumentation = loginResult.display.manageDocumentation;
					user.display.viewBookmarks = loginResult.display.viewBookmarks;
					user.display.viewDocumentation = loginResult.display.viewDocumentation;
					user.display.viewInstalledApps = loginResult.display.viewInstalledApps;
					user.display.improvementRequests = loginResult.display.improvementRequests;
				}
				this.setData(user);
				
				// get all the configuration before
				// starting the applicaiton
				getGeneralConfiguration();
			}
			else
			{
				sendNotification(NOTE_ANONYMOUS_USER, {loginUrl: loginResult.loginURL});
			}
		}
	}
}