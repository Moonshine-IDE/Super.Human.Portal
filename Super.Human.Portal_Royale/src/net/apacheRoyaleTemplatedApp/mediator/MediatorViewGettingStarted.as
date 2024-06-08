package mediator
{
    import interfaces.IViewHello;

    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;

    import view.general.BusyOperator;
    import Super.Human.Portal_Royale.views.modules.DocumentationForm.DocumentationFormServices.DocumentationFormProxy;
    import classes.com.devexpress.js.tileView.events.TileViewEvent;

    public class MediatorViewGettingStarted extends Mediator implements IMediator
    {
		public static const NAME:String = 'MediatorViewGettingStarted';
		
		public function MediatorViewGettingStarted(component:Object) 
		{
			super(NAME, component);
		}
		
		override public function onRegister():void 
		{
			super.onRegister();
			
			var proxy:DocumentationFormProxy = DocumentationFormProxy.getInstance();
				proxy.loadConfig();
			view.tileGettingStarted.addEventListener(TileViewEvent.CLICK_ITEM, onTileViewClickItem);
		}

		override public function onRemove():void 
		{			
			super.onRemove();
			
			view.tileGettingStarted.removeEventListener(TileViewEvent.CLICK_ITEM, onTileViewClickItem);
		}	
		
		public function get busyOperatory():BusyOperator
		{
			return BusyOperator.defaultOperator;
		}

		override public function listNotificationInterests():Array 
		{
			var interests:Array = super.listNotificationInterests();
			return interests;
		}

		override public function handleNotification( note:INotification ):void {
			
			switch (note.getName()) 
			{
									
			}
		}		
		
		public function get view():Object
		{
			return viewComponent as Object;
		}
		
		private function onTileViewClickItem(event:TileViewEvent):void
		{
			var item:Object = event.item;
			view.refreshItems();
		}
    }
}
