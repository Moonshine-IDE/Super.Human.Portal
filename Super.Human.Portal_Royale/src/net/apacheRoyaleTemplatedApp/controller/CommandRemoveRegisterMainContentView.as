package controller
{
	import interfaces.IMainContentView;

	import org.apache.royale.reflection.getDefinitionByName;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class CommandRemoveRegisterMainContentView extends SimpleCommand
	{
		override public function execute(note: INotification):void	
		{
			var viewClass:Class = getDefinitionByName(note.getType()) as Class;
			if (!facade.hasMediator(viewClass["NAME"]))
			{
				var mainView:IMainContentView = note.getBody().view as IMainContentView;
				
				facade.removeMediator(mainView.selectedContent);
				
				mainView.selectedContent = note.getBody().currentSelection;
				
				if (note.getType())
				{
					var view:Object = new viewClass(note.getBody().currentView);
					facade.registerMediator(view as IMediator);
				}
	
				var selectedItem:Object = mainView["viewDrawerNavigation"].dataProvider.source.filter(
					function(item:Object, index:int, arr:Array):Boolean {
						return item.idSelectedItem == mainView.selectedContent;
					});
					
				if (selectedItem.length == 0)
				{
					var selectedChild:Object = null;
					if (mainView.selectedNavigation)
					{
						selectedChild = mainView.selectedNavigation.selectedChild;
					}
						
					var proposedSelection:Object = setSelectedChild(mainView["viewDrawerNavigation"].dataProvider.source, mainView.selectedContent);
						
					if (proposedSelection == mainView.selectedNavigation &&
						(proposedSelection && selectedChild != proposedSelection.selectedChild))
					{
						//Need to reset selectedNavigation when we select child item within the same parent
						mainView.selectedNavigation = null;
					}
										
					mainView.selectedNavigation = proposedSelection;
				}	
				else 
				{
					mainView.selectedNavigation = selectedItem.pop();
				}						
			}
		}	
		
		private function setSelectedChild(source:Array, selectedContent:String, itemWithSubMenu:Object = null):Object
		{
			var selectedItem:Object = null;		
			for (var i:int = 0; i < source.length; i++)
			{
				var currentItem:Object = source[i];
				if (currentItem.subMenu)
				{
					selectedItem = setSelectedChild(currentItem.subMenu.source, selectedContent, itemWithSubMenu);
					if (selectedItem)
					{
						currentItem.selectedChild = selectedItem;
						itemWithSubMenu = currentItem;
						break;
					}
				}
				
				if (currentItem && currentItem.content == selectedContent)
				{
					itemWithSubMenu = currentItem;
					break;
				}
			}

			return itemWithSubMenu;
		}
	}
}