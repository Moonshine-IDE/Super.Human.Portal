package model.vo
{
	[Bindable]
	public class TileViewVO  
	{
		public var title:String;
		public var description:String;
		public var link:String;
		public var imageIcon:String;
		public var widthRatio:Number;
	
		private var _id:String;

		public function get id():String
		{
			return _id;
		}
			
		public function TileViewVO(id:String = "", title:String = "", description:String = "", link:String = null, imageIcon:String = null, widthRatio:Number = 1)
		{
			this._id = id;
			this.title = title;
			this.description = description;
			this.link = link;
			this.imageIcon = imageIcon;
			this.widthRatio = widthRatio;
		}
	}
}