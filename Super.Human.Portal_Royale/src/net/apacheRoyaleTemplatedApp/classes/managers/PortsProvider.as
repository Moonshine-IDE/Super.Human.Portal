package classes.managers
{
	public class PortsProvider  
	{
		private static var _instance:PortsProvider;
				
    	public function PortsProvider() 
		{
	        if(_instance) 
			{
	            throw new Error("PortsProvider ... use getInstance()");
	        	} 
        		_instance = this;
    	}

	    public static function getInstance():PortsProvider  
		{
	        if(!_instance)
			{
	            new PortsProvider();
	        } 
	        return _instance;
	    }
	
		private var _sshForwdPortMin:Number;
		
		[Bindable]
		public function get sshForwdPortMin():Number
		{
			return _sshForwdPortMin;
		}

		public function set sshForwdPortMin(value:Number):void
		{
			_sshForwdPortMin = value;
		}
		
		private var _sshForwdPortMax:Number;
		
		[Bindable]
		public function get sshForwdPortMax():Number
		{
			return _sshForwdPortMax;
		}

		public function set sshForwdPortMax(value:Number):void
		{
			_sshForwdPortMax = value;
		}
		
		private var _sshForwdPortPresent:Number;
		
		[Bindable]
		public function get sshForwdPortPresent():Number
		{
			return _sshForwdPortPresent;
		}

		public function set sshForwdPortPresent(value:Number):void
		{
			_sshForwdPortPresent = value;
		}
		
		private var _strongConfirmationValue:String;
		
		[Bindable]
		public function get strongConfirmationValue():String
		{
			return _strongConfirmationValue;
		}

		public function set strongConfirmationValue(value:String):void
		{
			_strongConfirmationValue = value;
		}
		
		public function resetValues():void
		{
			sshForwdPortMin = NaN;
			sshForwdPortMax = NaN;
			sshForwdPortPresent = NaN;
			strongConfirmationValue = null;
		}
	}
}