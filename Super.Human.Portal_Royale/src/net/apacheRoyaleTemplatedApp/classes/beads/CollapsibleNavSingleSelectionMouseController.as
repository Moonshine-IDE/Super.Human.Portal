package classes.beads
{
    import org.apache.royale.core.IItemRendererOwnerView;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IStrandWithModelView;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.html.beads.IListView;
    import org.apache.royale.jewel.beads.controllers.ListSingleSelectionMouseController;
    import org.apache.royale.jewel.beads.models.IJewelSelectionModel;

    import view.renderers.navigation.CollapsibleDrawerLinkItemRenderer;
                                
	public class CollapsibleNavSingleSelectionMouseController extends ListSingleSelectionMouseController 
	{
		public function CollapsibleNavSingleSelectionMouseController()
		{
			super();
		}
		
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
			if (listModel is IJewelSelectionModel && !(IJewelSelectionModel(listModel).hasDispatcher)) 
			{
                 
			}
            else 
            {			
				IEventDispatcher(listModel).addEventListener('selectionChanged', onSelectionChanged);
            }
		}
		
		private function onSelectionChanged(event:Event):void
		{
			var view:IListView = (_strand as IStrandWithModelView).view as IListView;
			var dataGroup:IItemRendererOwnerView = view.dataGroup;
			
			var ir:Object = null;
			var selectedSubMenu:Object = null;
			
			var n:int = dataGroup.numItemRenderers;
			var selectedItem:Object = view.host["selectedItem"];

			if (selectedItem)
			{
				for (var i:int = 0; i < n; i++)
				{
					ir = dataGroup.getItemRendererAt(i);
	
					selectedSubMenu = ir.getSelectedSubmenuItem();
					if (selectedSubMenu && selectedItem != ir.data)
					{
						ir.unsetSelectedSubmenuItem();
					}
					
					if (selectedItem == ir.data && selectedItem.subMenu)
					{
						ir.open = true;	
						ir.childNavigation.selectedItem = selectedItem.selectedChild;
					}			
				}
			}
			else
			{
				for (var j:int = 0; j < n; j++)
				{
					ir = dataGroup.getItemRendererAt(j);
	
					selectedSubMenu = ir.getSelectedSubmenuItem();
					if (selectedSubMenu && selectedItem != ir.data)
					{
						ir.unsetSelectedSubmenuItem();
					}		
				}
			}
		}
	}
}