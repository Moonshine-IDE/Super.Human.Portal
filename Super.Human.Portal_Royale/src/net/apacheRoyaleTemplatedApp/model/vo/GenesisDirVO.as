package model.vo
{
	[Bindable]
	public class GenesisDirVO 
	{
		public var dominoUniversalID:String;
		public var isPrivate:Boolean;
		public var label:String;
		public var url:String;
		public var password:String;
		public var hasPassword:Boolean;
		
		public function GenesisDirVO(dominoUniversalID:String = "", isPrivate:Boolean = false, label:String = "", url:String = "", password:String = "") 
		{
			this.dominoUniversalID = dominoUniversalID;
			this.isPrivate = isPrivate;
			this.label = label;
			this.url = url;
			this.password = password;
		}
		
		public function toRequestObject():Object
		{
			var requestObject:Object = {
				DominoUniversalID: this.dominoUniversalID,
				label: this.label,
				url: this.url
			};
			
			if (this.hasPassword)
			{
				requestObject.password = this.password;
			}
			
			return requestObject;
		}
	}
}