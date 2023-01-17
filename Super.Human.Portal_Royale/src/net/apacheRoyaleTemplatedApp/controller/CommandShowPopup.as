package controller
{
	import mediator.popup.MediatorPopup;

	import model.vo.PopupVO;

	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class CommandShowPopup extends SimpleCommand
	{
		override public function execute(note:INotification):void 
		{
			var popupVO:PopupVO = note.getBody() as PopupVO;
			var hostMediator:IMediator = facade.retrieveMediator(popupVO.mediatorName);
			if (!facade.hasMediator(MediatorPopup.NAME + hostMediator.getMediatorName()))
			{
				facade.registerMediator(new MediatorPopup(hostMediator, popupVO));
			}
			
			var mediatorPopup:MediatorPopup = facade.retrieveMediator(MediatorPopup.NAME + hostMediator.getMediatorName()) as MediatorPopup;
			mediatorPopup.show();
		}
	}
}