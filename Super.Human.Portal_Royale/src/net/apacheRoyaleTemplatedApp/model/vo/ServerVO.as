package model.vo
{
	[Bindable]
	public class ServerVO  
	{
		public var name:String;
        public var type:String;
        public var url:String;
        public var nomadURL:String;
        public var database:String;
        public var view:String;
        public var replicaID:String;
        public var hasBookmarks:Boolean;
        public var bookmarkCount:int;
      	
        public var serverPath:Array = [];
        public var databaseName:String;
        
		public function ServerVO(name:String = "", type:String = "", url:String = "", nomadURL:String = "", 
								server:String = "", database:String = "", view:String = "",
								replicaID:String = "", hasBookmarks:Boolean = false, bookmarkCount:int = 0)
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
		}
		
        private var _server:String;

        public function get server():String
        {
        		return _server;
        }

        public function set server(value:String):void
        {
        		if (_server != value)
        		{
        			_server = value;
        			
        			if (value)
        			{
        				serverPath = value.split("/");
        				if (serverPath && serverPath.length > 0)
        				{
        					databaseName = serverPath[serverPath.length - 1];
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