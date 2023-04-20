package mediator.applications
{
    import interfaces.IInstalledAppView;

    import model.proxy.applicationsCatalog.ProxyGenesisApps;
    import model.proxy.urlParams.ProxyUrlParameters;

    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
    
    public class MediatorInstalledApps extends Mediator implements IMediator
    {
		public static const NAME:String  = 'MediatorInstalledApp';
		
		private var genesisAppsProxy:ProxyGenesisApps;
		private var urlParamsProxy:ProxyUrlParameters;
		
		public function MediatorInstalledApps(mediatorName:String, component:IInstalledAppView) 
		{
			super(mediatorName, component);
		}
		
		override public function onRegister():void 
		{			
			super.onRegister();
			
			this.genesisAppsProxy = facade.retrieveProxy(ProxyGenesisApps.NAME) as ProxyGenesisApps;
			
			updateView();
		}
		
		override public function onRemove():void 
		{			
			super.onRemove();

			this.genesisAppsProxy = null;
		}
		
		
		override public function listNotificationInterests():Array 
		{
			var interests:Array = super.listNotificationInterests();
	
			return interests;
		}
		
		override public function handleNotification(note:INotification):void 
		{
			switch (note.getName()) 
			{
				
			}
		}		
		
		public function get view():IInstalledAppView
		{
			return viewComponent as IInstalledAppView;
		}

		private function updateView():void
		{
			
		}
    }
}