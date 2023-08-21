package classes.beads
{
    import org.apache.royale.core.IStrand;
    import org.apache.royale.jewel.Navigation;
                                
	public class CollapsibleNavSingleSelectionWithSectionClickMouseController extends CollapsibleNavSingleSelectionMouseController 
	{
		public function CollapsibleNavSingleSelectionWithSectionClickMouseController()
		{
			super();
		}
		
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
			(value as Navigation).addEventListener("sectionChange", onSelectionChanged);
		}
	}
}