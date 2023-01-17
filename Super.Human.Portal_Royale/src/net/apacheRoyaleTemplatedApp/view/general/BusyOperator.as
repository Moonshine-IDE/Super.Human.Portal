package view.general
{
	import classes.beads.AppDisableLoaderBead;

	import interfaces.busy.IBusyOperator;

	import org.apache.royale.html.beads.DisableBead;
	import org.apache.royale.html.beads.DisabledAlphaBead;
	
	public class BusyOperator implements IBusyOperator
	{
		private var _disableBead:DisableBead;
        public static var defaultOperator:BusyOperator;

		public function BusyOperator(strand:Object, shrinkFactor:Number=1.0)
		{
            _disableBead = getDisableBead(strand, shrinkFactor);
		}

        private function getDisableBead(strand:Object, shrinkFactor:Number):DisableBead
        {
            var result:DisableBead = strand.getBeadByType(DisableBead) as DisableBead;
            if (!result)
            {
                result = new DisableBead();
                result.disabled = false;
                var busyIndicator:AppDisableLoaderBead = new AppDisableLoaderBead();
                busyIndicator.resizeFactor = shrinkFactor;
                strand.addBead(busyIndicator);
                var disableAlphaBead:DisabledAlphaBead = new DisabledAlphaBead();
                disableAlphaBead.disabledAlpha = 0.5;
                strand.addBead(disableAlphaBead);
                strand.addBead(result);
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
