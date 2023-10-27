package classes.breadcrump.helpers
{
	public class BreadcrumpUtils
	{
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
	}
}