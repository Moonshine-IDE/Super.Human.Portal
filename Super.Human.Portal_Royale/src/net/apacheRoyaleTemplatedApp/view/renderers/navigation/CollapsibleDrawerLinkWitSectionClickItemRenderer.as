package view.renderers.navigation
{
    import org.apache.royale.jewel.Navigation;

    import view.renderers.navigation.CollapsibleDrawerLinkItemRenderer;
    import org.apache.royale.events.Event;

	public class CollapsibleDrawerLinkWitSectionClickItemRenderer extends CollapsibleDrawerLinkItemRenderer 
	{
		public function CollapsibleDrawerLinkWitSectionClickItemRenderer()
		{
			super();
		}
		
		override protected function onRendererSectionClick(event:Event):void
		{
			super.onRendererSectionClick(event);
			
			var parentNav:Navigation = this.itemRendererOwnerView ? this.itemRendererOwnerView.host as Navigation : null;
			if (parentNav) 
			{
				data.selectedChild = null;
				parentNav.selectedItem = this.data;
				
				parentNav.dispatchEvent(new Event("sectionChange"));
			}
		}
	}
}