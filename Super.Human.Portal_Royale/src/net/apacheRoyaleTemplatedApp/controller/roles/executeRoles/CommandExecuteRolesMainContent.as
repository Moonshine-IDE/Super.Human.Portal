package controller.roles.executeRoles
{
    import constants.Roles;

    import mediator.MediatorMainContentView;
    import mediator.applications.MediatorGenesisApps;

    import model.LeftMenuNavigationModel;
    import model.proxy.login.ProxyLogin;
    import model.vo.NavigationLinkVO;

    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    import model.proxy.customBookmarks.ProxyBookmarks;
    import model.proxy.applicationsCatalog.ProxyGenesisApps;
    import mediator.applications.MediatorGenesisDirs;

	public class CommandExecuteRolesMainContent extends SimpleCommand 
	{
		override public function execute(note:INotification):void
		{
			if (facade.hasMediator(MediatorMainContentView.NAME))
			{
				var loginProxy:ProxyLogin = facade.retrieveProxy(ProxyLogin.NAME) as ProxyLogin;
				
				var mainContentMediator:MediatorMainContentView = facade.retrieveMediator(MediatorMainContentView.NAME) as MediatorMainContentView;
				var mainContentModel:LeftMenuNavigationModel = mainContentMediator.view["model"];
				var navItem:NavigationLinkVO = null;
				
				//Remove "Additional directories" - avialable as admin
				//&& !loginProxy.user.hasRole(Roles.ADMINISTRATOR)
				if (loginProxy.user && !loginProxy.user.display.additionalGenesis)
				{
					for (var i:int = mainContentModel.mainNavigation.length - 1; i >= 0; i--)
					{
						navItem = mainContentModel.mainNavigation.getItemAt(i) as NavigationLinkVO;
						if (navItem.idSelectedItem == MediatorGenesisApps.NAME)
						{
							if (navItem.subMenu)
							{
								for (var j:int = navItem.subMenu.length - 1; j >= 0; j--)
								{
									var subItem:NavigationLinkVO = navItem.subMenu.getItemAt(j) as NavigationLinkVO;
									if (subItem.idSelectedItem == MediatorGenesisDirs.NAME)
									{
										navItem.subMenu.removeItemAt(j);
									}
								}
							}
						}
					}
				}
				
				if (loginProxy.user && loginProxy.user.display)
				{
					var k:int = -1;

					for (k = mainContentModel.navigationLinks.length - 1; k >= 0; k--)
					{
						navItem = mainContentModel.navigationLinks.getItemAt(k) as NavigationLinkVO;
						if (!loginProxy.user.display.viewInstalledApps)
						{
							if (navItem.idSelectedItem == "installedApps") {
								mainContentModel.navigationLinks.removeItemAt(k);
							}
						}
					}
					
					for (k = mainContentModel.mainNavigation.length - 1; k >= 0; k--)
					{
						navItem = mainContentModel.mainNavigation.getItemAt(k) as NavigationLinkVO;
						
						if (!loginProxy.user.display.viewInstalledApps)
						{
							if (navItem.idSelectedItem == MediatorGenesisApps.NAME) 
							{
								mainContentModel.mainNavigation.removeItemAt(k);
							}
						}
						
						if (!loginProxy.user.display.viewDocumentation)
						{
							if (navItem.idSelectedItem == "GettingStartedDoc") 
							{
								mainContentModel.mainNavigation.removeItemAt(k);
							}
						}
					}
				}
			}
		}
	}
}