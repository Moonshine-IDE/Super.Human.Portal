package controller
{
	import constants.ApplicationConstants;
	
	import interfaces.IDisposable;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class CommandProxyManager extends SimpleCommand
	{
		private static var selectedRootSectionProxies:Array = [];
		private static var visitedRootSectionProxies:Array = [];
		
		override public function execute(note:INotification):void 
		{	
			var proxyName:String = note.getBody() as String;
			
			switch (note.getName())
			{
				case ApplicationConstants.COMMAND_DRAWER_CHANGED:
					disposeSelectedRootSectionProxies(note.getBody());
					break;
				case ApplicationConstants.COMMAND_ADD_PROXY_FOR_DATA_DISPOSE:
					addProxy(proxyName);
					break;
				case ApplicationConstants.COMMAND_REMOVE_PROXY_DATA:
					removeProxy(proxyName);
					break;
			}
		}
		
		private function disposeSelectedRootSectionProxies(force:Boolean):void
		{
			selectedRootSectionProxies.forEach(function(name:String, index:int, arr:Array):void
			{
				disposeProxy(name, force);
				if (!force)
				{
					storeVisitedProxy(name);
				}
				else
				{
					var visitedIndex:int =  visitedRootSectionProxies.indexOf(name);
					if (visitedIndex != -1)
					{
						visitedRootSectionProxies.removeAt(visitedIndex);
					}
				}
			});
			
			selectedRootSectionProxies = [];
			
			if (force)
			{
				disposeVisitedRootSectionProxies(force); 
			}
		}
		
		private function disposeVisitedRootSectionProxies(force:Boolean):void
		{
			visitedRootSectionProxies.forEach(function(name:String, index:int, arr:Array):void
			{
				disposeProxy(name, force);
			});
			
			visitedRootSectionProxies = [];
		}
		
		private function addProxy(name:String):void
		{
			if (selectedRootSectionProxies.indexOf(name) == -1)
			{
				selectedRootSectionProxies.push(name);
			}
		}
		
		private function storeVisitedProxy(name:String):void
		{
			if (visitedRootSectionProxies.indexOf(name) == -1)
			{
				visitedRootSectionProxies.push(name);
			}
		}
		
		private function removeProxy(name:String):void
		{
			selectedRootSectionProxies.some(function(proxyName:String, index:int, arr:Array):Boolean
			{
				if (!name || (proxyName == name))
				{
					disposeProxy(proxyName);
					storeVisitedProxy(proxyName);
					selectedRootSectionProxies.removeAt(index);
					return true;
				}
				return false;
			});
		}
		
		private function disposeProxy(name:String, force:Boolean=false):void
		{
			var preservableProxy:IDisposable = facade.retrieveProxy(name) as IDisposable;
			if (preservableProxy)
			{
				preservableProxy.dispose(force);
			}
		}
	}
}