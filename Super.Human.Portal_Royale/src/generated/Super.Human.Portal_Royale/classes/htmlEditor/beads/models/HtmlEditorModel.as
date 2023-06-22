package Super.Human.Portal_Royale.classes.htmlEditor.beads.models
{
    import Super.Human.Portal_Royale.classes.htmlEditor.helpers.ToolbarItems;
    import Super.Human.Portal_Royale.classes.htmlEditor.interfaces.IHtmlEditorModel;

    import org.apache.royale.core.DispatcherBead;

	public class HtmlEditorModel extends DispatcherBead implements IHtmlEditorModel
	{
		public function HtmlEditorModel()
		{
			super();
		}
		
		private var _data:Object;
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			if (_data != value)
			{
				_data = value;
				
				this.dispatchEvent(new Event("optionsChanged"));
			}
		}
		
		private var _toolbar:Object;
		
		public function get toolbar():Object
		{
			return _toolbar;
		}
		
		public function set toolbar(value:Object):void
		{
			if (_toolbar != value)
			{
				_toolbar = value;
				
				this.dispatchEvent(new Event("toolbarChanged"));
			}
		}
		
		private var _toolbarMultiline:Boolean = true;
		
		public function get toolbarMultiline():Boolean
		{
			return _toolbarMultiline;
		}
		
		public function set toolbarMultiline(value:Boolean):void
		{
			if (_toolbarMultiline != value)
			{
				_toolbarMultiline = value;
				
				this.dispatchEvent(new Event("toolbarChanged"));
			}
		}
		
		private var _toolbarItems:Array = ToolbarItems.ALL_ITEMS;
		
		public function get toolbarItems():Array
		{
			return _toolbarItems;
		}
		
		public function set toolbarItems(value:Array):void
		{
			if (_toolbarItems != value)
			{
				_toolbarItems = value;
				
				this.dispatchEvent(new Event("toolbarChanged"));
			}
		}
		
		private var _readOnly:Boolean;

		public function get readOnly():Boolean
		{
			return _readOnly;
		}

		public function set readOnly(value:Boolean):void
		{
			if (_readOnly != value)
			{
				_readOnly = value;
				
				this.dispatchEvent(new Event("optionsChanged"));
			}
		}
	}
}