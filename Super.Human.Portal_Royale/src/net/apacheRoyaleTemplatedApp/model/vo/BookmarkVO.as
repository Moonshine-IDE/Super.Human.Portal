package model.vo
{
	[Bindable]
	public class BookmarkVO  
	{
		public var group:String;
		public var dominoUniversalID:String;
		public var name:String;
		public var server:String;
		public var database:String;
		public var view:String;
		public var type:String;
		public var url:String;
		public var nomadURL:String
		public var description:String;
      
		public function BookmarkVO(group:String = "", dominoUniversalID:String = "", name:String = "", 
										server:String = "", database:String = "", view:String = "",
										type:String = "", url:String = "", nomadUrl:String = "", description:String = "")
		{
			this.group = group;
			this.dominoUniversalID = dominoUniversalID;
			this.name = name;
			this.server = server;
			this.database = database;
			this.view = view;
			this.type = type;
			this.url = url;
			this.nomadURL = nomadURL;
			this.description = description;
		}
	}
}