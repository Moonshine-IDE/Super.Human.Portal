package mediator.popup
{
    import constants.ApplicationConstants;
    import constants.PopupType;

    import mediator.MediatorMainContentView;

    import model.vo.PopupVO;
    
    import org.apache.royale.core.IBeadView;
    import org.apache.royale.core.StyledUIBase;
    import org.apache.royale.events.CloseEvent;
    import org.apache.royale.jewel.Alert;
    import org.apache.royale.jewel.beads.views.AlertView;
    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;

    public class MediatorPopup extends Mediator implements IMediator
    {
		public static const NAME:String = 'MediatorPopup';

		private var hostComponent:IMediator;
		private var popupConfig:PopupVO;
		
		public function MediatorPopup(hostComponent:IMediator, popupConfig:PopupVO = null) 
		{
			super(NAME + popupConfig.mediatorName, new Alert());

			this.popupConfig = popupConfig;
		}
		
		override public function onRegister():void 
		{			
			super.onRegister();
									
			hostComponent = facade.retrieveMediator(MediatorMainContentView.NAME);
											
			view.addEventListener(CloseEvent.CLOSE, onPopupClose);
		}

		override public function onRemove():void 
		{			
			super.onRemove();

			view.removeEventListener(CloseEvent.CLOSE, onPopupClose);

			hostComponent = null;
			popupConfig = null;
		}	

		override public function listNotificationInterests():Array 
		{
			var interests:Array = super.listNotificationInterests();
			interests.push(ApplicationConstants.NOTE_SHOW_POPUP + this.getMediatorName());
			interests.push(ApplicationConstants.NOTE_HIDE_POPUP + this.getMediatorName());				
			
			return interests;
		}

		override public function handleNotification(note:INotification):void 
		{
			switch (note.getName()) 
			{
				case ApplicationConstants.NOTE_SHOW_POPUP + this.getMediatorName():
					this.popupConfig = note.getBody() as PopupVO;
					show();
					break;
				case ApplicationConstants.NOTE_HIDE_POPUP + this.getMediatorName():
					view.close();
					break;							
			}
		}		
		
		public function get view():Alert
		{
			return viewComponent as Alert;
		}
		
		public function show():void
		{
			view.flags = this.getAlertType();			
			view.title = this.getAlertTitle();
			view.message = popupConfig.message;	
			
			view.showModal(this.hostComponent.getViewComponent());
							
			var alertView:AlertView = this.view.getBeadByType(IBeadView) as AlertView;
			alertView.titleBar.className = "titleTextColor " + getAlertTitle().toLowerCase();
			alertView.controlBar.className = "controlBarPopup";

			if (alertView.okButton)
			{
				if (popupConfig.okButtonLabel)
				{
					alertView.okButton.text = popupConfig.okButtonLabel;
				}

				alertView.okButton.emphasis = getOkButtonStyle();
			}
			
			if (alertView.cancelButton)
			{
				if (popupConfig.cancelButtonLabel)
				{
					alertView.cancelButton.text = popupConfig.cancelButtonLabel;
				}
			}
			
			if (!isNaN(popupConfig.width))
			{
				view.width = popupConfig.width;
			}
			if (!isNaN(popupConfig.height))
			{
				view.height = popupConfig.height;
			}
		}
		
		private function onPopupClose(event:CloseEvent):void
		{
			var actionSuffix:String = "";
			var popupNotification:String = "";
			
			if (event.detail == Alert.OK)
			{
				if (popupConfig.eventOKSuffix) 
				{
					popupNotification = ApplicationConstants.NOTE_OK_POPUP + this.getMediatorName() + popupConfig.eventOKSuffix;	
				}			
				else 
				{
					popupNotification = ApplicationConstants.NOTE_OK_POPUP + this.getMediatorName();	
				}			
					
				sendNotification(popupNotification);
			}
			else if (event.detail == Alert.CANCEL)
			{
				if (popupConfig.eventCancelSuffix) 
				{
					popupNotification = ApplicationConstants.NOTE_CANCEL_POPUP + this.getMediatorName() + popupConfig.eventCancelSuffix;	
				}			
				else 
				{
					popupNotification = ApplicationConstants.NOTE_CANCEL_POPUP + this.getMediatorName();	
				}
				
				sendNotification(popupNotification);
			}		
			cleanUp();
		}		

		private function getAlertType():uint
		{
			switch (popupConfig.popupType)
			{
				case PopupType.QUESTION:
					return Alert.OK | Alert.CANCEL;
					break;
				default:
					return Alert.OK;
					break;
			}
		}
		
		private function getAlertTitle():String
		{
			switch (popupConfig.popupType)
			{
				case PopupType.WARNING:
					return "Warning";
					break;
				case PopupType.SUCCESS:
					return "Success";
					break;
				case PopupType.ERROR:
					return "Error";
					break;
				default:
					return "Info";
					break;
			}
		}
		
		private function getOkButtonStyle():String
		{
			switch (popupConfig.popupType)
			{
				case PopupType.WARNING:
					return "warn";
					break;
				case PopupType.SUCCESS:
					return StyledUIBase.EMPHASIZED;
					break;
				case PopupType.ERROR:
					return StyledUIBase.SECONDARY;
					break;
				default:
					return StyledUIBase.PRIMARY;
					break;
			}
		}		
		
		private function cleanUp():void
		{
			facade.removeMediator(this.getMediatorName());
		}
    }
}
