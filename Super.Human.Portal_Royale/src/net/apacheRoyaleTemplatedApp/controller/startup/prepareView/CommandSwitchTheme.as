package controller.startup.prepareView
{
	import constants.Theme;

	import model.proxy.ProxyTheme;

	import org.apache.royale.utils.css.loadCSS;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
			
	public class CommandSwitchTheme extends SimpleCommand
	{
		override public function execute(note:INotification):void	
		{
			var theme:String = String(note.getBody());
			var themeProxy:ProxyTheme = facade.retrieveProxy(ProxyTheme.NAME) as ProxyTheme;
			
			var themeId:* = document.getElementById(themeProxy.themeId);
			if (themeId)
			{
				document.head.removeChild(themeId);
			}
			
			switch (theme)
			{
				case Theme.DARK:
					themeProxy.themeId = loadCSS("resources/themes/" + Theme.DARK + "/defaults.css");
					themeProxy.theme = Theme.DARK;
					break;
				default:
					themeProxy.themeId = loadCSS("resources/themes/" + Theme.LIGHT + "/defaults.css");
					themeProxy.theme = Theme.LIGHT;
					break;
			}
		}		
	}
}