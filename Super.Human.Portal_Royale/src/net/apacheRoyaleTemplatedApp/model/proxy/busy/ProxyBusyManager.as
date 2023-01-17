package model.proxy.busy
{
	import constants.ApplicationConstants;
	import constants.PopupType;

	import interfaces.busy.IBusyOperator;

	import mediator.MediatorMainContentView;

	import model.vo.ConstantsCoreVO;
	import model.vo.PopupVO;

	import org.apache.royale.net.events.FaultEvent;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	import view.general.BusyOperator;
						
	public class ProxyBusyManager extends Proxy 
	{
		public static const NAME:String = "ProxyBusyManager";

		public function ProxyBusyManager()
		{
			super(NAME);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		public function getNewBusyOperator():IBusyOperator
		{
			return new BusyOperator(this.getData(), ConstantsCoreVO.BUSY_INDICATOR_SCALE_FACTOR);	
		}		
		
		public function wrapSuccessFunction(originalSuccessCallback:Function):Function
		{
            var operator:IBusyOperator = this.getNewBusyOperator();
            if (!operator)
            {
                return originalSuccessCallback;
            }

            operator.showBusy();
			
			//Hack for disabling drawer menu, cause simple disble bead doesn't work on it
			sendNotification(ApplicationConstants.COMMAND_REFRESH_NAV_ITEMS_ENABLED, false);
			
            var successFun:Function = function successFunction(e:Event):void
							           {
							               originalSuccessCallback(e);
							               operator.hideBusy();
							                
										   sendNotification(ApplicationConstants.COMMAND_REFRESH_NAV_ITEMS_ENABLED, true);
							           }
			return successFun;
		}

		public function wrapFailureFunction(originalFailureFunction:Function=null):Function
		{
            var operator:IBusyOperator = new BusyOperator(this.getData(), ConstantsCoreVO.BUSY_INDICATOR_SCALE_FACTOR);
            if (!operator)
            {
                return originalFailureFunction;
            }
            
            if (originalFailureFunction == null)
            {
                originalFailureFunction = onFault;
            }
            
            var failureFun:Function = function faultFunction(e:Event):void
            {
                originalFailureFunction(e);
                operator.hideBusy();
            }
            
            return failureFun;
		}
		//--------------------------------------------------------------------------
		//
		//  PRIVATE API
		//
		//--------------------------------------------------------------------------
		
		private function onFault(event:FaultEvent):void 
        {
        		sendNotification(ApplicationConstants.COMMAND_SHOW_POPUP, new PopupVO(PopupType.ERROR, MediatorMainContentView.NAME, "Submission failed: " + String(event.message)));
		}
	}
}