package controller.roles.executeRoles
{
    import constants.Roles;

    import mediator.bookmarks.MediatorBookmarks;

    import model.proxy.login.ProxyLogin;

    import org.apache.royale.jewel.beads.controls.Disabled;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

    import view.bookmarks.Bookmark;
    import model.proxy.customBookmarks.ProxyBookmarks;

	public class CommandExecuteRolesBookmarksView extends SimpleCommand 
	{
		override public function execute(note:INotification):void
		{
			var bookmarksProxy:ProxyBookmarks = facade.retrieveProxy(ProxyBookmarks.NAME) as ProxyBookmarks;
			
			var bookmarksMediatorName:String = MediatorBookmarks.NAME + bookmarksProxy.selectedGroup;
			if (facade.hasMediator(bookmarksMediatorName))
			{
				var bookmarksMediator:MediatorBookmarks = facade.retrieveMediator(bookmarksMediatorName) as MediatorBookmarks;
				if (bookmarksMediator.view.currentState == MediatorBookmarks.BOOKMARKS_VIEW_STATE)
				{
					var loginProxy:ProxyLogin = facade.retrieveProxy(ProxyLogin.NAME) as ProxyLogin;
					
					var addBookmarkDisabled:Disabled = bookmarksMediator.view.addBookmark["getBeadByType"](Disabled);
						addBookmarkDisabled.disabled = !(loginProxy.user && loginProxy.user.hasRole(Roles.ADMINISTRATOR));
						
					var bookmarkCount:int = bookmarksMediator.view.bookmarksList.numElements;
					for (var i:int = 0; i < bookmarkCount; i++)
					{
						var bookmark:Bookmark = bookmarksMediator.view.bookmarksList.getElementAt(i) as Bookmark;
						if (bookmark)
						{
							bookmark.editable = loginProxy.user && loginProxy.user.hasRole(Roles.ADMINISTRATOR);
						}
					}
				}
			}
		}
	}
}