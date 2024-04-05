package controller
{
	import mediator.MediatorMainContentView;

	import org.apache.royale.html.elements.Iframe;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class CommandLaunchNomadLink extends SimpleCommand
	{
		override public function execute(note:INotification):void 
		{
			var mainMediator:MediatorMainContentView = facade.retrieveMediator(MediatorMainContentView.NAME) as MediatorMainContentView;
			var nomadHelper:Iframe = mainMediator.view.viewNomadHelper as Iframe;
			var link:String = String(note.getBody());
			var encodedLink:String = encodeURIComponent(link);
			nomadHelper.src = "https://nomadweb.venus.startcloud.com/nomad/nomadhelper.html?link=" + encodedLink;
		}
	}
}