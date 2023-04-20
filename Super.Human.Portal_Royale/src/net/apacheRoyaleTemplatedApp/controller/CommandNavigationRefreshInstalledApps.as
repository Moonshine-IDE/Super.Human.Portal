package controller
{
	import mediator.MediatorMainContentView;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import model.InstalledAppNavigationModel;
	import model.proxy.applicationsCatalog.ProxyGenesisApps;
	import model.vo.ApplicationVO;
	import org.apache.royale.collections.ArrayList;
	import mediator.applications.MediatorInstalledApps;
	import org.apache.royale.events.Event;
	import model.vo.NavigationLinkVO;

	public class CommandNavigationRefreshInstalledApps extends SimpleCommand
	{
		override public function execute(note:INotification):void 
		{	
			var apps:Array = note.getBody() as Array;
			var mainMediator:MediatorMainContentView = facade.retrieveMediator(MediatorMainContentView.NAME) as MediatorMainContentView;
			var genesisAppsProxy:ProxyGenesisApps = facade.retrieveProxy(ProxyGenesisApps.NAME) as ProxyGenesisApps;
			
			var installedAppNavModel:InstalledAppNavigationModel = mainMediator.view["model"] as InstalledAppNavigationModel;

			var installedApps:ArrayList = new ArrayList();
			var appWhiteSpaceRegExp:RegExp = new RegExp(/\s+/gi);
			for each (var app:ApplicationVO in apps)
			{
				var menuItem:NavigationLinkVO = new NavigationLinkVO(app.label, "", "mdi mdi-apps mdi-24px", 
																	MediatorInstalledApps.NAME + app.label.replace(appWhiteSpaceRegExp, ""), app);
				installedApps.addItem(menuItem);
			}
			var installedAppsItem:NavigationLinkVO = installedAppNavModel.navigationLinks.getItemAt(0) as NavigationLinkVO;
				installedAppsItem.enabled = true;
			installedAppNavModel.installedAppsNavLinks = installedApps;
				
			var installedAppsNav:Object = mainMediator.view.viewInstalledAppsNavigation;
				installedAppsNav.dataProvider = null;
				installedAppsNav.dataProvider = installedAppNavModel.navigationLinks;
		}
	}
}