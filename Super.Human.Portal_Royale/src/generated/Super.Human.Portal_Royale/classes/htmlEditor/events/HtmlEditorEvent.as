package Super.Human.Portal_Royale.classes.htmlEditor.events
{
	import org.apache.royale.events.Event;

	public class HtmlEditorEvent extends Event
	{
		public static const TEXT_CHANGE:String = "textChange";
		
		public function HtmlEditorEvent(type:String, text:String)
		{
			super(type);
			
			_text = text;
		}
		
		private var _text:String;
		
		public function get text():String
		{
			return _text;
		}
	}
}