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

		    return tmpVO;
		}

		public function toRequestObject():Object
		{
			var tmpRequestObject:Object = {
	
DocumentationName: this.DocumentationName,
DocumentationUNID: this.DocumentationUNID,
DocumentationBody: this.DocumentationBody
};
if (DominoUniversalID) tmpRequestObject.DominoUniversalID = DominoUniversalID;
return tmpRequestObject;
		}

		public static function getDocumentationFormVO(value:Object):DocumentationFormVO
        {
            var tmpVO:DocumentationFormVO = new DocumentationFormVO();
            if ("DocumentationName" in value){	tmpVO.DocumentationName = value.DocumentationName;	}
if ("DocumentationUNID" in value){	tmpVO.DocumentationUNID = value.DocumentationUNID;	}
if ("DocumentationBody" in value){	tmpVO.DocumentationBody = value.DocumentationBody;	}
if ("DominoUniversalID" in value){	tmpVO.DominoUniversalID = value.DominoUniversalID;	}

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