package view.controls
{
	import org.apache.royale.jewel.HGroup;

	public class HGroupItemsCenterNonExpandForm extends HGroup 
	{
		public function HGroupItemsCenterNonExpandForm()
		{
			super();
			
			itemsVerticalAlign = "itemsCenter";
			itemsExpand = false;
			gap = 2;
		}
	}
}