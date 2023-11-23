package controller.startup
{
	import controller.startup.pepareController.CommandPrepareController;
	import controller.startup.prepareModel.CommandPrepareModel;
	import controller.startup.prepareView.CommandPrepareView;

	import org.puremvc.as3.multicore.patterns.command.MacroCommand;
	
	public class CommandStartup extends MacroCommand
	{		
		/**
		 * 
		 */
		override protected function initializeMacroCommand():void
		{
			addSubCommand(CommandPrepareController);
			addSubCommand(CommandPrepareModel);
			addSubCommand(CommandPrepareView);
		}
	}
}
