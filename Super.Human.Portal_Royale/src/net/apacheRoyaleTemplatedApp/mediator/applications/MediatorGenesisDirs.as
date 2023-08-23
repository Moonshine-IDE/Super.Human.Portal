package mediator.applications
{
    import classes.com.devexpress.js.dataGrid.events.DataGridEvent;

    import constants.ApplicationConstants;
    import constants.PopupType;

    import interfaces.IGenesisDirsView;

    import model.proxy.applicationsCatalog.ProxyGenesisDirs;
    import model.proxy.urlParams.ProxyUrlParameters;
    import model.vo.GenesisDirVO;
    import model.vo.PopupVO;

    import org.apache.royale.events.MouseEvent;
    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
    import mediator.popup.MediatorPopup;
    
    public class MediatorGenesisDirs extends Mediator implements IMediator
    {
		public static const NAME:String  = 'MediatorGenesisDirs';
		
		private var genesisDirsProxy:ProxyGenesisDirs;
		private var urlParamsProxy:ProxyUrlParameters;
		
		public function MediatorGenesisDirs(component:IGenesisDirsView) 
		{
			super(NAME, component);
		}
		
		override public function onRegister():void 
		{			
			super.onRegister();
			
			view.newDir.addEventListener(MouseEvent.CLICK, onNewDirClick);
			view.genesisDirsList.addEventListener(DataGridEvent.DOUBLE_CLICK_ROW, onGenesisDirsDoubleClicked);
			view.genesisDirsList.addEventListener(DataGridEvent.CLICK_CELL, onGenesisDirsClickCell);
			view.refreshButton.addEventListener(MouseEvent.CLICK, onRefreshButtonClick);
			
			this.genesisDirsProxy = facade.retrieveProxy(ProxyGenesisDirs.NAME) as ProxyGenesisDirs;
			
			updateView();
		}
		
		override public function onRemove():void 
		{			
			super.onRemove();
			
			view.newDir.removeEventListener(MouseEvent.CLICK, onNewDirClick);
			view.genesisDirsList.removeEventListener(DataGridEvent.DOUBLE_CLICK_ROW, onGenesisDirsDoubleClicked);
			view.genesisDirsList.removeEventListener(DataGridEvent.CLICK_CELL, onGenesisDirsClickCell);
			view.refreshButton.removeEventListener(MouseEvent.CLICK, onRefreshButtonClick);
			
			this.genesisDirsProxy = null;
		}
		
		override public function listNotificationInterests():Array 
		{
			var interests:Array = super.listNotificationInterests();
				interests.push(ApplicationConstants.NOTE_OK_POPUP + MediatorPopup.NAME + this.getMediatorName());
				interests.push(ApplicationConstants.NOTE_CANCEL_POPUP + MediatorPopup.NAME + this.getMediatorName());
				interests.push(ProxyGenesisDirs.NOTE_GENESIS_DIRS_LIST_FETCHED);
				interests.push(ProxyGenesisDirs.NOTE_GENESIS_DIRS_LIST_FETCH_FAILED);
				interests.push(ProxyGenesisDirs.NOTE_GENESIS_DIR_DELETE_SUCCESS);
				interests.push(ProxyGenesisDirs.NOTE_GENESIS_DIR_DELETE_FAILED);
				
			return interests;
		}
		
		override public function handleNotification(note:INotification):void 
		{
			switch (note.getName()) 
			{
				case ProxyGenesisDirs.NOTE_GENESIS_DIRS_LIST_FETCHED:
					view.genesisDirsListProvider = note.getBody() as Array;
					break;
				case ProxyGenesisDirs.NOTE_GENESIS_DIRS_LIST_FETCH_FAILED:
					sendNotification(ApplicationConstants.COMMAND_SHOW_POPUP, new PopupVO(PopupType.ERROR, this.getMediatorName(), String(note.getBody())));
					break;	
				case ApplicationConstants.NOTE_OK_POPUP + MediatorPopup.NAME + this.getMediatorName():
					genesisDirsProxy.deleteDir();
					break;
				case ProxyGenesisDirs.NOTE_GENESIS_DIR_DELETE_SUCCESS:
					view.genesisDirsList["refreshDataProvider"]();		
					break;
				case ProxyGenesisDirs.NOTE_GENESIS_DIR_DELETE_FAILED:
					sendNotification(ApplicationConstants.COMMAND_SHOW_POPUP, new PopupVO(PopupType.ERROR, this.getMediatorName(), String(note.getBody())));
					break;
			}
		}		
		
		public function get view():IGenesisDirsView
		{
			return viewComponent as IGenesisDirsView;
		}

		private function onNewDirClick(event:MouseEvent):void
		{
			this.genesisDirsProxy.selectedDir = new GenesisDirVO();
			
			sendNotification(ApplicationConstants.NOTE_OPEN_ADD_EDIT_GENESIS_DIR);
		}
		
		private function onGenesisDirsDoubleClicked(event:DataGridEvent):void
		{
			this.genesisDirsProxy.selectedDir = event.item as GenesisDirVO;
			
			sendNotification(ApplicationConstants.NOTE_OPEN_ADD_EDIT_GENESIS_DIR, event.item);
		}
		
		private function onGenesisDirsClickCell(event:DataGridEvent):void
		{
			if (event.dataGridData.column.dataField == "delete")
			{
				this.genesisDirsProxy.selectedDir = event.item as GenesisDirVO;
				sendNotification(ApplicationConstants.COMMAND_SHOW_POPUP, new PopupVO(PopupType.QUESTION, this.getMediatorName(), 
							 "Are you sure you want to delete Genesis directory " + event.item.label + "?"));
			}
		}
		
		private function onRefreshButtonClick(event:Event):void
		{
			this.updateView();
		}	
		
		private function updateView():void
		{
			this.genesisDirsProxy.getDirsList();
		}
    }
}