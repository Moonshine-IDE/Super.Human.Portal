package model
{
	import constants.ApplicationConstants;

	import mediator.MediatorViewHello;

	import org.apache.royale.collections.ArrayList;
										
	public class MainContentNavigationModel  
	{	
		private var _navigationLinks:ArrayList = new ArrayList([
			{ name: "Hello", notificationName: ApplicationConstants.NOTE_OPEN_VIEW_HELLO, icon: "mdi mdi-clipboard-account mdi-24px", idSelectedItem: MediatorViewHello.NAME}
		]);
		
		public function get navigationLinks():ArrayList
		{              
            return _navigationLinks;
		}
		
		public function set navigationLinks(value:ArrayList):void
		{
			_navigationLinks = value;
		}
	}
}