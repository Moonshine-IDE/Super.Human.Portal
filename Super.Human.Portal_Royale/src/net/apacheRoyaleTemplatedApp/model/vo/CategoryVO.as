package model.vo
{
	public class CategoryVO  
	{
		public var dominoUniversalID:String;
		public var categoryID:String;
		[Bindable]
		public var description:String;
		public var order:Number;
		[Bindable]
		public var label:String;
		[Bindable]
		public var icon:String;
		
		[Bindable]
		public var link:String;
		
		private var _id:String;

		public function get id():String
		{
			return categoryID;
		}

		public function CategoryVO(dominoUniversalID:String = "", categoryID:String = "", description:String = "",
								  order:Number = 0, label:String = "", icon:String = "", link:String = "")
		{
			this.dominoUniversalID = dominoUniversalID;
			this.categoryID = categoryID;
			this.description = description;
			this.order = order;
			this.label = label;
			this.icon = icon;
			this.link = link;
		}
		
		public function toRequestObject():Object
		{
			return {
				DominoUniversalID: this.dominoUniversalID,
				CategoryID: this.categoryID,
				Description: this.description,
      			Order: this.order,
      			Label: this.label,
      			Icon: this.icon
			}
		}
	}
}