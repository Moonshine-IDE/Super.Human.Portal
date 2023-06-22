package Super.Human.Portal_Royale.classes.htmlEditor
{
    import org.apache.royale.jewel.Group;
    import org.apache.royale.html.elements.Div;

    [Event(name="textChange", type="Super.Human.Portal_Royale.classes.htmlEditor.events.HtmlEditorEvent")]
	public class HtmlEditor extends Group
	{
		public function HtmlEditor():void
		{
			super();
			
			className = "htmlEditorJS";
		}

		public function get data():Object
		{
			return model["data"];
		}

		public function set data(value:Object):void
		{
			model["data"] = value;
		}
		
		public function get toolbarItems():Array
		{
			return model["toolbarItems"];
		}

		public function set toolbarItems(value:Array):void
		{
			model["toolbarItems"] = value;
		}
		
		public function get toolbarMultiline():Boolean
		{
			return model["toolbarMultiline"];
		}

		public function set toolbarMultiline(value:Boolean):void
		{
			model["toolbarMultiline"] = value;
		}
		
		public function get readOnly():Boolean
		{
			return model["readOnly"];
		}

		public function set readOnly(value:Boolean):void
		{
			model["readOnly"] = value;
		}
	}
}