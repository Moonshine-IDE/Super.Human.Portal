package view.controls
{
	import org.apache.royale.jewel.HGroup;

	public class HGroupItemsCenterExpandForm extends HGroup 
	{
		public function HGroupItemsCenterExpandForm()
		{
			super();
			
			itemsVerticalAlign = "itemsCenter";
			itemsExpand = true;
			gap = 2;
		}
	}
}