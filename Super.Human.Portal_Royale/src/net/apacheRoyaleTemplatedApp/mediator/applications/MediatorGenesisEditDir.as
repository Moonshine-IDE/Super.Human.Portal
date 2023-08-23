package mediator.applications
{
    import constants.ApplicationConstants;
    import constants.PopupType;

    import interfaces.IGenesisEditDirView;

    import model.proxy.applicationsCatalog.ProxyGenesisDirs;
    import model.proxy.urlParams.ProxyUrlParameters;
    import model.vo.PopupVO;

    import org.apache.royale.events.MouseEvent;
    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
    
    public class MediatorGenesisEditDir extends Mediator implements IMediator
    {
		public static const NAME:String  = 'MediatorGenesisEditDir';
		
		private var genesisDirsProxy:ProxyGenesisDirs;
		private var urlParamsProxy:ProxyUrlParameters;
		
		public function MediatorGenesisEditDir(component:IGenesisEditDirView) 
		{
			super(NAME, component);
		}
		
		override public function onRegister():void 
		{			
			super.onRegister();
			
			this.genesisDirsProxy = facade.retrieveProxy(ProxyGenesisDirs.NAME) as ProxyGenesisDirs;
			
			this.view.genesisDirForm.addEventListener("valid", onGenesisDirFormValid);
			this.view.cancelGenesisEdit.addEventListener(MouseEvent.CLICK, onCancelEditGenesisDir);
			this.view.passwordChange.addEventListener(MouseEvent.CLICK, onPasswordChangeClick);
			
			updateView();
		}
		
		override public function onRemove():void 
		{			
			super.onRemove();

			this.view.resetView();
			this.view.genesisDirForm.removeEventListener("valid", onGenesisDirFormValid);
			this.view.genesisDirForm.removeEventListener(MouseEvent.CLICK, onCancelEditGenesisDir);
			this.genesisDirsProxy.selectedDir = null;
			this.genesisDirsProxy = null;
		}
		
		
		override public function listNotificationInterests():Array 
		{
			var interests:Array = super.listNotificationInterests();
				interests.push(ProxyGenesisDirs.NOTE_GENESIS_DIR_CREATE_SUCCESS);
				interests.push(ProxyGenesisDirs.NOTE_GENESIS_DIR_CREATE_FAILED);
				interests.push(ProxyGenesisDirs.NOTE_GENESIS_DIR_UPDATE_SUCCESS);
				interests.push(ProxyGenesisDirs.NOTE_GENESIS_DIR_UPDATE_FAILED);
				
			return interests;
		}
		
		override public function handleNotification(note:INotification):void 
		{
			switch (note.getName()) 
			{
				case ProxyGenesisDirs.NOTE_GENESIS_DIR_CREATE_SUCCESS:
					sendNotification(ApplicationConstants.NOTE_OPEN_GENESIS_DIRS_VIEW);
					break;
				case ProxyGenesisDirs.NOTE_GENESIS_DIR_UPDATE_SUCCESS:
					sendNotification(ApplicationConstants.NOTE_OPEN_GENESIS_DIRS_VIEW);
					break;
				case ProxyGenesisDirs.NOTE_GENESIS_DIR_CREATE_FAILED:
				case ProxyGenesisDirs.NOTE_GENESIS_DIR_UPDATE_FAILED:
					sendNotification(ApplicationConstants.COMMAND_SHOW_POPUP, new PopupVO(PopupType.ERROR, this.getMediatorName(), String(note.getBody())));
					break;
			}
		}		
		
		public function get view():IGenesisEditDirView
		{
			return viewComponent as IGenesisEditDirView;
		}

		private function onGenesisDirFormValid(event:Event):void
		{
			genesisDirsProxy.selectedDir.label = view.labelText;
			genesisDirsProxy.selectedDir.url = view.urlText;
			if (!view.isPasswordDisabled)
			{
				genesisDirsProxy.selectedDir.password = view.passwordText;
			}

			if (genesisDirsProxy.selectedDir.dominoUniversalID)
			{
				genesisDirsProxy.updateDir();
			}
			else
			{
				genesisDirsProxy.createDir();
			}
		}
		
		private function onCancelEditGenesisDir(event:MouseEvent):void
		{
			sendNotification(ApplicationConstants.NOTE_OPEN_GENESIS_DIRS_VIEW);
		}

		private function onPasswordChangeClick(event:MouseEvent):void
		{
			view.isPasswordDisabled = false;
			view.passwordPrompt.visible = false;
		}
		
		private function updateView():void
		{
			this.view.genesisDir = genesisDirsProxy.selectedDir;
			
			if (genesisDirsProxy.selectedDir.dominoUniversalID)
			{
				this.view.titleGenesisDir = "Edit Genesis Directory";
				this.view.isPasswordDisabled = true;
				this.view.passwordPrompt.visible = true;
			}
			else
			{
				this.view.titleGenesisDir = "Add Genesis Directory";
				this.view.isPasswordDisabled = false;
				this.view.passwordPrompt.visible = false;
			}
			
			this.refreshPasswordInputPrompt();
		}
		
		private function refreshPasswordInputPrompt():void
		{
			if (genesisDirsProxy.selectedDir && genesisDirsProxy.selectedDir.isPrivate)
			{
				this.view.passwordPrompt.text = "Password set";
			}
			else
			{
				this.view.passwordPrompt.text = "No password required";
			}
		}
    }
}