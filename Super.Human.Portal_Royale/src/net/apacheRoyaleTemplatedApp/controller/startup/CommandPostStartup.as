package controller.startup
{
	import controller.CommandVersionCheck;

	import org.puremvc.as3.multicore.patterns.command.MacroCommand;
	
	public class CommandPostStartup extends MacroCommand
	{		
		/**
		 * 
		 */
		override protected function initializeMacroCommand() :void
		{
			addSubCommand(CommandVersionCheck);
		}
	}
}
