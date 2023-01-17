package controller
{
	import classes.locator.NativeModelLocator;

	import constants.ApplicationConstants;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class CommandLogoutCleanUp extends SimpleCommand
	{
		override public function execute(note:INotification):void 
		{	
			var modelLocator:NativeModelLocator = NativeModelLocator.getInstance();
			
			// reset all fields
			modelLocator.countriesAC = null;
			modelLocator.timezoneAC = null;
			modelLocator.addressBillingAC = null;
			modelLocator.accountsAC = null;
			
			sendNotification(ApplicationConstants.COMMAND_DRAWER_CHANGED, true);
		}
	}
}