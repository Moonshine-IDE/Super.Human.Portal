package controller.roles
{
    import org.puremvc.as3.multicore.patterns.command.MacroCommand;

	public class CommandRoles extends MacroCommand 
	{
		override protected function initializeMacroCommand():void
		{
			addSubCommand(CommandExecuteRolesBrowseMyServerView);
			addSubCommand(CommandExecuteRolesBookmarksView);
		}
	}
}