package model
{
	import constants.ApplicationConstants;

	import mediator.applications.MediatorGenesisApps;
	import mediator.applications.MediatorGenesisDirs;

	import model.vo.NavigationLinkVO;

	import org.apache.royale.collections.ArrayList;
										
	public class LeftMenuNavigationModel  
	{	
		private var genesisDirectories:ArrayList = new ArrayList([
			new NavigationLinkVO("Additional directories", ApplicationConstants.NOTE_OPEN_GENESIS_DIRS_VIEW, "mdi mdi-apps mdi-24px", MediatorGenesisDirs.NAME, null, MediatorGenesisDirs.NAME)
		]);
		
		private var genesisApps:NavigationLinkVO = new NavigationLinkVO("Genesis App", ApplicationConstants.NOTE_OPEN_GENESIS_APPLICATIONS, "mdi mdi-apps mdi-24px", MediatorGenesisApps.NAME, null, MediatorGenesisApps.NAME);
		
		private var _mainNavigation:ArrayList = new ArrayList([
			new NavigationLinkVO("Getting Started", ApplicationConstants.NOTE_OPEN_VIEW_HELLO, "mdi mdi-apps mdi-24px", "", null, "DocumentationForm"),
			genesisApps
		]);

		public function get mainNavigation():ArrayList
		{
			if (!genesisApps.subMenu)
			{
				this.genesisApps.subMenu = genesisDirectories;
			}
			
			return _mainNavigation;
		}

		public function set mainNavigation(value:ArrayList):void
		{
			_mainNavigation = value;
		}
		
		private var installedApp:NavigationLinkVO = new NavigationLinkVO("Installed Apps", "$collapsible", "mdi mdi-folder mdi-24px", "");
		
		private var _navigationLinks:ArrayList = new ArrayList([
			installedApp
		]);
		
		public function get navigationLinks():ArrayList
		{              
			installedApp.subMenu = _installedAppsNavLinks;
            return _navigationLinks;
		}
		
		public function set navigationLinks(value:ArrayList):void
		{
			_navigationLinks = value;
		}
		
		private var _installedAppsNavLinks:ArrayList = new ArrayList();

		public function set installedAppsNavLinks(value:ArrayList):void
		{
			_installedAppsNavLinks = value;
		}
		
		private var customBookmarksList:NavigationLinkVO = new NavigationLinkVO("Bookmarks", "$collapsible", "mdi mdi-folder mdi-24px", "");
		
		private var _customBookmarks:ArrayList = new ArrayList([
			customBookmarksList
		]);

		public function get customBookmarks():ArrayList
		{
			customBookmarksList.subMenu = _customBookmarksGroups;
			return _customBookmarks;	
		}
		
		public function set customBookmarks(value:ArrayList):void
		{
			_customBookmarks = value;
		}
		
		private var _customBookmarksGroups:ArrayList = new ArrayList();

		public function set customBookmarksGroups(value:ArrayList):void
		{
			_customBookmarksGroups = value;
		}
	}
}