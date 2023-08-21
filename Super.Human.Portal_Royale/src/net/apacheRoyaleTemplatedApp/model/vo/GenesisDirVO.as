package model.vo
{
	[Bindable]
	public class GenesisDirVO 
	{
		public var label:String;
		public var url:String;
		public var password:String;
		
		public function GenesisDirVO(label:String, url:String, password:String = "") 
		{
			this.label = label;
			this.url = url;
			this.password = password;
		}
		
		public function toRequestObject():Object
		{
			return {
				label: this.label,
				url: this.url,
				password: this.password
			}
		}
	}
}