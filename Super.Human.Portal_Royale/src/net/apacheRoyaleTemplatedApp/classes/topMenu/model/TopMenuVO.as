package classes.topMenu.model
{
	import classes.topMenu.classes.TopMenuItemConst;

	public dynamic class TopMenuVO  
	{
		public var id:String; 
		public var hash:String; 
		public var parent:String = null;
		public var children:Array = [];
		public var visited:int = 0;
		
		[Bindable]
		public var label:String;
		[Bindable]
		public var icon:String = TopMenuItemConst.NOT_VISITED_ICON;
		
		public var data:Object;
		
		public function hasChildren():Boolean
		{
			return children != null && children.length > 0;
		}
		
		public function calculateVisitedIcon():void
		{
			switch(visited)
			{
				case TopMenuItemConst.VISITED:
					icon = TopMenuItemConst.VISITED_ICON;
					break;
				case TopMenuItemConst.PARTIALLY_VISITED:
					icon = TopMenuItemConst.PARTIALLY_VISITED_ICON;
					break;
				case TopMenuItemConst.NOT_VISITED: 
					icon = TopMenuItemConst.NOT_VISITED_ICON;
					break;
				case TopMenuItemConst.VISITED_DISABLED:
					icon = null;
					break;
			}
		}
	}
}