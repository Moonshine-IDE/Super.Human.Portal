package view.general
{
	import classes.beads.AppDisableLoaderBead;

	import interfaces.busy.IBusyOperator;

	import org.apache.royale.html.beads.DisableBead;
	import org.apache.royale.html.beads.DisabledAlphaBead;
	
	public class BusyOperator implements IBusyOperator
	{
		private var _currentStrand:Object;
		private var _disableBead:DisableBead;
		private var _message:String;
		
        public static var defaultOperator:BusyOperator;

		public function BusyOperator(strand:Object, shrinkFactor:Number = 1.0, message:String = null)
		{
			_currentStrand = strand;
        		_message = message;
            _disableBead = getDisableBead(strand, shrinkFactor);
		}

        private function getDisableBead(strand:Object, shrinkFactor:Number):DisableBead
        {
        		_currentStrand = strand;
            var result:DisableBead = _currentStrand.getBeadByType(DisableBead) as DisableBead;
		
            if (!result)
            {
                result = new DisableBead();
                result.disabled = false;
                
            var busyIndicator:AppDisableLoaderBead = new AppDisableLoaderBead();
            	    busyIndicator.resizeFactor = shrinkFactor;
            	    busyIndicator.loaderText = _message;
                	    
                _currentStrand.addBead(busyIndicator);
          
                var disableAlphaBead:DisabledAlphaBead = new DisabledAlphaBead();
                disableAlphaBead.disabledAlpha = 0.5;
                _currentStrand.addBead(disableAlphaBead);
                _currentStrand.addBead(result);
            }
            else
            {
            		this.setMessage(_message);
            }
            
            return result;
        }

        public function showBusy():void
        {
            _disableBead.disabled = true;
        }

        public function hideBusy():void
        {
            _disableBead.disabled = false;
        }
        
        public function setMessage(message:String):void
        {
			_message = message;
			var busyIndicator:AppDisableLoaderBead = _currentStrand.getBeadByType(AppDisableLoaderBead) as AppDisableLoaderBead;
			if (busyIndicator)
			{
				busyIndicator.loaderText = message;
			}
        }
	}
}
