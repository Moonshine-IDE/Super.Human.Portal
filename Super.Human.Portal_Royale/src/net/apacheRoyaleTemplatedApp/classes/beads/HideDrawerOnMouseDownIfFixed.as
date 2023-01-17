package classes.beads
{
    import org.apache.royale.jewel.beads.controls.drawer.HideDrawerOnMouseDown;
    import org.apache.royale.events.MouseEvent;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.jewel.Drawer;

	public class HideDrawerOnMouseDownIfFixed extends HideDrawerOnMouseDown 
	{
		public function HideDrawerOnMouseDownIfFixed()
		{
			super();
		}
		
		private var _drawer:Drawer;
		
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			_drawer = value as Drawer;	
		}		
		
		override protected function handleTopMostEventDispatcherMouseDown(event:MouseEvent):void
		{
			if (_drawer && !_drawer.fixed)
			{
				_drawer.close();
			}
		}
	}
}