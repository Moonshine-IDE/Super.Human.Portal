package model.vo
{
	public class GenesisDirVO 
	{
		public var label:String;
		public var url:String;
		
		public function GenesisDirVO(label:String, url:String) 
		{
			this.label = label;
			this.url = url;
		}
		
		public function toRequestObject():Object
		{
			return {
				label: this.label,
				url: this.url
			}
		}
	}
}