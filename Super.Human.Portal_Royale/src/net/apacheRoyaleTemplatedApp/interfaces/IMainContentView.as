package interfaces
{
	import interfaces.busy.ILoadBusyOperator;

	import org.apache.royale.events.IEventDispatcher;
								
	public interface IMainContentView extends ILoadBusyOperator
	{
		function set selectedNavigation(value:Object):void;
		function get selectedNavigation():Object;
		function get selectedContent():String;
		function set selectedContent(value:String):void;

		function get login():ILoginView;
		function get newRegistration():INewRegistration;
		function get viewPasswordReset():IPasswordReset;

		function set logoutVisible(value:Boolean):void;
		function get logout():IEventDispatcher;
		function set loggedUsername(value:String):void;
		function set authenticationId(value:String):void;
		function get versionText():String;
		function set versionText(value:String):void;
		function set footerText(value:String):void;
		function get isDrawerOpen():Boolean;
		function get viewDrawerNavigation():IEventDispatcher;
		function get viewDrawerContentNavigation():IEventDispatcher;
		function get viewButtonDrawer():IEventDispatcher;
		function get viewDrawer():Object;
		function get viewBookmarksNavigation():IEventDispatcher;
		function get viewInstalledAppsNavigation():IEventDispatcher;
		function get footer():Object;
		function set autoSizeDrawer(value:Boolean):void;

		function toggleDrawerOpen(value:Boolean):void;
		function notifyObsoleteCurrentVersion():void;
		
		function get viewGenesisApps():IGenesisAppsView;
		function get viewDocumentationForm():Object;
		
		function get installedAppsView():IInstalledAppView;
		function get installedAppsSection():Object;
			
		function get bookmarksView():IBookmarksView;
		function get bookmarksViewSection():Object;
		function get viewEditBookmark():IEditBookmarkView;
		
		function set title(value:String):void;
		
		/*
		Temporary hide Hello
		function get viewHello():IViewHello;
		*/
	}
}