package 
{	
	import constants.ApplicationConstants;

	import controller.startup.CommandPostStartup;
	import controller.startup.CommandStartup;

	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class ApplicationFacade extends Facade
	{		
		public function ApplicationFacade(key:String) {
			super(key);
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
			
			this.sendNotification(ApplicationConstants.COMMAND_STARTUP, app);
			this.sendNotification(ApplicationConstants.COMMAND_POST_STARTUP);
		}
	}
}