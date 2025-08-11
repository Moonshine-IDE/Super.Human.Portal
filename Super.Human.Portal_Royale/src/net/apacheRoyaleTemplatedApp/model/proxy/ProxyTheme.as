package model.proxy
{
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import constants.Theme;
	import constants.ApplicationConstants;
	
	public class ProxyTheme extends Proxy
	{
		public static const NAME:String = "ProxyTheme";

		public function ProxyTheme()
		{
			super(NAME);
			
			this.setData({theme: Theme.LIGHT});
		}

		public function getTheme():Object
		{
			var currentTheme:String = window["Cookies"].get("SuperHumanPortalTheme");
			var currentThemeId:String = window["Cookies"].get("SuperHumanPortalThemeId");
			
			for (var t:String in Theme)
			{
				if (Theme[t] == currentTheme)
				{
					return {theme: currentTheme, themeId: currentThemeId};
				}
			}
			
			return this.getData();
		}
		
		public function setTheme(theme:String, themeId:String):void
		{
			for (var t:String in Theme)
			{
				if (Theme[t] == theme)
				{
					window["Cookies"].set("SuperHumanPortalTheme", theme, { sameSite: 'strict' });
					window["Cookies"].set("SuperHumanPortalThemeId", themeId, { sameSite: 'strict' });
					
					this.setData({theme: theme, themeId: themeId});

					this.sendNotification(ApplicationConstants.NOTE_THEME_CHANGED, this.getData());
					break;
				}
			}
		}
	}
}