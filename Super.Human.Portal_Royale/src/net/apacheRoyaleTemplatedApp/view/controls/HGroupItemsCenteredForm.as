package view.controls
{
	import org.apache.royale.jewel.HGroup;

	public class HGroupItemsCenteredForm extends HGroup 
	{
		public function HGroupItemsCenteredForm()
		{
			super();
			
			itemsExpand = true;
			itemsVerticalAlign = "itemsCenter";
			itemsHorizontalAlign = "itemsCenter";
			gap = 2;
		}
	}
}