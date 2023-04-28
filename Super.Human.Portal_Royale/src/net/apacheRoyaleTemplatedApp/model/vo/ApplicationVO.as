package model.vo
{
	public class ApplicationVO 
	{
		public static const LINK_BROWSER:String = "browser";
		public static const LINK_DATABASE:String = "database";
		
		public function ApplicationVO(appId:String, detailsUrl:String, label:String, installCommand:String, installed:Boolean, access:Object = null) 
		{
			this._appId = appId;
			this._detailsUrl = detailsUrl;
			this._label = label;
			this._installCommand = installCommand;
			this._installed = installed;
			this._access = access;
		}
		
		
		// ---------------------------------------
		// GET / SET
		// ---------------------------------------
		
				
		private var _appId:String;
		public function set appId(value:String):void 
		{
			_appId = value;
		}
		
		public function get appId():String 
		{
			return _appId;
		}
		
		private var _detailsUrl:String;
		public function set detailsUrl(value:String):void 
		{
			_detailsUrl = value;
		}
		
		public function get detailsUrl():String 
		{
			return _detailsUrl;
		}
		
		private var _label:String;
		public function set label(value:String):void 
		{
			_label = value;
		}
		
		public function get label():String
		{
			return _label;
		}
		
		private var _installCommand:String;
		public function set installCommand(value:String):void 
		{
			_installCommand = value;
		}
		
		public function get installCommand():String
		{
			return _installCommand;
		}
		
		private var _installed:Boolean;
		public function set installed(value:Boolean):void 
		{
			_installed = value;
		}
		
		public function get installed():Boolean
		{
			return _installed;
		}
		
		private var _access:Object;

		public function get access():Object
		{
			return _access;
		}

		public function set access(value:Object):void
		{
			_access = value;
		}
	}
}