package mediator.applications
{
    import interfaces.IInstalledAppView;

    import model.proxy.applicationsCatalog.ProxyGenesisApps;
    import model.proxy.urlParams.ProxyUrlParameters;
    import model.vo.ApplicationVO;

    import org.apache.royale.events.MouseEvent;
    import org.apache.royale.icons.MaterialIcon;
    import org.apache.royale.jewel.IconButton;
    import org.apache.royale.jewel.VGroup;
    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;

    import view.applications.ConfigurationAppDetails;
    
    public class MediatorInstalledApps extends Mediator implements IMediator
    {
		public static const NAME:String  = 'MediatorInstalledApp';
		
		private var genesisAppsProxy:ProxyGenesisApps;
		private var urlParamsProxy:ProxyUrlParameters;
		
		public function MediatorInstalledApps(mediatorName:String, component:IInstalledAppView) 
		{
			super(mediatorName, component);
		}
		
		override public function onRegister():void 
		{			
			super.onRegister();
			
			this.genesisAppsProxy = facade.retrieveProxy(ProxyGenesisApps.NAME) as ProxyGenesisApps;
			
			updateView();
		}
		
		override public function onRemove():void 
		{			
			super.onRemove();

			view.seeMoreDetails["html"] = "";
			view.seeMoreDetails["text"] = "App details";
			view.appDescription = "No description";
			cleanUpInstalledAppLinks();
			
			this.genesisAppsProxy = null;
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
		
		public function get view():IInstalledAppView
		{
			return viewComponent as IInstalledAppView;
		}

		private function updateView():void
		{
			if (genesisAppsProxy.selectedApplication)
			{
				view.applicationName = genesisAppsProxy.selectedApplication.label;
				view.appDescription = "No description";
				
				if (genesisAppsProxy.selectedApplication.access)
				{
					view.appDescription = genesisAppsProxy.selectedApplication.access.description;
				}
				
				updateInstalledAppLinks();
			}
			
			updateSeeDetails();
		}
		
		private function updateSeeDetails():void
		{
			if (genesisAppsProxy.selectedApplication)
			{
				view.seeMoreDetails["html"] = '<a height="100%" href="' + genesisAppsProxy.selectedApplication.detailsUrl + '" target="_blank">App details</a>';
			}
			else
			{
				view.seeMoreDetails["html"] = "";
				view.seeMoreDetails["text"] = "App details";
			}
		}

		private function updateInstalledAppLinks():void
		{
			var selectedApp:ApplicationVO = genesisAppsProxy.selectedApplication;
			
			if(selectedApp && selectedApp.access && selectedApp.access.links)
			{
				view.installedAppLinksContainer.visible = true;
				
				var links:Array = selectedApp.access.links;
				for (var i:int = 0; i < links.length; i++)
				{
					var link:Object = links[i];
					var iconButton:IconButton = null;
						
					if (link.type == ApplicationVO.LINK_BROWSER)
					{
						iconButton = new IconButton();
						iconButton.height = 40;
						iconButton.className = "linksGapInstallApp noLinkStyleInstallApp";
						iconButton.emphasis = "primary";
						iconButton.html = '<a height="100%" width="100%" href="' + link.url + '" target="_blank">' + link.name + '</a>';
							
						view.installedAppLinks.addElement(iconButton);
					}
					else if (link.type == ApplicationVO.LINK_DATABASE)
					{
						var dbContainer:VGroup = new VGroup();
							dbContainer.percentWidth = 100;
							dbContainer.gap = 2;
							
						var icon:MaterialIcon = new MaterialIcon();
							icon.text = MaterialIconType.ARROW_DROP_DOWN;
							
						iconButton = new IconButton();
						iconButton.height = 40;
						iconButton.className = "linksGapInstallApp";
						iconButton.emphasis = "primary";
						iconButton.text = link.name;
						iconButton.rightPosition = true;
						iconButton.icon = icon;
						iconButton.addEventListener(MouseEvent.CLICK, onShowHideDbConfigClick);
							
						dbContainer.addElement(iconButton);
						
						var configurationDetails:ConfigurationAppDetails = new ConfigurationAppDetails();
							configurationDetails.currentState = "installedApp";
							configurationDetails.percentWidth = 100;
							configurationDetails.server = link.server;
							configurationDetails.database = link.database;						
							configurationDetails.viewName = link.view;
							configurationDetails.clientOpenLink = link.url ? '<a height="100%" width="100%" href="' + link.url + '" target="_blank">Open in Client</a>' : null;
							configurationDetails.nomadOpenLink = link.nomadURL ? '<a height="100%" width="100%" href="' + link.nomadURL + '" target="_blank">Open in Nomad</a>' : null;
							configurationDetails.visible = false;
							
						dbContainer.addElement(configurationDetails);
						
						view.installedAppLinks.addElement(dbContainer);
						
						//Fix problem with databinding and states - Royale issue
						configurationDetails.description = "";
						configurationDetails.description = link.description;
					}
				}
			}
			else
			{
				view.installedAppLinksContainer.visible = false;
			}
		}

		private function cleanUpInstalledAppLinks():void
		{
			view.installedAppLinksContainer.visible = false;
			
			var linksCount:int = view.installedAppLinks.numElements - 1;
			for (var i:int = linksCount; i >= 0; i--)
			{
				var linkEl:Object = view.installedAppLinks.getElementAt(i);
				
				for (var j:int = 0; j < linkEl.numElements; j++)
				{
					var internalItem:Object = linkEl.getElementAt(j) as IconButton;
					if (internalItem)
					{
						internalItem.removeEventListener(MouseEvent.CLICK, onShowHideDbConfigClick);
					}
				}
					
				view.installedAppLinks.removeElement(linkEl);
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