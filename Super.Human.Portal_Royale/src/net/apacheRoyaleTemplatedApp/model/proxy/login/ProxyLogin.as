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

	import services.NomadHelperUrlDelegate;
	import services.login.LoginServiceDelegate;

	import utils.UtilsCore;
	import org.apache.royale.utils.async.PromiseTask;
	import utils.NomadHelperUrlTasks;
	import org.apache.royale.utils.async.SequentialAsyncTask;
			
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
		
		protected var loginServiceDelegate:LoginServiceDelegate;
		private var nomadHelperUrlDelegate:NomadHelperUrlDelegate;
		
		private var username:String;
		private var proxyUrlParams:ProxyUrlParameters;
		private var busyManagerProxy:ProxyBusyManager;
		
		public function ProxyLogin()
		{
			super(NAME);
			
			loginServiceDelegate = new LoginServiceDelegate();
			nomadHelperUrlDelegate = new NomadHelperUrlDelegate(); 
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
			
			if (this.isNomadHelperUrlExists())
			{
				var nomadHelperUrlTasks:NomadHelperUrlTasks = new NomadHelperUrlTasks();
					nomadHelperUrlTasks.done(function(task:PromiseTask):void {
						if (nomadHelperUrlTasks.failed)
						{
							sendNotification(ProxyLogin.NOTE_LOGIN_SUCCESS, getData() as UserVO);
						}
						else if (nomadHelperUrlTasks.completed)
						{
							compareNomadHelperUrl(nomadHelperUrlTasks.completedTasks[0], nomadHelperUrlTasks.completedTasks[1]);
						}
					});
				nomadHelperUrlTasks.run(config.config.nomad_helper_url);
			}
			else
			{
				sendNotification(ProxyLogin.NOTE_LOGIN_SUCCESS, this.getData() as UserVO);
			}
			//ParseCentral.parseAppConfig(new XML(event.target["data"]));
		}

		private function onNomadHelperLoadSuccess(event:Event):void
		{
			nomadHelperUrlDelegate.getLocalNomadHelper(function onNomadHelperLocalSuccess(event:Event):void {
				sendNotification(ProxyLogin.NOTE_LOGIN_SUCCESS, this.getData() as UserVO);
			}, 
			function onFault(event:FaultEvent):void{
					sendNotification(ProxyLogin.NOTE_LOGIN_SUCCESS, this.getData() as UserVO);
			});
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

		private function compareNomadHelperUrl(nomadHelperUrlTask:PromiseTask, nomadHelperUrlTask2:PromiseTask):void
		{
			var nomadHelperUrlHash:PromiseTask = UtilsCore.computeHash(nomadHelperUrlTask.result.target.responseText);
			var nomadHelperUrlHash2:PromiseTask = UtilsCore.computeHash(nomadHelperUrlTask2.result.target.responseText);
			
			var sequentialHashTask:SequentialAsyncTask = new SequentialAsyncTask([
				nomadHelperUrlHash,
				nomadHelperUrlHash2
			]);
			
			sequentialHashTask.done(function(task:PromiseTask) {
				if (sequentialHashTask.failed)
				{
					sendNotification(ProxyLogin.NOTE_LOGIN_SUCCESS, getData() as UserVO);
				}
				else 
				{
					if (sequentialHashTask.completed)
					{
						var hash1:String = sequentialHashTask.completedTasks[0].data;
						var hash2:String = sequentialHashTask.completedTasks[1].data;
						
						sendNotification(ProxyLogin.NOTE_LOGIN_SUCCESS, getData() as UserVO);
					}
				}
			})
			sequentialHashTask.run();
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