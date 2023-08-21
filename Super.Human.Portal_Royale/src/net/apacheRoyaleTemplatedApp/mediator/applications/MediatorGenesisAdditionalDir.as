package mediator.applications
{
    import constants.ApplicationConstants;
    import constants.PopupType;

    import interfaces.IGenesisAdditionalDirView;

    import model.proxy.applicationsCatalog.ProxyGenesisApps;
    import model.proxy.applicationsCatalog.ProxyGenesisDirs;
    import model.proxy.urlParams.ProxyUrlParameters;
    import model.vo.PopupVO;

    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
    import org.apache.royale.events.MouseEvent;
    
    public class MediatorGenesisAdditionalDir extends Mediator implements IMediator
    {
		public static const NAME:String  = 'MediatorGenesisAdditionalDir';
		
		private var genesisDirsProxy:ProxyGenesisDirs;
		private var urlParamsProxy:ProxyUrlParameters;
		
		public function MediatorGenesisAdditionalDir(component:IGenesisAdditionalDirView) 
		{
			super(NAME, component);
		}
		
		override public function onRegister():void 
		{			
			super.onRegister();
			
			view.newDir.addEventListener(MouseEvent.CLICK, onNewDirClick);
			
			this.genesisDirsProxy = facade.retrieveProxy(ProxyGenesisDirs.NAME) as ProxyGenesisDirs;
			
			updateView();
		}
		
		override public function onRemove():void 
		{			
			super.onRemove();
			
			view.newDir.removeEventListener(MouseEvent.CLICK, onNewDirClick);
			
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
		
		public function get view():IGenesisAdditionalDirView
		{
			return viewComponent as IGenesisAdditionalDirView;
		}

		private function onNewDirClick(event:MouseEvent):void
		{
			
		}
		
		private function updateView():void
		{
			this.genesisDirsProxy.getDirsList();
		}
    }
}