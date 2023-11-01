package model.vo
{
	[Bindable]
	public class ServerVO  
	{
		public var name:String;
        public var type:String;
        public var url:String;
        public var nomadURL:String;
        public var server:String;
        public var view:String;
        public var replicaID:String;
        public var hasBookmarks:Boolean;
        public var bookmarkCount:int;
        public var bookmarks:Array;
        
        public var databasePath:Array = [];
        public var databaseName:String;
        
		public function ServerVO(name:String = "", type:String = "", url:String = "", nomadURL:String = "", 
								server:String = "", database:String = "", view:String = "",
								replicaID:String = "", hasBookmarks:Boolean = false, bookmarkCount:int = 0, bookmarks:Array = null)
		{
			this.name = name;
			this.type = type;
			this.url = url;
			this.nomadURL = nomadURL;
			this.server = server;
			this.database = database;
			this.view = view;
			this.replicaID = replicaID;
			this.hasBookmarks = hasBookmarks;
			this.bookmarkCount = bookmarkCount;
			this.bookmarks = bookmarks ? bookmarks : [];
		}
		
        private var _database:String;

        public function get database():String
        {
        		return _database;
        }

        public function set database(value:String):void
        {
        		if (_database != value)
        		{
        			_database = value;
        			
        			if (value)
        			{
        				this.databasePath = value.split("/");
        				if (this.databasePath && this.databasePath.length > 0)
        				{
        					databaseName = this.databasePath[this.databasePath.length - 1];
        				}
        			}
    			}
        }
        
		public function toRequestObject():Object
		{
			return {
				name: this.name,
				type: this.type,
				url: this.url,
				nomadURL: this.nomadURL,
				server: this.server,
				database: this.database,
				view: this.view,
				replicaID: this.replicaID,
				hasBookmarks: this.hasBookmarks,
				bookmarkCount: this.bookmarkCount
			}
		}
	}
}