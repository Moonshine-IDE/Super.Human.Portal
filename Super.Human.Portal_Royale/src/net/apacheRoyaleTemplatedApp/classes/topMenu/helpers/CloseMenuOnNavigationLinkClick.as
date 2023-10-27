package classes.topMenu.helpers
{
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.events.Event;
    import org.apache.royale.jewel.Drawer;
    import org.apache.royale.jewel.Navigation;
    import org.apache.royale.jewel.supportClasses.drawer.DrawerContent;

	public class CloseMenuOnNavigationLinkClick  implements IBead
	{
		private var host:Drawer;
		
		public function set strand(value:IStrand):void
		{
			host = value as Drawer;
			
			if (host)
            {
				host.addEventListener("initComplete", onDrawerInitComplete);			
            }	
		}

		private function onDrawerInitComplete(event:Event):void
		{
			host.removeEventListener("initComplete", onDrawerInitComplete);
			
			if (host.strandChildren)
            {
                var drawerChildrenCount:int = host.numElements;
                for (var i:int = 0; i < drawerChildrenCount; i++)
                {
                    var drawerContent:DrawerContent = host.getElementAt(i) as DrawerContent;
					if (drawerContent)
					{
						var contentCount:int = drawerContent.numElements;
						for (var j:int = 0; j < contentCount; j++)
						{						
							var navigation:Navigation = drawerContent.getElementAt(j) as Navigation;
			                if (navigation)
		                    {
		                        navigation.addEventListener("change", onNavigationChange);
								break;
		                    }
						}	
                    }					
				}
			}
		}
		
		private function onNavigationChange(event:Object):void
		{
			if (!host.fixed)
			{
				host.close();
			}
		}
	}
}