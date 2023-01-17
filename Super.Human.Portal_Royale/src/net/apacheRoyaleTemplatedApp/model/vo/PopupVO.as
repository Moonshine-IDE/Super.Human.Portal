package model.vo
{
	public class PopupVO
	{
		public function PopupVO(popupType:int, mediatorName:String, message:String, 
								okButtonLabel:String = null, cancelButtonLabel:String = null,
								width:Number = NaN, height:Number = NaN)
		{
			this.popupType = popupType;
			this.mediatorName = mediatorName;
			this.message = message;
			this.okButtonLabel = okButtonLabel;
			this.cancelButtonLabel = cancelButtonLabel;
			this.width = width;
			this.height = height;
		}
		
		private var _popupType:int;
		public function get popupType():int
		{
			return _popupType;
		}
		public function set popupType(value:int):void
		{
			_popupType = value;
		}
		
		private var _mediatorName:String;
		public function get mediatorName():String
		{
			return _mediatorName;
		}
		public function set mediatorName(value:String):void
		{
			_mediatorName = value;
		}
		
		private var _message:String;
		public function get message():String
		{
			return _message;
		}
		public function set message(value:String):void
		{
			_message = value;
		}
		
		private var _okButtonLabel:String;
		public function get okButtonLabel():String
		{
			return _okButtonLabel;
		}
		public function set okButtonLabel(value:String):void
		{
			_okButtonLabel = value;
		}
		
		private var _cancelButtonLabel:String;
		public function get cancelButtonLabel():String
		{
			return _cancelButtonLabel;
		}
		public function set cancelButtonLabel(value:String):void
		{
			_cancelButtonLabel = value;
		}
		
		private var _width:Number;
		public function get width():Number
		{
			return _width;
		}
		public function set width(value:Number):void
		{
			_width = value;
		}
		
		private var _height:Number;
		public function get height():Number
		{
			return _height;
		}
		public function set height(value:Number):void
		{
			_height = value;
		}
		
		private var _eventOKSuffix:String;
		
		public function get eventOKSuffix():String
		{
			return _eventOKSuffix;	
		}		
		
		public function set eventOKSuffix(value:String):void
		{
			_eventOKSuffix = value;
		}
		
		private var _eventCancelSuffix:String;
		
		public function get eventCancelSuffix():String
		{
			return _eventCancelSuffix;	
		}	
		
		public function set eventCancelSuffix(value:String):void
		{
			_eventCancelSuffix = value;
		}
	}
}