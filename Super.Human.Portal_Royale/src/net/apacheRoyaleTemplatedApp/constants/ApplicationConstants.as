package constants
{
	public class ApplicationConstants
	{
		//----------------------------------
		// Common app constants
		//----------------------------------
		public static const NAME:String = "Native";
		public static const SEPARATOR:String = "/";

		//----------------------------------
		// Events
		//----------------------------------

		//----------------------------------
		// States
		//----------------------------------

		//---------------------------------
		// Names
		//----------------------------------		
		
		//----------------------------------
		// Notifications
		//----------------------------------
		
		//Menu
		public static const NOTE_SHOW_POPUP:String = NAME + SEPARATOR + "ShowPopup";
		public static const NOTE_HIDE_POPUP:String = NAME + SEPARATOR + "HidePopup";
		
		public static const NOTE_OK_POPUP:String = NAME + SEPARATOR + "OKPopup";
		public static const NOTE_CANCEL_POPUP:String = NAME + SEPARATOR + "CancelPopup";
		
		public static const NOTE_CONTACTS_DATA_UPDATED:String = NAME + SEPARATOR + "NoteContactsDataUpdated";

		public static const NOTE_OPEN_NEW_ACCOUNT_REQUEST:String = NAME + SEPARATOR + "NoteOpenNewAccountRequest";
		public static const NOTE_OPEN_NEW_ADDRESS_REQUEST:String = NAME + SEPARATOR + "NoteOpenNewAddressRequest";

		public static const NOTE_REMOVE_INTERNET_DOMAINS_DETAILS:String = NAME + SEPARATOR + "NoteCleanInternetDomainsDetails";

		public static const NOTE_REMOVE_INTERNET_HOSTS_DETAILS:String = NAME + SEPARATOR + "NoteRemoveInternetHostsDetails";
		
		public static const NOTE_OPEN_FORGOTPASSWORD:String = NAME + SEPARATOR + "NoteOpenForgotPassword";
		public static const NOTE_OPEN_NEWREGISTRATION:String = NAME + SEPARATOR + "NoteOpenNewRegistration";
	
		public static const NOTE_CLEAN_UI_SUPPORT_VIEW:String = NAME + SEPARATOR + "NoteCleanSupportView";
		public static const NOTE_CLEAN_UI_CREDIT_CARD_VIEW:String = NAME + SEPARATOR + "NoteCleanCreditCardView";
		
		public static const NOTE_REMOVE_VM_DETAILS:String = NAME + SEPARATOR + "NoteCleanVirtualPrivateServerDetails";
		public static const NOTE_CLEAN_PARTITION_REQUEST_FORM:String = NAME + SEPARATOR + "NoteCleanDominoPartitionRequestForm";

		public static const NOTE_CLEAN_JOIN_EXISTING_ACCOUNT:String = NAME + SEPARATOR + "NoteCleanJoinExistingAccountForm";

		public static const NOTE_DRAWER_CLOSE:String = NAME + SEPARATOR + "NoteDrawerClose";
		
		public static const NOTE_ROUTE_PARAMS_COMPONENT:String = NAME + SEPARATOR + "NoteRouteParamsComponent";
		
		public static const NOTE_SELECT_ACCOUNT_IN_SELECTOR:String = NAME + SEPARATOR + "NoteSelectAccountInSelector";
		
		public static const NOTE_SHOW_HTTP_LOG_LIST:String = NAME + SEPARATOR + "NoteShowHTTPLogList";
		public static const NOTE_SHOW_HTTP_LOG_QUERY_REPORT:String = NAME + SEPARATOR + "NoteShowHTTPLogQueryReport";
		
		public static const NOTE_PAYMENT_METHODS_REFRESH_VIEW:String = NAME + SEPARATOR + "NotePaymentMethodsRefreshView";
			
		public static const NOTE_REMOVE_INVOICE_DETAILS:String = NAME + SEPARATOR + "NoteRemoveInvoiceDetails";
		public static const NOTE_REMOVE_PAYMENT_DETAILS:String = NAME + SEPARATOR + "NoteRemovePaymentDetails";
		
		public static const NOTE_SET_INITIAL_TICKET_SUPPORT:String = NAME + SEPARATOR + "NoteSetInitialTicketSupport";
		
		public static const NOTE_OPEN_VIEW_HELLO:String = NAME + SEPARATOR + "NoteOpenViewHello";
		public static const NOTE_OPEN_GENESIS_APPLICATIONS:String = NAME + SEPARATOR + "NoteOpenGenesisApplications";
		//----------------------------------
		// Commands
		//----------------------------------
		public static const COMMAND_STARTUP:String = NAME + SEPARATOR + "CommandStartup";
		public static const COMMAND_POST_STARTUP:String = NAME + SEPARATOR + "CommandPostStartup";
		public static const COMMAND_START_POST_LOGIN:String = NAME + SEPARATOR + "CommandStartPostLogin";
		public static const COMMAND_LOGOUT_CLEANUP:String = NAME + SEPARATOR + "CommandLogoutCleanup";
		public static const COMMAND_REFRESH_NAV_ITEMS_ENABLED:String = NAME + SEPARATOR + "CommandRefreshNavItemsEnabled";
		public static const COMMAND_REFRESH_NAV_INSTALLED_APPS:String = NAME + SEPARATOR + "CommandRefreshNavInstalledApps";

		public static const COMMAND_REMOVE_REGISTER_MAIN_VIEW:String = NAME + SEPARATOR + "CommandRemoveRegisterMainView";

		public static const COMMAND_SHOW_POPUP:String = NAME + SEPARATOR + "CommandShowPopup";
		
		public static const COMMAND_DRAWER_CHANGED:String = NAME + SEPARATOR + "CommandDrawerChanged";
		public static const COMMAND_ADD_PROXY_FOR_DATA_DISPOSE:String = NAME + SEPARATOR + "CommandAddProxyForDataDispose";
		public static const COMMAND_REMOVE_PROXY_DATA:String = NAME + SEPARATOR + "CommandRemoveProxyData";
		public static const COMMAND_ADJUST_TAB_BAR_SIZE:String = NAME + SEPARATOR + "CommandAdjustTabBarSize";
		
		public static const COMMAND_APPLY_APP_TITLE:String = NAME + SEPARATOR + "CommandApplyAppTitle";
		
		public static const COMMAND_START_PASSWORD_RESET:String = NAME + SEPARATOR + "CommandStartPasswordReset";
		public static const COMMAND_START_NEW_REGISTRATION:String = NAME + SEPARATOR + "CommandStartNewRegistration";
		public static const COMMAND_CLEAN_URL_PARAMETERS:String = NAME + SEPARATOR + "CommandCleanUrlParameters";
		public static const COMMAND_AUTH_TEST:String = NAME + SEPARATOR + "CommandAuthTest";
		public static const COMMAND_GET_LTPA_TOKEN:String = NAME + SEPARATOR + "CommandGetLTPAToken";
	}
}