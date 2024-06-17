package Super.Human.Portal_Royale.views.modules.DocumentationForm.DocumentationFormVO
{
    [Bindable]
	public class DocumentationFormVO  
	{
	    public var DominoUniversalID:String;

	    		private var _DocumentationName:String;
		public function get DocumentationName():String
		{
				return _DocumentationName;
		}
		public function set DocumentationName(value:String):void
		{
				_DocumentationName = value;
		}

		private var _DocumentationUNID:String;
		public function get DocumentationUNID():String
		{
				return _DocumentationUNID;
		}
		public function set DocumentationUNID(value:String):void
		{
				_DocumentationUNID = value;
		}

		private var _DocumentationBody:String;
		public function get DocumentationBody():String
		{
				return _DocumentationBody;
		}
		public function set DocumentationBody(value:String):void
		{
				_DocumentationBody = value;
		}
		
		private var _showUnid:Boolean;

		public function get showUnid():Boolean
		{
			return _showUnid;
		}

		public function set showUnid(value:Boolean):void
		{
			_showUnid = value;
		}
		
		private var _emptyImage:String = "image";

		public function get emptyImage():String
		{
			return _emptyImage;
		}

		public function set emptyImage(value:String):void
		{
			_emptyImage = value;
		}
		
		private var _image:String;

		public function get image():String
		{
			return _image;
		}

		public function set image(value:String):void
		{
			_image = value;
		}
		
		private var _Categories:Array = [];

		public function get Categories():Array
		{
			return _Categories;
		}
		public function set Categories(value:Array):void
		{
			_Categories = value;
		}
		
		public function DocumentationFormVO()
		{
		}

		public function clone():DocumentationFormVO
		{
		    var tmpVO:DocumentationFormVO = new DocumentationFormVO();
		    				tmpVO.DocumentationName = this.DocumentationName;
				tmpVO.DocumentationUNID = this.DocumentationUNID;
				tmpVO.DocumentationBody = this.DocumentationBody;
				tmpVO.DominoUniversalID = this.DominoUniversalID;
				tmpVO.Categories = this.Categories;
				
		    return tmpVO;
		}

		public function toRequestObject():Object
		{
			var tmpRequestObject:Object = {
				DocumentationName: this.DocumentationName,
				DocumentationUNID: this.DocumentationUNID,
				DocumentationBody: this.DocumentationBody,
				Categories: this.Categories
			};
			if (DominoUniversalID) tmpRequestObject.DominoUniversalID = DominoUniversalID;
			return tmpRequestObject;
		}

		public function containsCategory(category:String):Boolean {
			if (!Categories) return false;
			
			return Categories.some(function hasCat(cat:String, index:int, arr:Array):Boolean {
				return category == cat;
			});
		}
		
		public static function getDocumentationFormVO(value:Object):DocumentationFormVO
        {
            var tmpVO:DocumentationFormVO = new DocumentationFormVO();
            if ("DocumentationName" in value){	tmpVO.DocumentationName = value.DocumentationName;	}
			if ("DocumentationUNID" in value){	tmpVO.DocumentationUNID = value.DocumentationUNID;	}
			if ("DocumentationBody" in value){	tmpVO.DocumentationBody = value.DocumentationBody;	}
			if ("DominoUniversalID" in value){	tmpVO.DominoUniversalID = value.DominoUniversalID;	}
			if ("Categories" in value){ tmpVO.Categories = value.Categories; }

            return tmpVO;
        }

        public static function getToRequestMultivalueDateString(value:Array):String
        {
            var dates:Array = [];
            for (var i:int; i < value.length; i++)
            {
                dates.push(getToRequestDateString(value[i] as Date));
            }

			return ((dates.length > 0) ? JSON.stringify(dates) : "[]");
        }

        public static function getToRequestDateString(value:Date):String
        {
            var dateString:String = value.toISOString();
            return dateString;
        }

        public static function parseFromRequestMultivalueDateString(value:Array):Array
        {
            var dates:Array = [];
            for (var i:int; i < value.length; i++)
            {
                dates.push(parseFromRequestDateString(value[i]));
            }

            return dates;
        }

        public static function parseFromRequestDateString(value:String):Date
        {
            return (new Date(value));
        }
	}
}