package view.controls
{
    import classes.models.CustomFormItemModel;

    import org.apache.royale.jewel.FormItem;

	public class CustomFormItem extends org.apache.royale.jewel.FormItem 
	{
		public function CustomFormItem()
		{
			super();
			
			model = new CustomFormItemModel();
		}
		
		[Bindable(event="change")]
		override public function get label():String
		{
			return model["text"];
		}
		
		override public function set label(value:String):void
		{
			model["text"] = value;
		}
		
		public function get labelClass():String
		{
			return model["labelClass"];
		}

		public function set labelClass(value:String):void
		{
			model["labelClass"] = value;
		}
		
		override public function get required():Boolean
		{
			return model["required"];
		}
		
		override public function set required(value:Boolean):void
		{
			model["required"] = value;
		}
		
		override public function get labelAlign():String
		{
			return model["labelAlign"];
		}
		
		override public function set labelAlign(value:String):void
		{
			model["labelAlign"] = value;
		}

		public function get fullContentWidth():Boolean
		{
			return model["fullContentWidth"];
		}

		public function set fullContentWidth(value:Boolean):void
		{
			model["fullContentWidth"] = value;
		}		
	}
}