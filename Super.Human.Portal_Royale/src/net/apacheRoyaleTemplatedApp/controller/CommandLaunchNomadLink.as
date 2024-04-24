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
		override public function execute(note:INotification):void 
		{
			var loginProxy:ProxyLogin = facade.retrieveProxy(ProxyLogin.NAME) as ProxyLogin;
			var nomadHelperUrl:String = loginProxy.config.config.nomad_helper_url;
			var link:String = note.getBody().link;
			window["onmessage"] = null;
			
			if (nomadHelperUrl)
			{
				var mainMediator:MediatorMainContentView = facade.retrieveMediator(MediatorMainContentView.NAME) as MediatorMainContentView;
				var nomadHelper:Iframe = mainMediator.view.viewNomadHelper as Iframe;
				
				window["onmessage"] = onWindowMessage;
				
				var encodedLink:String = encodeURIComponent(link);
				nomadHelper.src = nomadHelperUrl + "?link=" + encodedLink;
				
				var appName:String = note.getBody().name;
				Snackbar.show("Opening application " + appName + " in HCL Nomad Web in progress...", 4000, null);
			}
			else
			{
				navigateToURL(new URLRequest(link));
			}
		}
		
		private function onWindowMessage(event:Event):void 
		{
			var loginProxy:ProxyLogin = facade.retrieveProxy(ProxyLogin.NAME) as ProxyLogin;
			var nomadHelperUrl:String = loginProxy.config.config.nomad_helper_url;
			
			window["onmessage"] = null;
			var winMessage:String = event["data"];
			var errorPrefix:String = "[Error]";
			var hasErrorIndex:int = winMessage.indexOf(errorPrefix);
			var hasOriginIndex:int = nomadHelperUrl.indexOf(event["origin"]);
			
			if (hasErrorIndex > -1 && hasOriginIndex > -1)
			{
				winMessage = winMessage.substr(errorPrefix.length, winMessage.length);
				sendNotification(ApplicationConstants.NOTE_FAILED_OPEN_NOMAD_LINK, winMessage);
			}
		}
	}
}