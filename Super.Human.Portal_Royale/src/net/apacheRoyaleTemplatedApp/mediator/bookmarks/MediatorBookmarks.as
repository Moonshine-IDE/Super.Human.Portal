package mediator.bookmarks
{
    import interfaces.IBookmarksView;

    import model.proxy.customBookmarks.ProxyBookmarks;
    import model.proxy.urlParams.ProxyUrlParameters;
    import model.vo.ApplicationVO;
    import model.vo.BookmarkVO;

    import org.apache.royale.events.MouseEvent;
    import org.apache.royale.icons.MaterialIcon;
    import org.apache.royale.jewel.IconButton;
    import org.apache.royale.jewel.VGroup;
    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;

    import view.applications.ConfigurationAppDetails;
    
    public class MediatorBookmarks extends Mediator implements IMediator
    {
		public static const NAME:String  = 'MediatorBookmarks';
		
		private var bookmarksProxy:ProxyBookmarks;
		private var urlParamsProxy:ProxyUrlParameters;
		
		public function MediatorBookmarks(mediatorName:String, component:IBookmarksView) 
		{
			super(mediatorName, component);
		}
		
		override public function onRegister():void 
		{			
			super.onRegister();
			
			this.bookmarksProxy = facade.retrieveProxy(ProxyBookmarks.NAME) as ProxyBookmarks;
			
			updateView();
		}
		
		override public function onRemove():void 
		{			
			super.onRemove();

			cleanUpBookmarksList();
			
			this.bookmarksProxy = null;
		}
		
		
		override public function listNotificationInterests():Array 
		{
			var interests:Array = super.listNotificationInterests();
	
			return interests;
		}
		
		override public function handleNotification(note:INotification):void 
		{
			switch (note.getName()) 
			{
				
			}
		}		
		
		public function get view():IBookmarksView
		{
			return viewComponent as IBookmarksView;
		}

		private function updateView():void
		{
			view.groupName = bookmarksProxy.selectedGroup;
			
			this.cleanUpBookmarksList();
			this.updateListOfBookmarks();
		}

		private function updateListOfBookmarks():void
		{
			var bookmarks:Array = this.bookmarksProxy.getData() as Array;
				bookmarks = bookmarks.filter(function(b:BookmarkVO, index:int, arr:Array):Boolean{
					return b.group == bookmarksProxy.selectedGroup;	
				});
				
			for (var i:int = 0; i < bookmarks.length; i++)
			{
				var bookmark:BookmarkVO = bookmarks[i];
				
				var iconButton:IconButton = null;
					
				if (bookmark.type == ApplicationVO.LINK_BROWSER || bookmark.type == "url")
				{
					iconButton = new IconButton();
					iconButton.height = 40;
					iconButton.className = "linksGapInstallApp noLinkStyleInstallApp";
					iconButton.emphasis = "primary";
					iconButton.html = '<a height="100%" width="100%" href="' + bookmark.url + '" target="_blank">' + bookmark.name + '</a>';
						
					view.bookmarksList.addElement(iconButton);
				}
				else if (bookmark.type == ApplicationVO.LINK_DATABASE)
				{
					var dbContainer:VGroup = new VGroup();
						dbContainer.percentWidth = 100;
						dbContainer.gap = 2;
						
					var icon:MaterialIcon = new MaterialIcon();
						icon.text = MaterialIconType.ARROW_DROP_DOWN;
						
					iconButton = new IconButton();
					iconButton.height = 40;
					iconButton.className = "linksGapInstallApp paddingConfigButton";
					iconButton.emphasis = "primary";
					iconButton.text = bookmark.name;
					iconButton.rightPosition = true;
					iconButton.icon = icon;
					iconButton.addEventListener(MouseEvent.CLICK, onShowHideDbConfigClick);
						
					dbContainer.addElement(iconButton);
					
					var configurationDetails:ConfigurationAppDetails = new ConfigurationAppDetails();
						configurationDetails.percentWidth = 100;
						configurationDetails.description = bookmark.description;
						configurationDetails.server = bookmark.server;
						configurationDetails.database = bookmark.database;
						configurationDetails.viewName = bookmark.view;
						configurationDetails.clientOpenLink = bookmark.url ? '<a height="100%" width="100%" href="' + bookmark.url + '" target="_blank">Open in Client</a>' : null;
						configurationDetails.nomadOpenLink = bookmark.nomadURL ? '<a height="100%" width="100%" href="' + bookmark.nomadURL + '" target="_blank">Open in Nomad</a>' : null;
						configurationDetails.visible = false;
						
					dbContainer.addElement(configurationDetails);
					
					view.bookmarksList.addElement(dbContainer);
				}
			}
		}

		private function cleanUpBookmarksList():void
		{
			var listCount:int = view.bookmarksList.numElements - 1;
			for (var i:int = listCount; i >= 0; i--)
			{
				var bookmarkItem:Object = view.bookmarksList.getElementAt(i);
					
				view.bookmarksList.removeElement(bookmarkItem);
			}
		}
		
		private function onShowHideDbConfigClick(event:MouseEvent):void
		{
			var iconButton:IconButton = event.currentTarget as IconButton;
			var currentIcon:MaterialIcon = iconButton.icon as MaterialIcon;
			var showHideConfig:Boolean = false;
			
			if (currentIcon.text == MaterialIconType.ARROW_DROP_DOWN)
			{
				currentIcon.text = MaterialIconType.ARROW_DROP_UP;
				showHideConfig = true;
			}
			else
			{
				currentIcon.text = MaterialIconType.ARROW_DROP_DOWN;
			}
			
			var configContainer:Object = iconButton.parent;
			for (var i:int = 0; i < configContainer.numElements; i++)
			{
				var config:Object = configContainer.getElementAt(i);
				if (config is ConfigurationAppDetails)
				{
					config.visible = showHideConfig;
					break;
				}
			}
		}
    }
}