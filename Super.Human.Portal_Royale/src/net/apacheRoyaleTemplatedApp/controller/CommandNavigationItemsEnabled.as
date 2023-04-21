package controller
{
	import mediator.MediatorMainContentView;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import model.InstalledAppNavigationModel;

	public class CommandNavigationItemsEnabled extends SimpleCommand
	{
		override public function execute(note:INotification):void 
		{	
			var mainMediator:MediatorMainContentView = facade.retrieveMediator(MediatorMainContentView.NAME) as MediatorMainContentView;
			
			var mainModel:InstalledAppNavigationModel = mainMediator.view["model"] as InstalledAppNavigationModel;

			var itemsCount:int = mainModel.navigationLinks.length;
			for (var i:int = 0; i < itemsCount; i++)
			{
				var item:Object = mainModel.navigationLinks.getItemAt(i) as Object;
				item.enabled = Boolean(note.getBody());
			}
		}
	}
}