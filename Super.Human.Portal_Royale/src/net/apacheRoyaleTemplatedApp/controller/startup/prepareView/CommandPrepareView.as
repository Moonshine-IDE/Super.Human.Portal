package controller.startup.prepareView
{
	import constants.ApplicationConstants;

	import interfaces.IApplication;

	import mediator.MediatorApacheRoyaleTemplatedApp;
	import mediator.MediatorLoginPopup;
	import mediator.MediatorMainContentView;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
			
	public class CommandPrepareView extends SimpleCommand
	{
		override public function execute(note: INotification):void	
		{
			var app:IApplication = note.getBody() as IApplication;
			
			facade.registerMediator(new MediatorApacheRoyaleTemplatedApp(app));
			facade.registerMediator(new MediatorMainContentView(app.mainContent));	
			facade.registerMediator(new MediatorLoginPopup(app.mainContent.login));		
						
			sendNotification(ApplicationConstants.COMMAND_AUTH_TEST);
		}		
	}
}