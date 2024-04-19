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

	public class CommandLaunchNomadLink extends SimpleCommand
	{
		override public function execute(note:INotification):void 
		{
			var loginProxy:ProxyLogin = facade.retrieveProxy(ProxyLogin.NAME) as ProxyLogin;
			var nomadHelperUrl:String = loginProxy.config.nomad_helper_url;
			var link:String = note.getBody().link;
			
			if (nomadHelperUrl)
			{
				var mainMediator:MediatorMainContentView = facade.retrieveMediator(MediatorMainContentView.NAME) as MediatorMainContentView;
				var nomadHelper:Iframe = mainMediator.view.viewNomadHelper as Iframe;
				

				var encodedLink:String = encodeURIComponent(link);
				nomadHelper.src = nomadHelperUrl + "?link=" + encodedLink;
				
				var appName:String = note.getBody().name;
				Snackbar.show("Application " + appName + " has been opened in HCL Nomad web", 4000, null);
			}
			else
			{
				navigateToURL(new URLRequest(link));
			}
		}
	}
}