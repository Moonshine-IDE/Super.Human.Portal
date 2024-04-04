package controller
{
	import model.proxy.login.ProxyLogin;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.apache.royale.utils.js.loadJavascript;
	import org.apache.royale.net.HTTPService;
	import org.apache.royale.net.beads.CORSCredentialsBead;
	import org.apache.royale.net.events.FaultEvent;
	import org.apache.royale.net.HTTPHeader;
	import mediator.MediatorMainContentView;
	import org.apache.royale.jewel.Group;
	import org.apache.royale.core.IChild;

	public class CommandLaunchNomadLink extends SimpleCommand
	{
		override public function execute(note:INotification):void 
		{
			var mainMediator:MediatorMainContentView = facade.retrieveMediator(MediatorMainContentView.NAME) as MediatorMainContentView;
			
			var nomadHelper:Group = mainMediator.view.viewNomadHelper as Group;
			
			if (nomadHelper.numElements > 0)
			{
				for (var i:int = nomadHelper.numElements - 1; i >= 0; i--)
				{
					var element:IChild = nomadHelper.getElementAt(i);
					nomadHelper.removeElement(element);
				}
			}
			
			var nomadHelperContent:Group = new Group();
				nomadHelper.addElement(nomadHelperContent);
			
			var link:String = String(note.getBody());
			window["$"](nomadHelperContent.element).load("https://nomadweb.venus.startcloud.com/nomad/nomadhelper.html?link='"+link+"'", function(responseText:String, textStatus:String, jqXHR:Object):void {
				var status:String = textStatus;
			});
		}
	}
}