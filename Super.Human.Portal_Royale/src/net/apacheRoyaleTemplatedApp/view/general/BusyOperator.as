package view.general
{
	import classes.beads.AppDisableLoaderBead;

	import interfaces.busy.IBusyOperator;

	import org.apache.royale.html.beads.DisableBead;
	import org.apache.royale.html.beads.DisabledAlphaBead;
	
	public class BusyOperator implements IBusyOperator
	{
		private var _disableBead:DisableBead;
		private var _message:String;
		
        public static var defaultOperator:BusyOperator;

		public function BusyOperator(strand:Object, shrinkFactor:Number = 1.0, message:String = null)
		{
        		_message = message;
            _disableBead = getDisableBead(strand, shrinkFactor);
		}

        private function getDisableBead(strand:Object, shrinkFactor:Number):DisableBead
        {
            var result:DisableBead = strand.getBeadByType(DisableBead) as DisableBead;
			var busyIndicator:AppDisableLoaderBead = null;
			
            if (!result)
            {
                result = new DisableBead();
                result.disabled = false;
                
                busyIndicator = new AppDisableLoaderBead();
            	    busyIndicator.resizeFactor = shrinkFactor;
            	    busyIndicator.loaderText = _message;
                	    
                strand.addBead(busyIndicator);
          
                var disableAlphaBead:DisabledAlphaBead = new DisabledAlphaBead();
                disableAlphaBead.disabledAlpha = 0.5;
                strand.addBead(disableAlphaBead);
                strand.addBead(result);
            }
            else
            {
            		busyIndicator = strand.getBeadByType(AppDisableLoaderBead) as AppDisableLoaderBead;
            		if (busyIndicator)
            		{
            			busyIndicator.loaderText = _message;
            		}
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
	}
}
