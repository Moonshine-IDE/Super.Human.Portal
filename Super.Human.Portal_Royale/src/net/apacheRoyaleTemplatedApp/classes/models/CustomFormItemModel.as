package classes.models
{
	import org.apache.royale.jewel.beads.models.FormItemModel;

	public class CustomFormItemModel extends org.apache.royale.jewel.beads.models.FormItemModel 
	{
		public function CustomFormItemModel()
		{
			super();
		}
		
		private var _labelClass:String = "formlabel";

		public function get labelClass():String
		{
			return _labelClass;
		}

		public function set labelClass(value:String):void
		{
			_labelClass = value;
		}
		
		private var _fullContentWidth:Boolean;

		public function get fullContentWidth():Boolean
		{
			return _fullContentWidth;
		}

		public function set fullContentWidth(value:Boolean):void
		{
			_fullContentWidth = value;
		}
	}
}