package controller.startup.pepareController
{
	import constants.ApplicationConstants;

	import controller.CommandAdjustTabBarSize;
	import controller.CommandAppTitle;
	import controller.CommandAuthenticationTest;
	import controller.CommandCleanUrlParameters;
	import controller.CommandGetLTPAToken;
	import controller.CommandLaunchNomadLink;
	import controller.CommandLogoutCleanUp;
	import controller.CommandNavigationItemsEnabled;
	import controller.CommandNavigationRefreshInstalledApps;
	import controller.CommandProxyManager;
	import controller.CommandRefreshNavigationBookmarks;
	import controller.CommandRemoveRegisterMainContentView;
	import controller.CommandShowBrowserWarning;
	import controller.CommandShowPopup;
	import controller.startup.prepareView.CommandSwitchTheme;
	import controller.startup.start.CommandPostLogin;
	import controller.startup.start.CommandStartNewRegistration;
	import controller.startup.start.CommandStartPasswordReset;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
									
	public class CommandPrepareController extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			facade.registerCommand(ApplicationConstants.COMMAND_SWITCH_THEME, CommandSwitchTheme);
			facade.registerCommand(ApplicationConstants.COMMAND_START_PASSWORD_RESET, CommandStartPasswordReset);
			facade.registerCommand(ApplicationConstants.COMMAND_START_NEW_REGISTRATION, CommandStartNewRegistration);
			facade.registerCommand(ApplicationConstants.COMMAND_CLEAN_URL_PARAMETERS, CommandCleanUrlParameters);
			
			facade.registerCommand(ApplicationConstants.COMMAND_REMOVE_REGISTER_MAIN_VIEW, CommandRemoveRegisterMainContentView);
			facade.registerCommand(ApplicationConstants.COMMAND_LOGOUT_CLEANUP, CommandLogoutCleanUp);
			facade.registerCommand(ApplicationConstants.COMMAND_REFRESH_NAV_ITEMS_ENABLED, CommandNavigationItemsEnabled);
			facade.registerCommand(ApplicationConstants.COMMAND_REFRESH_NAV_INSTALLED_APPS, CommandNavigationRefreshInstalledApps);
			facade.registerCommand(ApplicationConstants.COMMAND_REFRESH_NAV_BOOKMARKS, CommandRefreshNavigationBookmarks);
			facade.registerCommand(ApplicationConstants.COMMAND_SHOW_POPUP, CommandShowPopup);
			facade.registerCommand(ApplicationConstants.COMMAND_APPLY_APP_TITLE, CommandAppTitle);
			
			facade.registerCommand(ApplicationConstants.COMMAND_DRAWER_CHANGED, CommandProxyManager);
			facade.registerCommand(ApplicationConstants.COMMAND_ADD_PROXY_FOR_DATA_DISPOSE, CommandProxyManager);
			facade.registerCommand(ApplicationConstants.COMMAND_REMOVE_PROXY_DATA, CommandProxyManager);
			facade.registerCommand(ApplicationConstants.COMMAND_ADJUST_TAB_BAR_SIZE, CommandAdjustTabBarSize);
			facade.registerCommand(ApplicationConstants.COMMAND_START_POST_LOGIN, CommandPostLogin);
			facade.registerCommand(ApplicationConstants.COMMAND_AUTH_TEST, CommandAuthenticationTest);
			facade.registerCommand(ApplicationConstants.COMMAND_GET_LTPA_TOKEN, CommandGetLTPAToken);
			facade.registerCommand(ApplicationConstants.COMMAND_LAUNCH_NOMAD_LINK, CommandLaunchNomadLink);
			facade.registerCommand(ApplicationConstants.COMMAND_SHOW_BROWSER_WARNING, CommandShowBrowserWarning);
		}
	}
}