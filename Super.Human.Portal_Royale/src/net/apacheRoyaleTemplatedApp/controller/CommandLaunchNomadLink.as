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
		private var link:String;
		
		override public function execute(note:INotification):void 
		{
			var loginProxy:ProxyLogin = facade.retrieveProxy(ProxyLogin.NAME) as ProxyLogin;
			var nomadHelperUrl:String = loginProxy.config.config.nomad_helper_url;
			link = note.getBody().link;
			window["onmessage"] = null;
			
			if (nomadHelperUrl)
			{
				var mainMediator:MediatorMainContentView = facade.retrieveMediator(MediatorMainContentView.NAME) as MediatorMainContentView;
				var nomadHelper:Iframe = mainMediator.view.viewNomadHelper as Iframe;
				
				window["onmessage"] = onWindowMessage;
				
				var encodedLink:String = encodeURIComponent(link);
				nomadHelper.src = nomadHelperUrl + "?link=" + encodedLink;
				
				var appName:String = note.getBody().name;
				Snackbar.show("Application " + appName + " has been opened in browser tab with HCL Nomad Web.", 6000, null);
			}
			else
			{
				navigateToURL(new URLRequest(link));
			}
			
			link = null;
		}
		
		private function onWindowMessage(event:Event):void 
		{
			if (!link) return;
			
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
				navigateToURL(new URLRequest(link));
			}
			
			link = null;
		}
	}
}