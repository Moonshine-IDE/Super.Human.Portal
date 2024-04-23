package mediator.applications
{
    import constants.ApplicationConstants;

    import interfaces.IInstalledAppView;

    import model.proxy.applicationsCatalog.ProxyGenesisApps;
    import model.proxy.urlParams.ProxyUrlParameters;
    import model.vo.ApplicationVO;

    import org.apache.royale.events.MouseEvent;
    import org.apache.royale.jewel.IconButton;
    import org.apache.royale.jewel.VGroup;
    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;

    import view.applications.ConfigurationAppDetails;
    import view.controls.LinkWithDescriptionAppButton;
    
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

						var urlOpenDefault:String = link.nomadURL ? '<a height="100%" width="100%" href="' + link.nomadURL + '" target="_blank">' + link.name + '</a>' : link.name;
						if (link.defaultAction != "nomad")
						{
							urlOpenDefault = link.url ? '<a height="100%" width="100%" href="' + link.url + '" target="_blank">' + link.name + '</a>' : link.name;
						}
						var linkWithDescription:LinkWithDescriptionAppButton = new LinkWithDescriptionAppButton();
							linkWithDescription.description = link.description;
							linkWithDescription.linkLabel = urlOpenDefault;
							linkWithDescription.nomadURL = link.nomadURL;
							linkWithDescription.appName = link.name;
							linkWithDescription.addEventListener("showClick", onShowHideDbConfigClick);
						if (link.defaultAction == "nomad")
						{
							linkWithDescription.addEventListener("linkClick", onOpenInNomadLink);
						}
						
						dbContainer.addElement(linkWithDescription);
						
						var configurationDetails:ConfigurationAppDetails = new ConfigurationAppDetails();
							configurationDetails.currentState = "installedApp";
							configurationDetails.percentWidth = 100;
							configurationDetails.data = link;
							configurationDetails.server = link.server;
							configurationDetails.database = link.database;						
							configurationDetails.viewName = link.view;
							configurationDetails.clientOpenLink = link.url ? '<a height="100%" width="100%" href="' + link.url + '" target="_blank">Open in Client</a>' : null;
							configurationDetails.nomadOpenLink = link.nomadURL ? '<a height="100%" width="100%" href="' + link.nomadURL + '" target="_blank">Open in Nomad</a>' : null;

							configurationDetails.visible = false;
							
						dbContainer.addElement(configurationDetails);
						
						view.installedAppLinks.addElement(dbContainer);
						
						configurationDetails.openInNomad.addEventListener(MouseEvent.CLICK, onOpenInNomadConfig);
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
					var linkItem:Object = linkEl.getElementAt(j);
					var internalItem:Object = linkItem as LinkWithDescriptionAppButton;
					if (internalItem)
					{
						internalItem.removeEventListener("showClick", onShowHideDbConfigClick);
						internalItem.removeEventListener("linkClick", onOpenInNomadLink);
					}
					
					var confItem:Object = linkItem as ConfigurationAppDetails;
					if (confItem)
					{
						confItem.openInNomad.removeEventListener(MouseEvent.CLICK, onOpenInNomadConfig);
					}
				}
				
				view.installedAppLinks.removeElement(linkEl);
			}
		}

		private function onShowHideDbConfigClick(event:Event):void
		{
			var linkWithDescription:LinkWithDescriptionAppButton = event.currentTarget as LinkWithDescriptionAppButton;
			var configContainer:Object = linkWithDescription.parent;
			for (var i:int = 0; i < configContainer.numElements; i++)
			{
				var config:Object = configContainer.getElementAt(i);
				if (config is ConfigurationAppDetails)
				{
					config.visible = linkWithDescription.show;
					break;
				}
			}
		}
		
		private function onOpenInNomadLink(event:Event):void
		{
			var link:LinkWithDescriptionAppButton = event.currentTarget as LinkWithDescriptionAppButton;
			
			sendNotification(ApplicationConstants.COMMAND_LAUNCH_NOMAD_LINK, {name: link.appName, link: link.nomadURL});
		}
		
		private function onOpenInNomadConfig(event:Event):void
		{
			event.preventDefault();
			
			var confView:ConfigurationAppDetails = event["nativeEvent"].currentTarget.royale_wrapper.parent.parent.parent as ConfigurationAppDetails;
			var selectedApp:Object = confView.data;
			sendNotification(ApplicationConstants.COMMAND_LAUNCH_NOMAD_LINK, {name: selectedApp.database, link: selectedApp.nomadURL});
		}
    }
}