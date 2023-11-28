package controller.roles.executeRoles
{
    import constants.Roles;

    import mediator.bookmarks.MediatorBrowseMyServer;

    import model.proxy.login.ProxyLogin;

    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class CommandExecuteRolesBrowseMyServerView extends SimpleCommand 
	{
		override public function execute(note:INotification):void
		{
			if (facade.hasMediator(MediatorBrowseMyServer.NAME))
			{
				var loginProxy:ProxyLogin = facade.retrieveProxy(ProxyLogin.NAME) as ProxyLogin;

				var browseMyServerMediator:MediatorBrowseMyServer = facade.retrieveMediator(MediatorBrowseMyServer.NAME) as MediatorBrowseMyServer;
					browseMyServerMediator.view.editable = loginProxy.user && loginProxy.user.hasRole(Roles.ADMINISTRATOR);
			}
		}
	}
}