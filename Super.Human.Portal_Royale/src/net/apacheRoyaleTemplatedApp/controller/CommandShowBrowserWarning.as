package controller
{
	import org.apache.royale.jewel.Snackbar;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
		
	public class CommandShowBrowserWarning extends SimpleCommand
	{
		override public function execute(note:INotification):void 
		{
			var showBrowserWarning:Boolean = Boolean(window["Cookies"].get("SuperHumanPortalBrowserWarning"));
			if (!showBrowserWarning)
			{
				window["Cookies"].set("SuperHumanPortalBrowserWarning", true, { sameSite: 'strict' });
				
				var uaParser:Object = new window["UAParser"]();
				var browser:Object = uaParser.getBrowser();
				
				if (browser.name != "Firefox")
				{
					var browserSnackbar:Snackbar = Snackbar.show("It appears you are currently using a browser other than Firefox. For the optimum experience and full compatibility with all the features of our app, we highly recommend using Firefox.",
																0, "Close");
				}
			}
		}
	}
}