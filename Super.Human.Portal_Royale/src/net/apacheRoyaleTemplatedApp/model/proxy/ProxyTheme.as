package model.proxy
{
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import constants.Theme;
	
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
			var currentTheme:String = window["Cookies"].get("MyAccountTheme");
			var currentThemeId:String = window["Cookies"].get("MyAccountThemeId");
			
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
					window["Cookies"].set("MyAccountTheme", theme);
					window["Cookies"].set("MyAccountThemeId", themeId);
					
					this.setData({theme: theme, themeId: themeId});
					break;
				}
			}
		}
	}
}