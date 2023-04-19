package model.proxy
{
	import constants.ApplicationConstants;
	import constants.PopupType;

	import interfaces.IDisposable;

	import mediator.MediatorMainContentView;

	import model.proxy.busy.ProxyBusyManager;
	import model.proxy.login.ProxyLogin;
	import model.vo.PopupVO;

	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	import services.SessionCheckDelegate;
			
	public class ProxySessionCheck extends Proxy implements IDisposable
	{
		public static const NAME:String = "ProxySessionCheck";
		
		public static const NOTE_LTPA_LOAD_COMPLETED:String = NAME + "NoteLTPATokenLoadCompleted";
		public static const NOTE_LTPA_LOAD_FAILED:String = NAME + "NoteLTPATokenLoadFailed";
		
		private const SESSION_UNAUTHENTICATED: String = "session-not-authenticated";
		private const SESSION_AUTHENTICATED: String = "authenticated";
		private const SESSION_AUTHLIMITEDACCESS: String = "authenticated-with-insufficient-access";
		
		private var loginProxy:ProxyLogin;
		private var sessionDelegate:SessionCheckDelegate;
		private var busyManagerProxy:ProxyBusyManager;
		
		public function ProxySessionCheck()
		{
			super(NAME);
			sessionDelegate = new SessionCheckDelegate();
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			busyManagerProxy = facade.retrieveProxy(ProxyBusyManager.NAME) as ProxyBusyManager;
			loginProxy = facade.retrieveProxy(ProxyLogin.NAME) as ProxyLogin;
		}
		
		public function dispose(force:Boolean):void
		{
		}
		
		public function getLTPATokenFromServer():void
		{
			var successCallback:Function = this.busyManagerProxy.wrapSuccessFunction(onLTPAvaluesLoaded);
			var failureCallback:Function = this.busyManagerProxy.wrapFailureFunction();
			
			sessionDelegate.getLTPATokenFromServer(successCallback, failureCallback);
		}
		
		public function checkUserSession(xmlData:Object):Boolean
		{
			if (xmlData['status'] == SESSION_UNAUTHENTICATED)
			{	
				sendNotification(ApplicationConstants.COMMAND_SHOW_POPUP, 
				    new PopupVO(PopupType.WARNING, MediatorMainContentView.NAME, 
					"Your session has expired. Please log in again."));
				
				loginProxy.logout();
				return false;
			}

			if (xmlData['status'] == SESSION_AUTHLIMITEDACCESS)
			{
				sendNotification(ApplicationConstants.COMMAND_SHOW_POPUP,
				 	new PopupVO(PopupType.WARNING, MediatorMainContentView.NAME, 
					"You do not have sufficient rights to performn this operation. If you feel this is in error please contact <a href='mailto:Support@Prominic.NET'>Support@Prominic.NET</a>."));
			}
			
			return true;
		}
		
		private function onLTPAvaluesLoaded(event:Event):void
		{
			var fetchedData:String = event.target["data"];
			if (fetchedData)
			{
				var xmlData:XML = new XML(fetchedData);
				if (!checkUserSession(xmlData))
				{
					return;
				}
				
				var errorMessage:String = xmlData["ErrorMessage"].toString();
				
				if (!errorMessage)
				{
					setData({
						ltpaToken: String(xmlData["LTPAToken"]),
						htmlText: String(xmlData["htmlText"].toString()),
						notesIDMessage: String(xmlData["NotesIDMessage"])
					});
					sendNotification(NOTE_LTPA_LOAD_COMPLETED, xmlData);
				}
				else
				{
					setData(null);
					sendNotification(NOTE_LTPA_LOAD_FAILED, "LTPA token request failed: " + errorMessage);
				}
			}
			else
			{
				setData(null);
				sendNotification(NOTE_LTPA_LOAD_FAILED, "LTPA token request failed.");
			}
		}
	}
}