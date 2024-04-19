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
			var themeProxy:ProxyTheme = facade.retrieveProxy(ProxyTheme.NAME) as ProxyTheme;	
			var currentTheme:Object = themeProxy.getTheme();
	
			var themeId:* = document.getElementById(currentTheme.themeId);
			if (themeId)
			{
				document.head.removeChild(themeId);
			}
		
			var theme:Object = note.getBody();
			if (!theme)
			{
				theme = currentTheme.theme;
			}
			
			switch (theme)
			{
				case Theme.DARK:
					themeId = loadCSS("resources/themes/" + Theme.DARK + "/defaults.css");
					window["DevExpress"].ui.themes.current("generic." + Theme.DARK);
					themeProxy.setTheme(Theme.DARK, themeId);
					break;
				default:
					themeId = loadCSS("resources/themes/" + Theme.LIGHT + "/defaults.css");
					window["DevExpress"].ui.themes.current("generic." + Theme.LIGHT);
					themeProxy.setTheme(Theme.LIGHT, themeId);
					break;
			}
		}		
	}
}