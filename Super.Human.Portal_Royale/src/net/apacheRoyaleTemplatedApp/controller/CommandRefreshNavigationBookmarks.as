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

	public class CommandRefreshNavigationBookmarks extends SimpleCommand
	{
		override public function execute(note:INotification):void 
		{	
			var bookmarks:Array = note.getBody() as Array;

			var mainMediator:MediatorMainContentView = facade.retrieveMediator(MediatorMainContentView.NAME) as MediatorMainContentView;
			var bookmarksProxy:ProxyBookmarks = facade.retrieveProxy(ProxyBookmarks.NAME) as ProxyBookmarks;
			
			var leftMenuNavModel:LeftMenuNavigationModel = mainMediator.view["model"] as LeftMenuNavigationModel;
			var bookmarksNav:Object = mainMediator.view.viewBookmarksNavigation;
			var bookmarksList:ArrayList = new ArrayList();
			var appWhiteSpaceRegExp:RegExp = new RegExp(/\s+/gi);

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
			
			if (groups.length == 0)
			{
				groups.push({name: "Default"});	
			}
								
			groups.sortOn("name");
			groups.insertAt(0, {name: "Browse My Server"});

			groups.forEach(function(group:Object, index:int, arr:Array):void{
								
				var menuItem:NavigationLinkVO = new NavigationLinkVO(group.name, "", "mdi mdi-apps mdi-24px", 
																	MediatorBookmarks.NAME + group.name.replace(appWhiteSpaceRegExp, ""), group);
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