package model
{
	import constants.ApplicationConstants;

	import mediator.MediatorViewHello;

	import org.apache.royale.collections.ArrayList;
	import model.vo.NavigationLinkVO;
										
	public class InstalledAppNavigationModel  
	{	
		private var installedApp:NavigationLinkVO = new NavigationLinkVO("Installed Apps", "$collapsible", "mdi mdi-folder mdi-24px", "");
		
		private var _navigationLinks:ArrayList = new ArrayList([
			installedApp
		]);
		
		public function get navigationLinks():ArrayList
		{              
			installedApp.subMenu = installedAppsNavLinks;
            return _navigationLinks;
		}
		
		public function set navigationLinks(value:ArrayList):void
		{
			_navigationLinks = value;
		}
		
		private var _installedAppsNavLinks:ArrayList = new ArrayList();

		public function get installedAppsNavLinks():ArrayList
		{
			return _installedAppsNavLinks;
		}

		public function set installedAppsNavLinks(value:ArrayList):void
		{
			_installedAppsNavLinks = value;
		}
		
	}
}