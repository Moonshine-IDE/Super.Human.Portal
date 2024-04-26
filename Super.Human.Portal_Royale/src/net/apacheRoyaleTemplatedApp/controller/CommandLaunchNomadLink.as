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
			var loginProxy:ProxyLogin = facade.retrieveProxy(ProxyLogin.NAME) as ProxyLogin;
			var nomadHelperUrl:String = loginProxy.config.config.nomad_helper_url;
			data = note.getBody();
			
			var link:String = note.getBody().link;
			window["onmessage"] = null;
			
			if (nomadHelperUrl)
			{
				var mainMediator:MediatorMainContentView = facade.retrieveMediator(MediatorMainContentView.NAME) as MediatorMainContentView;
				var nomadHelper:Iframe = mainMediator.view.viewNomadHelper as Iframe;
				
				window["onmessage"] = onWindowMessage;
				
				var encodedLink:String = encodeURIComponent(link);
				nomadHelper.src = nomadHelperUrl + "?link=" + encodedLink;
			}
			else
			{
				navigateToURL(new URLRequest(link));
				
				data = null;
			}
		}
		
		private function onWindowMessage(event:Event):void 
		{
			if (!data) return;
			
			var loginProxy:ProxyLogin = facade.retrieveProxy(ProxyLogin.NAME) as ProxyLogin;
			var nomadHelperUrl:String = loginProxy.config.config.nomad_helper_url;
			
			window["onmessage"] = null;
			var winMessage:String = event["data"];
			var errorPrefix:String = "[Error]";
			var successPrefix:String = "[Success]";
			
			var hasErrorIndex:int = winMessage.indexOf(errorPrefix);
			var successIndex:int = winMessage.indexOf(successPrefix);
			var hasOriginIndex:int = nomadHelperUrl.indexOf(event["origin"]);
			
			if (hasOriginIndex > -1)
			{
				if (hasErrorIndex > -1)
				{
					winMessage = winMessage.substr(errorPrefix.length, winMessage.length);
					navigateToURL(new URLRequest(data.link));
				}
				else if (successIndex > -1)
				{				
					Snackbar.show("Application " + data.name + " has been opened in browser tab with HCL Nomad Web.", 6000, null);
				}
			
			}

			data = null;
		}
	}
}