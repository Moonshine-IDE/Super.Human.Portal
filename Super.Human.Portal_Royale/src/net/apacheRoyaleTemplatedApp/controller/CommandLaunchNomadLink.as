package controller
{
	import mediator.MediatorMainContentView;

	import model.proxy.login.ProxyLogin;

	import org.apache.royale.events.DetailEvent;
	import org.apache.royale.html.elements.Iframe;
	import org.apache.royale.jewel.Snackbar;
	import org.apache.royale.net.URLRequest;
	import org.apache.royale.net.URLStream;
	import org.apache.royale.net.navigateToURL;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import view.controls.snackbarNomadHelperUrl.SnackbarNomadHelperUrl;
	import view.controls.snackbarNomadHelperUrl.SnackbarNomadPopupBlocked;

	/**
	 * This is a workaround to open a Nomad link directly in an existing Nomad tab by using the Nomad service worker.
	 * This requires that nomadhelper.html is setup on the Nomad server.  The site must match Nomad in order to access the service worker.
	 * If no nomadhelper.html URL is configured, or the service worker is not loaded, then open the URL with the
	 *  default method (Open the URL in a new tab.  If Nomad is actually open, then open the database in the original Nomad tab.
	 */
	public class CommandLaunchNomadLink extends SimpleCommand
	{
		private var data:Object;
		
		override public function execute(note:INotification):void 
		{
			// Retrieve the configred nomadhelper.html URL
			var loginProxy:ProxyLogin = facade.retrieveProxy(ProxyLogin.NAME) as ProxyLogin;
			data = note.getBody();
			
			var link:String = data.link;
			window["onmessage"] = null;
			
			if (loginProxy.isNomadHelperUrlExists())  // if a nomadhelper.html URL is configured, try to open the URL with nomadhelper.html first
			{
				// find the placeholder iframe defined in MainContent.mxml
				var mainMediator:MediatorMainContentView = facade.retrieveMediator(MediatorMainContentView.NAME) as MediatorMainContentView;
				var nomadHelper:Iframe = mainMediator.view.viewNomadHelper as Iframe;
				
				// register an event handler for error validation
				window["onmessage"] = onWindowMessage;
				
				// initialize the iframe with the Nomad URL.  This will trigger the logic in nomadhelper.html
				var encodedLink:String = encodeURIComponent(link);
				var nomadHelperUrl:String = loginProxy.config.config.nomad_helper_url;
				
				var urlCheck:URLStream = new URLStream();
					urlCheck.addEventListener("communicationError", function onNomadUrlError(event:DetailEvent):void {
						urlCheck.removeEventListener("communicationError", onNomadUrlError);
						Snackbar.show("It looks like the server for " + nomadHelperUrl + " is not responding. Please check DNS, the Domino server, and the Nomad task to ensure it is running.", 
										6000);
						
					});
					urlCheck.load(new URLRequest(nomadHelperUrl));
				nomadHelper.src = nomadHelperUrl + "?link=" + encodedLink;
			}
			else   // otherwise, don't use nomadhelper.html.  Open the Nomad link in a new tab.  If Nomad is open already, the database will be opened in the original tab
			{
				var nomadWarningLink:Boolean = Boolean(window["Cookies"].get("SuperHumanPortalNomadHelperUrlLinkWarning"));
				if (!loginProxy.isNomadHelperUrlExists() && nomadWarningLink == false)
				{
					window["Cookies"].set("SuperHumanPortalNomadHelperUrlLinkWarning", true, { sameSite: 'strict' });
					
					SnackbarNomadHelperUrl.show(loginProxy.config.config.domino_data_directory, 
					  						     loginProxy.config.config.nomad_base_url,
					  						     loginProxy.config.config.configuration_link.nomadURL,
					  						     loginProxy.config.config.configuration_link.url);
				}
				
				try
				{
					navigateToURL(new URLRequest(link), "_blank");
				}
				catch(error:Error)
				{
					SnackbarNomadPopupBlocked.show();
				}
				
				data = null;
			}
		}
		
		// This triggers on any messages sent by nomadhelper.html
		private function onWindowMessage(event:Event):void 
		{			
			// Cancel any later messages - not expected
			window["onmessage"] = null;
			
			if (!data) 
			{
				return;
			}
			
			// Retrieve the configred nomadhelper.html URL
			var loginProxy:ProxyLogin = facade.retrieveProxy(ProxyLogin.NAME) as ProxyLogin;
			var nomadHelperUrl:String = loginProxy.config.config.nomad_helper_url;
			var nomadBaseUrl:String = loginProxy.config.config.nomad_base_url;

			// Get the message from the event
			var winMessage:String = event["data"];
			// Parse the message as an error or success message
			var errorPrefix:String = "[Error]";
			var successPrefix:String = "[Success]";
			var hasErrorIndex:int = winMessage.indexOf(errorPrefix);
			var successIndex:int = winMessage.indexOf(successPrefix);
			
			// Check if this event was triggered by the above method.  "onmessage" could be used by other logic in SuperHumanPortal
			var hasOriginIndex:int = nomadHelperUrl.indexOf(event["origin"]);
			if (hasOriginIndex > -1)
			{
				if (hasErrorIndex > -1)
				{
					// An error was reported.  Open the Nomad URL in a new tab.  If Nomad is already open, the database will be opened in the original tab.
					winMessage = winMessage.substr(errorPrefix.length, winMessage.length);
					
					try
					{
						navigateToURL(new URLRequest(data.link), "_blank");
					}
					catch(error:Error)
					{
						SnackbarNomadPopupBlocked.show();
					}
				}
				else if (successIndex > -1)
				{		
					// This was successful.  Show a temporary success message in the snacbar		
					Snackbar.show("Application " + data.name + " has been opened in browser tab with HCL Nomad Web.", 6000, null);
				}
			
			}
			// else:  this event came from a different source, so it will be ignored.

			data = null;
		}
	}
}
