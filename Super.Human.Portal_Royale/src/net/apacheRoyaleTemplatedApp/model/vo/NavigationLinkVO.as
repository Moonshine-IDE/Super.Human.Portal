package model.vo 
{
	import org.apache.royale.collections.IArrayList;

	public class NavigationLinkVO
	{
		public function NavigationLinkVO(name:String, notificationName:String, icon:String, idSelectedItem:String) 
		{
			this.name = name;
			this.notificationName = notificationName;
			this.icon = icon;
			this._idSelectedItem = idSelectedItem;
		}
		
		 //for collapsible example
        private var _subMenu:IArrayList;

		[Bindable]
        public function get subMenu():IArrayList
        {
        		return _subMenu;
        }

        public function set subMenu(value:IArrayList):void
        {
        		_subMenu = value;
        }
        
        private var _open:Boolean;
		
		[Bindable]
        public function get open():Boolean
        {
        		return _open;
        }

        public function set open(value:Boolean):void
        {
        		_open = value;
        }
        
        private var _selectedChild:NavigationLinkVO;
		
		[Bindable]
        public function get selectedChild():NavigationLinkVO
        {
        		return _selectedChild;
        }

        public function set selectedChild(value:NavigationLinkVO):void
        {
        		_selectedChild = value;
        }
		
		private var _name:String;
		
		[Bindable]
		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}
		
		private var _notificationName:String;
		
		[Bindable]
		public function get notificationName():String
		{
			return _notificationName;
		}

		public function set notificationName(value:String):void
		{
			_notificationName = value;
		}
		
		private var _icon:String;
		
		[Bindable]
		public function get icon():String
		{
			return _icon;
		}

		public function set icon(value:String):void
		{
			_icon = value;
		}
		
		private var _visible:Boolean = true;
		
		[Bindable]
		public function get visible():Boolean
		{
			return _visible;
		}

		public function set visible(value:Boolean):void
		{
			_visible = value;
		}
		
		private var _enabled:Boolean = true;
		
		[Bindable]
		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			if (_enabled != value)
			{
				_enabled = value;
			}
		}
		
		private var _idSelectedItem:String;
		
		public function get idSelectedItem():String
		{
			return _idSelectedItem;
		}
		
		private var _content:String;

		public function get content():String
		{
			return _content;
		}

		public function set content(value:String):void
		{
			_content = value;
		}
		
	}
}