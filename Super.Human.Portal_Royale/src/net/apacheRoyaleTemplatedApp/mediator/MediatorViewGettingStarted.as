package mediator
{
    import Super.Human.Portal_Royale.views.modules.DocumentationForm.DocumentationFormServices.DocumentationFormProxy;

    import classes.breadcrump.events.BreadcrumpEvent;
    import classes.com.devexpress.js.tileView.events.TileViewEvent;

    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;

    import view.general.BusyOperator;

    public class MediatorViewGettingStarted extends Mediator implements IMediator
    {
		public static const NAME:String = 'MediatorViewGettingStarted';
		
		private var proxy:DocumentationFormProxy;

		public function MediatorViewGettingStarted(component:Object) 
		{
			super(NAME, component);
		}
		
		override public function onRegister():void 
		{
			super.onRegister();
			
			this.proxy = DocumentationFormProxy.getInstance();
			this.proxy.loadConfig();
			
			//view.addEventListener("stateChangeComplete", onViewStateChange);
			this.view.tileGettingStarted.addEventListener(TileViewEvent.CLICK_ITEM, onTileViewClickItem);
			this.view.breadcrump.addEventListener(BreadcrumpEvent.BREADCRUMP_ITEM_CLICK, onBreadcrumpItemClick);

			this.view.refreshItems();
		}

		override public function onRemove():void 
		{			
			super.onRemove();
			
			//view.removeEventListener("stateChangeComplete", onViewStateChange);
			this.view.tileGettingStarted.removeEventListener(TileViewEvent.CLICK_ITEM, onTileViewClickItem);
			this.view.breadcrump.removeEventListener(BreadcrumpEvent.BREADCRUMP_ITEM_CLICK, onBreadcrumpItemClick);
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
			this.view.currentState = 'dataGridState';
			this.proxy.dispatchEvent(new Event(DocumentationFormProxy.EVENT_ITEM_UPDATED));
		}

		private function onBreadcrumpItemClick(event:BreadcrumpEvent):void
		{
			if (event.item.parent != null)
			{
				this.view.breadcrump.buildBreadcrump(event.item);
				
				this.view.currentState = 'dataGridState';
				this.proxy.dispatchEvent(new Event(DocumentationFormProxy.EVENT_ITEM_UPDATED));
			}
			else
			{
				this.view.resetDocumentationForm();
			}
		}
    }
}
