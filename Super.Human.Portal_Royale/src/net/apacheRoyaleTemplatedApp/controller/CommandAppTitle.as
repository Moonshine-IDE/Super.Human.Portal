package controller
{
	import mediator.MediatorMainContentView;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class CommandAppTitle extends SimpleCommand
	{
		override public function execute(note:INotification):void 
		{
			var mainMediator:MediatorMainContentView = facade.retrieveMediator(MediatorMainContentView.NAME)
			 											as MediatorMainContentView;
			var element:Object = mainMediator.view["element"];
			
			element.ownerDocument.title = "Apache Royale Templated Application";
		}
	}
}