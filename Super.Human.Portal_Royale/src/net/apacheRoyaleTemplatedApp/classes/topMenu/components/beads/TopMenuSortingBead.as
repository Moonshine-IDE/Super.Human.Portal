package classes.topMenu.components.beads
{
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IStrand;
    import classes.topMenu.model.TopMenuVO;
    import org.apache.royale.core.Bead;

	public class TopMenuSortingBead extends Bead
	{
		public function TopMenuSortingBead()
		{
			super();
		}
		
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
		}
		
		public function eq(a:TopMenuVO, b:TopMenuVO):int 
		{
			// Nodes with children come first
			if (a.children.length > 0 && b.children.length == 0) return -1;
			if (a.children.length == 0 && b.children.length > 0) return 1;
	
			// Then sort by label
			if (a.label < b.label) return -1;
			if (a.label > b.label) return 1;
			return 0;
		}
		
		public function sortMenu(menu:Array):void
		{
			if (menu && menu.length > 0)
			{
				menu.sort(eq);
			}
		}
	}
}