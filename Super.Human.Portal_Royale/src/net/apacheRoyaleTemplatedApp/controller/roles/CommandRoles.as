package controller.roles
{
    import controller.roles.executeRoles.CommandExecuteRolesBookmarksView;
    import controller.roles.executeRoles.CommandExecuteRolesBrowseMyServerView;

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