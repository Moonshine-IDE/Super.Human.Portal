package model.proxy.login
{
	import classes.managers.ParseCentral;

	import model.proxy.busy.ProxyBusyManager;
	import model.vo.NewRegistrationVO;

	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.net.events.FaultEvent;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	import services.login.NewRegistrationServiceDelegate;

	import utils.RandomNumberUtil;
								
	public class ProxyNewRegistration extends Proxy
	{
		public static const NAME:String = "ProxyNewRegistration";
		public static const NOTE_NEWREGISTRATION_SUCCESS:String = NAME + "NoteNewRegistrationSuccess";
		public static const NOTE_NEWREGISTRATION_FAILED:String = NAME + "NoteNewRegistrationFailed";
		
		public static const NOTE_PHONE_COUNTRIES_LIST_FETCHED:String = NAME + "NotePhoneCountriesListFetched";
		public static const NOTE_PHONE_COUNTRIES_LIST_FETCH_FAILED:String = NAME + "NotePhoneCountriesListFetchFailed";
		
		private var newRegistrationServiceDelegate:NewRegistrationServiceDelegate;
		private var busyManagerProxy:ProxyBusyManager;
			
		private var _phoneCountries:ArrayList = new ArrayList();
			
		public function ProxyNewRegistration(dataUrl:String)
		{
			super(NAME);
			
			newRegistrationServiceDelegate = new NewRegistrationServiceDelegate(dataUrl);
		}

		override public function onRegister():void
		{
			super.onRegister();
			
			busyManagerProxy = facade.retrieveProxy(ProxyBusyManager.NAME) as ProxyBusyManager;	
		}		
		
		public function get newRegistration():NewRegistrationVO
		{
			return getData() as NewRegistrationVO;	
		}	
		
		public function get phoneCountries():ArrayList
		{
			return _phoneCountries;	
		}		
		
		public function generateSupportPin():void
		{
			this.newRegistration.supportPin = String(RandomNumberUtil.getRandomRangeNumber(1000, 9999)); 	
		}		
		
		public function register():void
		{
			var successCallback:Function = this.busyManagerProxy.wrapSuccessFunction(onRegisterSuccess);
			var failureCallback:Function = this.busyManagerProxy.wrapFailureFunction(onRegisterFailed);
			
			newRegistrationServiceDelegate.register(newRegistration.toRequestObject(), successCallback, failureCallback);
		}
		
		public function getPhoneCountries():void
		{
			var successCallback:Function = this.busyManagerProxy.wrapSuccessFunction(onFetchPhoneCountries);
			var failureCallback:Function = this.busyManagerProxy.wrapFailureFunction(onFetchPhoneCountriesFailed);
			
			newRegistrationServiceDelegate.fetchPhoneCountries(successCallback, failureCallback);
		}		
		
		private function onRegisterSuccess(event:Event):void
		{
			var fetchedData:String = event.target["data"];
			if (fetchedData)
			{
				var xmlData:XML = new XML(fetchedData);
				
				var errorMessage:String = xmlData["ErrorMessage"].toString();
				
				if (!errorMessage)
				{
					sendNotification(NOTE_NEWREGISTRATION_SUCCESS);
				}
				else
				{
					sendNotification(NOTE_NEWREGISTRATION_FAILED, errorMessage);
				}
			}
			else
			{
				sendNotification(NOTE_NEWREGISTRATION_FAILED, "Failed to register new user.");
			}
		}	
		
		private function onRegisterFailed(event:FaultEvent):void
		{
			sendNotification(NOTE_NEWREGISTRATION_FAILED, "Failed to register new user: " + event.message.toLocaleString());
		}	
		
		private function onFetchPhoneCountries(event:Event):void
		{
			var fetchedData:String = event.target["data"];
			if (fetchedData)
			{
				var xmlData:XML = new XML(fetchedData);
				
				var errorMessage:String = xmlData["ErrorMessage"].toString();
				
				if (!errorMessage)
				{
					ParseCentral.parseCountries(xmlData, phoneCountries);
					sendNotification(NOTE_PHONE_COUNTRIES_LIST_FETCHED, phoneCountries);
				}
				else
				{
					sendNotification(NOTE_PHONE_COUNTRIES_LIST_FETCH_FAILED, "Failed fetch phone countries: " + errorMessage);
				}
			}
			else
			{
				sendNotification(NOTE_PHONE_COUNTRIES_LIST_FETCH_FAILED, "Failed fetch phone countries.");
			}
		}	
		
		private function onFetchPhoneCountriesFailed(event:FaultEvent):void
		{
			sendNotification(NOTE_PHONE_COUNTRIES_LIST_FETCH_FAILED, "Failed fetch phone countries: " + event.message.toLocaleString());
		}		
	}
}