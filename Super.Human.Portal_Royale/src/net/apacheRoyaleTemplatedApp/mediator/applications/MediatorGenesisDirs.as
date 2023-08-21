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
			
			this.genesisDirsProxy = facade.retrieveProxy(ProxyGenesisDirs.NAME) as ProxyGenesisDirs;
			
			updateView();
		}
		
		override public function onRemove():void 
		{			
			super.onRemove();
			
			view.newDir.removeEventListener(MouseEvent.CLICK, onNewDirClick);
			view.genesisDirsList.removeEventListener(DataGridEvent.DOUBLE_CLICK_ROW, onGenesisDirsDoubleClicked);
			
			this.genesisDirsProxy = null;
		}
		
		override public function listNotificationInterests():Array 
		{
			var interests:Array = super.listNotificationInterests();
				interests.push(ProxyGenesisDirs.NOTE_GENESIS_DIRS_LIST_FETCHED);
				interests.push(ProxyGenesisDirs.NOTE_GENESIS_DIRS_LIST_FETCH_FAILED);
				
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
			}
		}		
		
		public function get view():IGenesisDirsView
		{
			return viewComponent as IGenesisDirsView;
		}

		private function onNewDirClick(event:MouseEvent):void
		{
			this.genesisDirsProxy.selectedDir = new GenesisDirVO("", "");
			
			sendNotification(ApplicationConstants.NOTE_OPEN_ADD_EDIT_GENESIS_DIR);
		}
		
		private function onGenesisDirsDoubleClicked(event:DataGridEvent):void
		{
			this.genesisDirsProxy.selectedDir = event.item as GenesisDirVO;
			
			sendNotification(ApplicationConstants.NOTE_OPEN_ADD_EDIT_GENESIS_DIR, event.item);
		}
		
		private function updateView():void
		{
			this.genesisDirsProxy.getDirsList();
		}
    }
}