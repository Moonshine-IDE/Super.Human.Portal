package model.proxy
{
	import classes.managers.ParseCentral;

	import interfaces.IDisposable;

	import model.proxy.busy.ProxyBusyManager;
	import model.proxy.login.ProxyLogin;
	import model.vo.BillingVO;
	import model.vo.NewAccountRequestVO;

	import org.apache.royale.net.events.FaultEvent;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	import services.CreateAccountDelegates;
			
	public class ProxyCreateAccount extends Proxy implements IDisposable
	{
		public static const NAME:String = "ProxyCreateAccount";
		
		public static const NOTE_CREATE_ACCT_REQUEST_SUBMITTED:String = NAME + "NoteCreateAccountRequestSubmitted";
		public static const NOTE_CREATE_ACCT_REQUEST_FAILED:String = NAME + "NoteCreateAccountRequestFailed";
		public static const NOTE_ACCOUNTS_LOAD_SUCCESS:String = NAME + "NoteAccountsLoadSuccess";
		
		private var loginProxy:ProxyLogin;
		private var sessionCheckProxy:ProxySessionCheck;
		private var createAccountDelegate:CreateAccountDelegates;
		private var busyManagerProxy:ProxyBusyManager;
		
		public function ProxyCreateAccount(dataUrl:String)
		{
			super(NAME);
			
			createAccountDelegate = new CreateAccountDelegates(dataUrl);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			busyManagerProxy = facade.retrieveProxy(ProxyBusyManager.NAME) as ProxyBusyManager;
			sessionCheckProxy = facade.retrieveProxy(ProxySessionCheck.NAME) as ProxySessionCheck;
		}
		
		public function dispose(force:Boolean):void
		{
			newBillingAddress = null;
			preseveFormData = false;
			requireAccountReload = false;

			if (force)
			{
				sessionCheckProxy.dispose(force);
			}
		}
		
		private var _newBillingAddress:BillingVO;
		public function get newBillingAddress():BillingVO
		{
			return _newBillingAddress;
		}
		public function set newBillingAddress(value:BillingVO):void
		{
			_newBillingAddress = value;
		}
		
		private var _preseveFormData:Boolean;
		public function get preseveFormData():Boolean
		{
			return _preseveFormData;
		}
		public function set preseveFormData(value:Boolean):void
		{
			_preseveFormData = value;
		}
		
		private var _requireAccountReload:Boolean;
		public function get requireAccountReload():Boolean
		{
			return _requireAccountReload;
		}
		public function set requireAccountReload(value:Boolean):void
		{
			_requireAccountReload = value;
		}

		public function get formRequest():NewAccountRequestVO
		{
			return (super.getData() as NewAccountRequestVO);
		}
		
		public function getAccounts():void
		{
			loginProxy = facade.retrieveProxy(ProxyLogin.NAME) as ProxyLogin;
			loginProxy.getAccounts(onAccountsLoaded);
		}
		
		public function submitRequest():void
		{
			var successCallback:Function = this.busyManagerProxy.wrapSuccessFunction(onRequestSubmitted);
			var failureCallback:Function = this.busyManagerProxy.wrapFailureFunction(onSubmitFailed);
			
			createAccountDelegate.submitRequest(formRequest.toRequestObject(), successCallback, failureCallback);
		}
		
		private function onAccountsLoaded(event:Event):void
		{
			ParseCentral.parseAccounts(new XML(event.target["data"]));
			sendNotification(NOTE_ACCOUNTS_LOAD_SUCCESS);
		}
		
		private function onRequestSubmitted(event:Event):void
		{
			var fetchedData:String = event.target["data"];
			if (fetchedData)
			{
				var xmlDetails:XML = new XML(fetchedData);
				if (!sessionCheckProxy.checkUserSession(xmlDetails))
				{
					return;
				}
				
				var errorMessage:String = xmlDetails["ErrorMessage"].toString();
				
				if (!errorMessage)
				{
					sendNotification(NOTE_CREATE_ACCT_REQUEST_SUBMITTED, xmlDetails["successMessage"].text());
				}
				else
				{
					sendNotification(NOTE_CREATE_ACCT_REQUEST_FAILED, "Submission failed: " + errorMessage);
				}
			}
			else
			{
				sendNotification(NOTE_CREATE_ACCT_REQUEST_FAILED, "Submitting Create New Account Request failed.");
			}
		}
		
		private function onSubmitFailed(event:FaultEvent):void
		{
			sendNotification(NOTE_CREATE_ACCT_REQUEST_FAILED, "Submission failed: " + event.message.toLocaleString());
		}
	}
}