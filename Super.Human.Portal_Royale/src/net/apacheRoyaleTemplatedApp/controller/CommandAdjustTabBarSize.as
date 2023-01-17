package controller
{
	import mediator.MediatorMainContentView;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class CommandAdjustTabBarSize extends SimpleCommand
	{
		override public function execute(note:INotification):void 
		{	
			var mainMediator:MediatorMainContentView = facade.retrieveMediator(MediatorMainContentView.NAME) 
																			   as MediatorMainContentView;		
			var drawer:Object = mainMediator.view.viewDrawer;
			
			/*var vmDetailsGatewayMediator:MediatorVMDetailsGateway = facade.retrieveMediator(MediatorVMDetailsGateway.NAME)
																			   as MediatorVMDetailsGateway;	
			var leftButton:Object = null;																		
			if (vmDetailsGatewayMediator)
			{																		
				leftButton = vmDetailsGatewayMediator.view.detailsTabs["positioner"]["firstChild"];
			}
																		
			if (drawer.isOpen)
			{
				if (leftButton)
				{
					leftButton.style.left = String(drawer.width) + "px";
				}
			}																	
			else
			{
				if (leftButton)
				{
					leftButton.style.left = 0;
				}
			}*/
		}
	}
}