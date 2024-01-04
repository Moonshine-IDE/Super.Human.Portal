package model.proxy
{
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class ProxyTheme extends Proxy
	{
		public static const NAME:String = "ProxyTheme";

		public function ProxyTheme()
		{
			super(NAME);
		}
		
		private var _themeId:String;

		public function get themeId():String
		{
			return _themeId;
		}
		
		public function set themeId(value:String):void
		{
			if (_themeId != value)
			{
				_themeId = value;
			}
		}

		public function get theme():String
		{
			return String(this.getData());
		}

		public function set theme(value:String):void
		{
			if (String(this.getData()) != value)
			{
				this.setData(value);
			}
		}
	}
}