package controller
{
	import mediator.MediatorMainContentView;
	import mediator.bookmarks.MediatorBookmarks;

	import model.LeftMenuNavigationModel;
	import model.proxy.customBookmarks.ProxyBookmarks;
	import model.vo.BookmarkVO;
	import model.vo.NavigationLinkVO;

	import org.apache.royale.collections.ArrayList;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import model.proxy.login.ProxyLogin;

	public class CommandRefreshNavigationBookmarks extends SimpleCommand
	{
		override public function execute(note:INotification):void 
		{	
			var bookmarks:Array = note.getBody() as Array;
								
			var loginProxy:ProxyLogin = facade.retrieveProxy(ProxyLogin.NAME) as ProxyLogin;
			
			var mainMediator:MediatorMainContentView = facade.retrieveMediator(MediatorMainContentView.NAME) as MediatorMainContentView;
			var bookmarksProxy:ProxyBookmarks = facade.retrieveProxy(ProxyBookmarks.NAME) as ProxyBookmarks;
			
			var leftMenuNavModel:LeftMenuNavigationModel = mainMediator.view["model"] as LeftMenuNavigationModel;
			var bookmarksNav:Object = mainMediator.view.viewBookmarksNavigation;
			var bookmarksList:ArrayList = new ArrayList();

			var groups:Array = [];
			for each (var bookmark:BookmarkVO in bookmarks)
			{
				var hasGroup:Boolean = groups.some(function(item:BookmarkVO, index:int, arr:Array):Boolean {
					return item.name == bookmark.group;
				});
				if (!hasGroup)
				{
					groups.push({name: bookmark.group});	
				}
			}
			
			var defaultItem:Array = [];
			if (groups.length == 0)
			{
				defaultItem.push({name: "Default"});	
			}
			else
			{
				var defaultIndex:int = groups.findIndex(function(group:Object, index:int, arr:Array):Boolean{
					return group.name == "Default";
				});
				if (defaultIndex >= 0)
				{
					defaultItem = groups.splice(defaultIndex, 1);
				}
			}
			
			var initialGroupIndexItem:int = 0;
			if (loginProxy.user.display.browseMyServer)
			{
				groups.insertAt(initialGroupIndexItem, {name: "Browse My Server"});
				initialGroupIndexItem = 1;
			}
			
			if (defaultItem.length > 0)
			{
				groups.insertAt(initialGroupIndexItem, defaultItem[0]);
			}
			
			groups.forEach(function(group:Object, index:int, arr:Array):void{
								
				var menuItem:NavigationLinkVO = new NavigationLinkVO(group.name, "", "mdi mdi-apps mdi-24px", 
																	MediatorBookmarks.getMediatorName(group.name), group);
				bookmarksList.addItem(menuItem);
			});
			
			bookmarksProxy.groups = groups;
			var bookmarksItem:NavigationLinkVO = leftMenuNavModel.customBookmarks.getItemAt(0) as NavigationLinkVO;
				bookmarksItem.enabled = true;
			leftMenuNavModel.customBookmarksGroups = bookmarksList;

			bookmarksNav.dataProvider = null;
			bookmarksNav.dataProvider = leftMenuNavModel.customBookmarks;
		}
	}
}