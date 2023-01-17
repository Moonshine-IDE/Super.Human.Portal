package controller
{
	import mediator.MediatorMainContentView;

	import model.MainContentNavigationModel;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class CommandNavigationItemsEnabled extends SimpleCommand
	{
		override public function execute(note:INotification):void 
		{	
			var mainMediator:MediatorMainContentView = facade.retrieveMediator(MediatorMainContentView.NAME) as MediatorMainContentView;
			
			var mainModel:MainContentNavigationModel = mainMediator.view["model"] as MainContentNavigationModel;

			var itemsCount:int = mainModel.navigationLinks.length;
			for (var i:int = 0; i < itemsCount; i++)
			{
				var item:Object = mainModel.navigationLinks.getItemAt(i) as Object;
				item.enabled = Boolean(note.getBody());
			}
		}
	}
}