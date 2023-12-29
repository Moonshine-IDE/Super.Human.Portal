package 
{	
	import constants.ApplicationConstants;

	import controller.roles.CommandRoles;
	import controller.roles.executeRoles.CommandExecuteRolesMainContent;
	import controller.startup.CommandPostStartup;
	import controller.startup.CommandStartup;

	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import controller.roles.executeRoles.CommandExecuteRolesBookmarksView;
	import controller.roles.executeRoles.CommandExecuteRolesBrowseMyServerView;
	import constants.Theme;

	public class ApplicationFacade extends Facade
	{		
		public function ApplicationFacade(key:String) {
			super(key);
		}	

		private var _theme:String;
		
		public function setTheme(theme:String):void
		{
			if (_theme != theme)
			{
				_theme = theme;
			}
		}
		
		public function getTheme():String
		{
			return _theme;
		}
		
		/**
		 * ApplicationFacade Factory Method
		*/
		public static function getInstance(key:String):ApplicationFacade
		{
			if ( instanceMap[key] == null ) instanceMap[key] = new ApplicationFacade(key);
			return instanceMap[key] as ApplicationFacade;
		}	
		
		public function startup(app:Object):void 
		{
			registerCommand(ApplicationConstants.COMMAND_STARTUP, CommandStartup);
			registerCommand(ApplicationConstants.COMMAND_POST_STARTUP, CommandPostStartup);
			registerCommand(ApplicationConstants.COMMAND_EXECUTE_ROLES, CommandRoles);
			registerCommand(ApplicationConstants.COMMAND_EXECUTE_MAIN_CONTENT_ROLES, CommandExecuteRolesMainContent);
			registerCommand(ApplicationConstants.COMMAND_EXECUTE_BOOKMARKS_ROLES, CommandExecuteRolesBookmarksView);
			registerCommand(ApplicationConstants.COMMAND_EXECUTE_BROWSE_MY_SERVER_ROLES, CommandExecuteRolesBrowseMyServerView);
			
			this.sendNotification(ApplicationConstants.COMMAND_STARTUP, app);
			this.sendNotification(ApplicationConstants.COMMAND_POST_STARTUP);
		}
	}
}