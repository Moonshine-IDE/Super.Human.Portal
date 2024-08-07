package mediator
{
    import constants.ApplicationConstants;
    import constants.Theme;

    import interfaces.IMainContentView;

    import mediator.applications.MediatorGenesisApps;
    import mediator.applications.MediatorGenesisDirs;
    import mediator.applications.MediatorGenesisEditDir;
    import mediator.bookmarks.MediatorEditBookmark;

    import model.proxy.ProxyTheme;
    import model.proxy.ProxyVersion;
    import model.proxy.applicationsCatalog.ProxyGenesisApps;
    import model.proxy.busy.ProxyBusyManager;
    import model.proxy.customBookmarks.ProxyBookmarks;
    import model.proxy.login.ProxyLogin;
    import model.proxy.login.ProxyPasswordReset;
    import model.proxy.urlParams.ProxyUrlParameters;
    import model.vo.ApplicationVO;
    import model.vo.NavigationLinkVO;
    import model.vo.UserVO;

    import org.apache.royale.collections.ArrayList;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.events.MouseEvent;
    import org.apache.royale.events.ValueEvent;
    import org.apache.royale.reflection.getQualifiedClassName;
    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
                                                                                
    public class MediatorMainContentView extends Mediator implements IMediator
    {
			public static const NAME:String = 'MediatorMainContentView';

			private var loginProxy:ProxyLogin;
			private var busyManagerProxy:ProxyBusyManager;
			
			public function MediatorMainContentView(component:IMainContentView) 
			{
				super(NAME, component);
			}
			
			override public function onRegister():void 
			{			
				super.onRegister();
				
				busyManagerProxy = facade.retrieveProxy(ProxyBusyManager.NAME) as ProxyBusyManager;
				busyManagerProxy.setData(view);
				loginProxy = facade.retrieveProxy(ProxyLogin.NAME) as ProxyLogin;
				
				view.viewDrawer.addEventListener("openDrawer", onOpenCloseDrawer);
				view.viewDrawer.addEventListener("closeDrawer", onOpenCloseDrawer);
				view.logout.addEventListener(MouseEvent.CLICK, onLogoutClick);
				view.switchTheme.addEventListener(MouseEvent.CLICK, onSwitchTheme);
				view.viewButtonDrawer.addEventListener(MouseEvent.CLICK, onDrawerButtonShowHide);
				view.viewDrawerNavigation.addEventListener(Event.CHANGE, onNavigationSectionChange);
				view.viewDrawerNavigation.addEventListener("sectionChange", onNavigationSectionChange);
				view.viewBookmarksNavigation.addEventListener(Event.CHANGE, onNavigationBookmarksSelectionChange);
				view.viewInstalledAppsNavigation.addEventListener(Event.CHANGE, onNavigationInstalledAppSectionChange);
				
				view.loggedUsername = "Prominic User";
				
				var currentDate:Date = new Date();
				view.footerText = "Built with <a href='http://dominohelp.com/' target='_blank'>Domino</a> and <a href='https://royale.apache.org/' target='_blank'>Apache Royale</a> using <a href='https://moonshine-ide.com/' target='_blank'>Moonshine IDE</a>. &nbsp;&nbsp;Copyright (c) <a href='https://prominic.net/' target='_blank'>Prominic.NET, Inc.</a> 2007-" + currentDate.fullYear + ". All rights reserved.";
	
				view.viewDrawerContentNavigation["element"]["style"]["paddingBottom"] = String(view.footer.element.clientHeight) + "px";
			}

			override public function onRemove():void 
			{			
				super.onRemove();
			}	

			override public function listNotificationInterests():Array 
			{
				var interests:Array = super.listNotificationInterests();
					interests.push(ProxyLogin.NOTE_LOGIN_SUCCESS);
					interests.push(ProxyLogin.NOTE_LOGOUT_SUCCESS);		
					interests.push(ProxyLogin.NOTE_ANONYMOUS_USER);
					interests.push(ApplicationConstants.NOTE_OPEN_FORGOTPASSWORD);
					interests.push(ApplicationConstants.NOTE_OPEN_NEWREGISTRATION);
			
					interests.push(ProxyVersion.NOTE_OBSOLETE_CURRENT_VERSION);
	
					interests.push(ApplicationConstants.NOTE_DRAWER_CLOSE);
					interests.push(ApplicationConstants.NOTE_OPEN_NEW_ACCOUNT_REQUEST);
					interests.push(ApplicationConstants.NOTE_OPEN_NEW_ADDRESS_REQUEST);
					interests.push(ProxyVersion.NOTE_VERSION_INFORMATION_LOADED);

					interests.push(ApplicationConstants.NOTE_ROUTE_PARAMS_COMPONENT);
					
					interests.push(ApplicationConstants.NOTE_OPEN_VIEW_HELLO);
					interests.push(ApplicationConstants.NOTE_OPEN_GENESIS_APPLICATIONS);
					interests.push(ApplicationConstants.NOTE_OPEN_GENESIS_DIRS_VIEW);
					interests.push(ApplicationConstants.NOTE_OPEN_ADD_EDIT_GENESIS_DIR);
					interests.push(ApplicationConstants.NOTE_OPEN_ADD_EDIT_BOOKMARK);
					interests.push(ApplicationConstants.NOTE_OPEN_SELECTED_BOOKMARK_GROUP);
					
				return interests;
			}

			override public function handleNotification(note:INotification):void 
			{
				switch (note.getName()) 
				{
					case ProxyVersion.NOTE_VERSION_INFORMATION_LOADED:
						var versionProxy:ProxyVersion = facade.retrieveProxy(ProxyVersion.NAME) as ProxyVersion;
						view.versionText = "Version: "+ versionProxy.version.appVersion + (versionProxy.version.isDevelopment ? " (dev)" : "");
						break;
					case ProxyVersion.NOTE_OBSOLETE_CURRENT_VERSION:
						view.notifyObsoleteCurrentVersion();
						break;
					case ProxyLogin.NOTE_ANONYMOUS_USER:
					case ProxyLogin.NOTE_LOGOUT_SUCCESS:
						initializeLoginView(note.getBody());
						break;
					case ApplicationConstants.NOTE_OPEN_FORGOTPASSWORD:
						initializeResetPassword(note.getBody());
						break;
					case ApplicationConstants.NOTE_OPEN_NEWREGISTRATION:
						initializeNewRegistration();
						break;					
					case ProxyLogin.NOTE_LOGIN_SUCCESS:
						sendNotification(ApplicationConstants.COMMAND_APPLY_APP_TITLE);
						var user:UserVO = loginProxy.getData() as UserVO;
						view.authenticationId = user.commonName;
						view.logout["visible"] = user.username != "Anonymous";
						
						sendNotification(ApplicationConstants.COMMAND_START_POST_LOGIN);
						initializeLoggedUserInformation();
						break;							
					case ApplicationConstants.NOTE_DRAWER_CLOSE:
						view.toggleDrawerOpen(false);
						break;
					case ApplicationConstants.NOTE_ROUTE_PARAMS_COMPONENT:
						routeParamsToComponent(note.getBody() as ValueEvent);
						break;
					case ApplicationConstants.NOTE_OPEN_VIEW_HELLO:
						//initializeViewHello();
						initializeViewGettingStarted();
						initializeListOfBookmarks();
										
						sendNotification(ApplicationConstants.COMMAND_EXECUTE_MAIN_CONTENT_ROLES);
						break;
					case ApplicationConstants.NOTE_OPEN_GENESIS_APPLICATIONS:
						initializeGenesisApplicationsList();
						break;
					case ApplicationConstants.NOTE_OPEN_GENESIS_DIRS_VIEW:
						initializeGenesisDirs();
						break;
					case ApplicationConstants.NOTE_OPEN_ADD_EDIT_GENESIS_DIR:
						initializeGenesisEditDir();
						break;
					case ApplicationConstants.NOTE_OPEN_ADD_EDIT_BOOKMARK:
						initializeAddEditBookmark();
						break;
					case ApplicationConstants.NOTE_OPEN_SELECTED_BOOKMARK_GROUP:
						selectBookmarkGroup(String(note.getBody()));
						break;
				}
			}		
			
			public function get view():IMainContentView
			{
				return viewComponent as IMainContentView;
			}
						
			private function initializeLoginView(initData:Object):void
			{				
				var urlParamsProxy:ProxyUrlParameters = facade.retrieveProxy(ProxyUrlParameters.NAME) as ProxyUrlParameters;
		
				if (view.selectedContent != MediatorLoginPopup.NAME && 
					urlParamsProxy.isPasswordReset == false && 
					urlParamsProxy.isForgotPassword == false &&
					urlParamsProxy.isRegister == false)
				{
					facade.removeMediator(view.selectedContent);
				}				
				
				if (!facade.hasMediator(MediatorLoginPopup.NAME))
				{
					facade.registerMediator(new MediatorLoginPopup(view.login, initData.forceShow));
				}							
					
				view.logoutVisible = false;
				view.authenticationId = null;
				view.autoSizeDrawer = false;
				view.toggleDrawerOpen(false);
				
				if (urlParamsProxy.isPasswordReset == false && 
					urlParamsProxy.isForgotPassword == false &&
					urlParamsProxy.isRegister == false)
				{
					//Fix issue where MediatorLoginPopup is already reagistered and command won't select any content
					view.selectedContent = MediatorLoginPopup.NAME;	
				}
			}
			
			private function initializeResetPassword(resetPasswordData:Object):void
			{
				var passwordResetProxy:ProxyPasswordReset = facade.retrieveProxy(ProxyPasswordReset.NAME) as ProxyPasswordReset;
				passwordResetProxy.setData(resetPasswordData);
				
				if (!facade.hasMediator(MediatorPasswordReset.NAME))
				{
					facade.registerMediator(new MediatorPasswordReset(view.viewPasswordReset));
				}				
				
				view.selectedContent = MediatorPasswordReset.NAME;
			}
			
			private function initializeNewRegistration():void
			{
				if (!facade.hasMediator(MediatorNewRegistration.NAME))
				{
					facade.registerMediator(new MediatorNewRegistration(view.newRegistration));	
				}			
				
				view.selectedContent = MediatorNewRegistration.NAME;
			}
			
			/*
			Temporary hide Hello
			private function initializeViewHello():void
			{
				sendNotification(ApplicationConstants.COMMAND_REMOVE_REGISTER_MAIN_VIEW, {
					view: view,
					currentView: view.viewHello,
					currentSelection: MediatorViewHello.NAME
				}, "mediator.MediatorViewHello");
			}*/
			
			private function initializeViewGettingStarted():void
			{
				//Make sure getting started from previous session is not present
				facade.removeMediator(MediatorViewGettingStarted.NAME);
				
				this.removeMediatorFromAdditionalNavigation(view.viewInstalledAppsNavigation);
				this.removeMediatorFromAdditionalNavigation(view.viewBookmarksNavigation);
				
				sendNotification(ApplicationConstants.COMMAND_REMOVE_REGISTER_MAIN_VIEW, {
					view: view,
					currentView: view.viewDocumentationForm,
					currentSelection: "DocumentationForm"
				}, getQualifiedClassName(MediatorViewGettingStarted));
			}

			private function initializeListOfBookmarks():void
			{
				var bookmarksProxy:ProxyBookmarks = facade.retrieveProxy(ProxyBookmarks.NAME) as ProxyBookmarks;
					bookmarksProxy.getCustomBookmarksList();
				var genesisAppsProxy:ProxyGenesisApps = facade.retrieveProxy(ProxyGenesisApps.NAME) as ProxyGenesisApps;
					genesisAppsProxy.getInstalledApps();
			}
			
			private function initializeGenesisApplicationsList():void
			{
				this.removeMediatorFromAdditionalNavigation(view.viewInstalledAppsNavigation);
				this.removeMediatorFromAdditionalNavigation(view.viewBookmarksNavigation);
				sendNotification(ApplicationConstants.COMMAND_REMOVE_REGISTER_MAIN_VIEW, {
					view: view,
					currentView: view.viewGenesisApps,
					currentSelection: MediatorGenesisApps.NAME
				}, "mediator.applications.MediatorGenesisApps");
			}
			
			private function initializeGenesisDirs():void
			{
				this.removeMediatorFromAdditionalNavigation(view.viewInstalledAppsNavigation);
				this.removeMediatorFromAdditionalNavigation(view.viewBookmarksNavigation);
				
				sendNotification(ApplicationConstants.COMMAND_REMOVE_REGISTER_MAIN_VIEW, {
					view: view,
					currentView: view.viewGenesisDirs,
					currentSelection: MediatorGenesisDirs.NAME
				}, "mediator.applications.MediatorGenesisDirs");	
			}
			
			private function initializeGenesisEditDir():void
			{
				this.removeMediatorFromAdditionalNavigation(view.viewInstalledAppsNavigation);
				this.removeMediatorFromAdditionalNavigation(view.viewBookmarksNavigation);
				
				sendNotification(ApplicationConstants.COMMAND_REMOVE_REGISTER_MAIN_VIEW, {
					view: view,
					currentView: view.viewGenesisEditDir,
					currentSelection: MediatorGenesisEditDir.NAME
				}, "mediator.applications.MediatorGenesisEditDir");		
			}
			
			private function initializeAddEditBookmark():void
			{
				this.removeMediatorFromAdditionalNavigation(view.viewBookmarksNavigation);
				
				sendNotification(ApplicationConstants.COMMAND_REMOVE_REGISTER_MAIN_VIEW, {
					view: view,
					currentView: view.viewEditBookmark,
					currentSelection: MediatorEditBookmark.NAME,
					mediatorName: MediatorEditBookmark.NAME
				}, "mediator.bookmarks.MediatorEditBookmark");
			}
			
			private function selectBookmarkGroup(group:String):void
			{
				var bookmarkGroup:NavigationLinkVO = null;
				var bookmarkNavGroup:ArrayList = view.viewBookmarksNavigation["dataProvider"];
				
				for (var i:int = 0; i < bookmarkNavGroup.length; i++)
				{
					bookmarkGroup = bookmarkNavGroup.getItemAt(i) as NavigationLinkVO;
					if (bookmarkGroup.subMenu)
					{
						for (var j:int = 0; j < bookmarkGroup.subMenu.length; j++)
						{
							var subBookmarkNav:NavigationLinkVO = bookmarkGroup.subMenu.getItemAt(j) as NavigationLinkVO;
							if (group == subBookmarkNav.data.name)
							{
								bookmarkGroup.selectedChild = subBookmarkNav;
								break;
							}
						}
					}
					else
					{
						bookmarkGroup = null;
					}
					
					if (bookmarkGroup != null && bookmarkGroup.selectedChild != null)
					{
						break;
					}
				}
				
				view.viewBookmarksNavigation["selectedItem"] = bookmarkGroup;
				onNavigationBookmarksSelectionChange(null);
			}
		
	//----------------------------------
	// MENU
	//----------------------------------

			private function initializeLoggedUserInformation():void
			{
				var loggedUser:UserVO = loginProxy.getData() as UserVO;
				if (loggedUser)
				{
					view.loggedUsername = loggedUser.username;
				}

				view.logoutVisible = true;
				view.autoSizeDrawer = true;
				this.mediatorName
				var proxyUrlParams:ProxyUrlParameters = facade.retrieveProxy(ProxyUrlParameters.NAME) as ProxyUrlParameters;
				if (proxyUrlParams.component)
				{
					sendNotification(proxyUrlParams.component);
				}
			}		

			private function routeParamsToComponent(routeValue:ValueEvent):void
			{
				var urlParamsProxy:ProxyUrlParameters = facade.retrieveProxy(ProxyUrlParameters.NAME) 
														as ProxyUrlParameters;
				urlParamsProxy.setData({params: routeValue.value.params, component: routeValue.value.component});

				if (urlParamsProxy.isPasswordReset || urlParamsProxy.isForgotPassword)
				{
					sendNotification(ApplicationConstants.COMMAND_START_PASSWORD_RESET);
				}
				else if (urlParamsProxy.isRegister)
				{
					sendNotification(ApplicationConstants.COMMAND_START_NEW_REGISTRATION);
				}											
				
				sendNotification(ApplicationConstants.COMMAND_CLEAN_URL_PARAMETERS);
			}
			
			private function onLogoutClick(event:MouseEvent):void
			{
				var proxyUrlParams:ProxyUrlParameters = facade.retrieveProxy(ProxyUrlParameters.NAME) as ProxyUrlParameters;
				proxyUrlParams.setData(null);
				
				loginProxy.logout();
			}
			
			private function onSwitchTheme(event:MouseEvent):void
			{
				var themeProxy:ProxyTheme = facade.retrieveProxy(ProxyTheme.NAME) as ProxyTheme;
				var currentTheme:Object = themeProxy.getTheme();
				sendNotification(ApplicationConstants.COMMAND_SWITCH_THEME, currentTheme.theme == Theme.DARK ? Theme.LIGHT : Theme.DARK);
			}
			
			private function onNavigationSectionChange(event:Event):void
			{
				var selectedItem:Object = view.viewDrawerNavigation["selectedItem"];
				var currentSelection:Object = selectedItem;
				
				if (selectedItem.selectedChild)
				{
					currentSelection = selectedItem.selectedChild;
				}				
				
				if (facade.hasMediator(MediatorViewGettingStarted.NAME))
				{
					facade.removeMediator(MediatorViewGettingStarted.NAME);	
				}
				
				if (facade.hasMediator(MediatorGenesisDirs.NAME))
				{
					facade.removeMediator(MediatorGenesisDirs.NAME);	
				}
				
				if (facade.hasMediator(MediatorGenesisEditDir.NAME))
				{
					facade.removeMediator(MediatorGenesisEditDir.NAME);	
				}
				
				if (facade.hasMediator(MediatorEditBookmark.NAME))
				{
					facade.removeMediator(MediatorEditBookmark.NAME);	
				}
				
				sendNotification(ApplicationConstants.COMMAND_DRAWER_CHANGED, false);
				sendNotification(currentSelection.notificationName);
			}
			
			private function onNavigationBookmarksSelectionChange(event:Event):void
			{
				this.removeMediatorFromAdditionalNavigation(view.viewDrawerNavigation);
				this.removeMediatorFromAdditionalNavigation(view.viewInstalledAppsNavigation);
				
				var selectedItem:NavigationLinkVO = view.viewBookmarksNavigation["selectedItem"];
				var currentSelection:NavigationLinkVO = selectedItem;
				if (selectedItem.selectedChild)
				{
					currentSelection = selectedItem.selectedChild;
				}	
				
				view.bookmarksViewSection["name"] = currentSelection.idSelectedItem;
				var bookmarksProxy:ProxyBookmarks = facade.retrieveProxy(ProxyBookmarks.NAME) as ProxyBookmarks;
					bookmarksProxy.selectedGroup = currentSelection.name;
					
				sendNotification(ApplicationConstants.COMMAND_REMOVE_REGISTER_MAIN_VIEW, {
					view: view,
					currentView: view.bookmarksView,
					currentSelection: currentSelection.idSelectedItem,
					drawerNavigation: view.viewBookmarksNavigation,
					mediatorName: currentSelection.idSelectedItem
				}, "mediator.bookmarks.MediatorBookmarks");
			}
			
			private function onNavigationInstalledAppSectionChange(event:Event):void
			{
				this.removeMediatorFromAdditionalNavigation(view.viewDrawerNavigation);
				this.removeMediatorFromAdditionalNavigation(view.viewBookmarksNavigation);
				
				var selectedItem:NavigationLinkVO = view.viewInstalledAppsNavigation["selectedItem"];
				var currentSelection:NavigationLinkVO = selectedItem;
				if (selectedItem.selectedChild)
				{
					currentSelection = selectedItem.selectedChild;
				}	
						
				if (facade.hasMediator(MediatorGenesisEditDir.NAME))
				{
					facade.removeMediator(MediatorGenesisEditDir.NAME);	
				}
				
				if (facade.hasMediator(MediatorEditBookmark.NAME))
				{
					facade.removeMediator(MediatorEditBookmark.NAME);	
				}
				
				view.installedAppsSection["name"] = currentSelection.idSelectedItem;
				var genesisAppsProxy:ProxyGenesisApps = facade.retrieveProxy(ProxyGenesisApps.NAME) as ProxyGenesisApps;
					genesisAppsProxy.selectedApplication = currentSelection.data as ApplicationVO;
					
				//Finish up here
				sendNotification(ApplicationConstants.COMMAND_REMOVE_REGISTER_MAIN_VIEW, {
					view: view,
					currentView: view.installedAppsView,
					currentSelection: currentSelection.idSelectedItem,
					drawerNavigation: view.viewInstalledAppsNavigation,
					mediatorName: currentSelection.idSelectedItem
				}, "mediator.applications.MediatorInstalledApps");
			}
			
			private function onDrawerButtonShowHide(event:MouseEvent):void
			{
				if (view.isDrawerOpen)
				{
					view.toggleDrawerOpen(false);
				}
				else
				{
					view.toggleDrawerOpen(true);
				}
			}
			
			private function onOpenCloseDrawer(event:Event):void
			{
				sendNotification(ApplicationConstants.COMMAND_ADJUST_TAB_BAR_SIZE);	
			}						

			private function removeMediatorFromAdditionalNavigation(navigation:IEventDispatcher):void
			{
				//Remove mediator from second navigation
				var selectedItem:NavigationLinkVO = navigation["selectedItem"];
				if (selectedItem)
				{
					var currentSelection:NavigationLinkVO = selectedItem;
					if (selectedItem.selectedChild)
					{
						currentSelection = selectedItem.selectedChild;
					}	
					
					if (facade.hasMediator(currentSelection.idSelectedItem))
					{
						facade.removeMediator(currentSelection.idSelectedItem);
						
						navigation["selectedItem"] = null;
					}
				}
			}
    }
}