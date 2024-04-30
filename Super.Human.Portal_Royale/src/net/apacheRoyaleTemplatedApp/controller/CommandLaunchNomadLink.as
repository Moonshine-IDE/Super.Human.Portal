package controller
{
	import mediator.MediatorMainContentView;

	import org.apache.royale.html.elements.Iframe;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.apache.royale.jewel.Snackbar;
	import model.proxy.login.ProxyLogin;
	import org.apache.royale.net.navigateToURL;
	import org.apache.royale.net.URLRequest;
	import constants.ApplicationConstants;

	public class CommandLaunchNomadLink extends SimpleCommand
	{
		private var data:Object;
		
		override public function execute(note:INotification):void 
		{
			// Retrieve the configred nomadhelper.html URL
			var loginProxy:ProxyLogin = facade.retrieveProxy(ProxyLogin.NAME) as ProxyLogin;
			var nomadHelperUrl:String = loginProxy.config.config.nomad_helper_url;
			data = note.getBody();
			
			var link:String = note.getBody().link;
			window["onmessage"] = null;
			
			if (nomadHelperUrl)  // if a nomadhelper.html URL is configured
			{
				// find the placeholder iframe defined in MainContent.mxml
				var mainMediator:MediatorMainContentView = facade.retrieveMediator(MediatorMainContentView.NAME) as MediatorMainContentView;
				var nomadHelper:Iframe = mainMediator.view.viewNomadHelper as Iframe;
				
				// register an event handler for error validation
				window["onmessage"] = onWindowMessage;
				
				// initialize the iframe with the Nomad URL.  This will trigger the logic in nomadhelper.html
				var encodedLink:String = encodeURIComponent(link);
				nomadHelper.src = nomadHelperUrl + "?link=" + encodedLink;
			}
			else   // otherwise, don't use nomadhelper.html.  Open the URL directly
			{
				navigateToURL(new URLRequest(link));
				
				data = null;
			}
		}
		
		// This triggers on any messages sent by nomadhelper.html
		private function onWindowMessage(event:Event):void 
		{
			if (!data) return;
			
			// Retrieve the configred nomadhelper.html URL
			var loginProxy:ProxyLogin = facade.retrieveProxy(ProxyLogin.NAME) as ProxyLogin;
			var nomadHelperUrl:String = loginProxy.config.config.nomad_helper_url;
			
			// Cancel any later messages - not expected
			window["onmessage"] = null;
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
					// An error was reported.  Open the Nomad URL directly
					winMessage = winMessage.substr(errorPrefix.length, winMessage.length);
					navigateToURL(new URLRequest(data.link));
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
