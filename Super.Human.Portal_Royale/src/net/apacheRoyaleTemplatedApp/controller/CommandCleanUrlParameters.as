package controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class CommandCleanUrlParameters extends SimpleCommand
	{
		override public function execute(note:INotification):void 
		{
			//get full URL
		    var currURL:String = window.location.href; //get current address
			var paramIndex:int = currURL.indexOf("?");
			var noParamsUrl:String = null;
			if (paramIndex != -1)
			{
			    noParamsUrl = currURL.split("?")[0];  
			}
			
			if (noParamsUrl)
			{
				window.history.replaceState({}, document.title, noParamsUrl);
			}
		}
	}
}