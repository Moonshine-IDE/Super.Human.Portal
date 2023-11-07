package classes.topMenu.helpers
{
	import classes.topMenu.classes.TopMenuItemConst;
	import classes.topMenu.model.TopMenuVO;

	public class TopMenuUtils
	{
		public static function transformObjectToMenuVOItems(data:Object, model:Object):TopMenuVO
		{
			var itemVO:TopMenuVO = new TopMenuVO();
			for (var key:String in data)
			{
				itemVO[key] = data[key];
			}
			
			model[itemVO.id] = itemVO;
			
			if (data && data.children)
			{
				for (var i:int = 0; i < data.children.length; i++) 
				{
					transformObjectToMenuVOItems(model[data.children[i]], model);
				}
			}
			
			return itemVO;
		}

    		public static function recalculateVisited(item:TopMenuVO, model:Object):void
    		{
    			if (!item.hasChildren())
    			{
    				item.visited = TopMenuItemConst.VISITED;
    				item.calculateVisitedIcon();
    				
    				if (item.parent)
    				{
    					recalculateVisited(model[item.parent], model);
				}
    			}
    			else
    			{
    				var areAllChildrenNotVisited:Boolean = item.children.every(function(childId:String, index:int, arr:Array):Boolean {
						return model[childId].visited == TopMenuItemConst.NOT_VISITED;
					});
					
				var areAllChildrenVisited:Boolean = item.children.every(function(childId:String, index:int, arr:Array):Boolean {
					return model[childId].visited == TopMenuItemConst.VISITED;
				});
				
				if (areAllChildrenNotVisited)
				{
					item.visited = TopMenuItemConst.NOT_VISITED;
					return;
				}
				else if (areAllChildrenVisited)
				{
					item.visited = TopMenuItemConst.VISITED;
					item.calculateVisitedIcon();
					if (item.parent)
					{
						recalculateVisited(model[item.parent], model);
					}
				}
				else
				{
					item.visited = TopMenuItemConst.PARTIALLY_VISITED;
					item.calculateVisitedIcon();
					if (item.parent)
					{
						recalculateVisited(model[item.parent], model);
					}
				}
    			}
    		}
  
    		public static function recalculateMarkedMenu(showMarks:Boolean, model:Object, item:Object):void
    		{
			resetShowMarks(showMarks, item as TopMenuVO);
    			if (item && item.children && item.children.length > 0)
			{
				for (var i:int = 0; i < item.children.length; i++) 
				{
					var child:TopMenuVO = model[item.children[i]];
					recalculateMarkedMenu(showMarks, model, child);
				}
			}
    		}
    		
    		public static function recalculateFolderStyleMenu(showFolder:Boolean, model:Object, item:Object):void
    		{
    			if (!showFolder) return;
    			
			resetShowFolder(showFolder, item as TopMenuVO);
    			if (item && item.children && item.children.length > 0)
			{
				for (var i:int = 0; i < item.children.length; i++) 
				{
					var child:TopMenuVO = model[item.children[i]];
					recalculateFolderStyleMenu(showFolder, model, child);
				}
			}
    		}
    			
		public static function getPathToTarget(targetId:String, source:Object):Array
		{
			var path:Array = [];
			do 
			{
				var target:Object = source[targetId];
					path.push(target);
					
				targetId = target.parent;
				
			} while (targetId != null) 
			
			return path;
		}
		
		public static function getSiblings(targetId:String, source:Object):Array
		{
			if (!source[targetId]) return [];
			
			var parentId:String = source[targetId].parent;
			if (parentId == null)
			{
				return getChildren("menu", source);
			}
			
			return getChildren(parentId, source);
		}
		
		public static function getChildren(targetId:String, source:Object):Array
		{
			var items:Array = [];
			if (targetId != null)
			{
				var target:Object = source[targetId];
				var children:Array = target.children;
				
				for (var i:int = 0; i < children.length; i++) 
				{
					var item:Object = source[children[i]];
					items.push(item);
				}
			}
			
			return items;
		}

    		private static function resetShowMarks(showMarks:Boolean, item:TopMenuVO):void
    		{
    			if (!item) return;
    			
			item.visited = showMarks ? TopMenuItemConst.NOT_VISITED : TopMenuItemConst.VISITED_DISABLED;
			item.calculateVisitedIcon();
    		}
    		
    		private static function resetShowFolder(showFolder:Boolean, item:TopMenuVO):void
    		{
    			if (!item) return;
    			
			if (showFolder)
			{
				item.calculateFolderIcon();
			}
    		}
	}
}