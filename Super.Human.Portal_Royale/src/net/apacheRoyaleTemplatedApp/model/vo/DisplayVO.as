package model.vo
{
	[Bindable]
	public dynamic class DisplayVO  
	{
		private var _additionalGenesis:Boolean;

		public function get additionalGenesis():Boolean
		{
			return _additionalGenesis;
		}

		public function set additionalGenesis(value:Boolean):void
		{
			_additionalGenesis = value;
		}
		
		private var _browseMyServer:Boolean;

		public function get browseMyServer():Boolean
		{
			return _browseMyServer;
		}

		public function set browseMyServer(value:Boolean):void
		{
			_browseMyServer = value;
		}
		
		private var _documentation:Boolean;

		public function get documentation():Boolean
		{
			return _documentation;
		}

		public function set documentation(value:Boolean):void
		{
			_documentation = value;
		}
		
		private var _installApps:Boolean;

		public function get installApps():Boolean
		{
			return _installApps;
		}

		public function set installApps(value:Boolean):void
		{
			_installApps = value;
		}
		
		private var _manageBookmarks:Boolean;

		public function get manageBookmarks():Boolean
		{
			return _manageBookmarks;
		}

		public function set manageBookmarks(value:Boolean):void
		{
			_manageBookmarks = value;
		}
		
		private var _viewBookmarks:Boolean;

		public function get viewBookmarks():Boolean
		{
			return _viewBookmarks;
		}

		public function set viewBookmarks(value:Boolean):void
		{
			_viewBookmarks = value;
		}
		
		private var _viewInstalledApps:Boolean;

		public function get viewInstalledApps():Boolean
		{
			return _viewInstalledApps;
		}

		public function set viewInstalledApps(value:Boolean):void
		{
			_viewInstalledApps = value;
		}
	}
}