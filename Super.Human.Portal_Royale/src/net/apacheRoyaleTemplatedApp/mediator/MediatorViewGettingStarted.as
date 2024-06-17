package mediator
{
    import Super.Human.Portal_Royale.views.modules.DocumentationForm.DocumentationFormServices.DocumentationFormProxy;

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
			
			proxy = DocumentationFormProxy.getInstance();
			proxy.loadConfig();
			
			view.addEventListener("stateChangeComplete", onViewStateChange);
			view.tileGettingStarted.addEventListener(TileViewEvent.CLICK_ITEM, onTileViewClickItem);
			
			view.refreshItems();
		}

		override public function onRemove():void 
		{			
			super.onRemove();
			
			view.removeEventListener("stateChangeComplete", onViewStateChange);
			view.tileGettingStarted.removeEventListener(TileViewEvent.CLICK_ITEM, onTileViewClickItem);
			if (view.dg)
			{
				view.dg.removeEventListener(TileViewEvent.DOUBLE_CLICK_ITEM, onDgTileDoubleClickItem);
			}
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
		
		private function onViewStateChange(event:Event):void
		{
			if (view.currentState == "dataGridState")
			{
				if (proxy.editable)
				{
					if (view.dg && !view.dg.hasEventListener(TileViewEvent.DOUBLE_CLICK_ITEM))
					{
						view.dg.addEventListener(TileViewEvent.DOUBLE_CLICK_ITEM, onDgTileDoubleClickItem);
					}
				}
			}
		}
		
		private function onTileViewClickItem(event:TileViewEvent):void
		{
			view.currentState = 'dataGridState';
			proxy.dispatchEvent(new Event(DocumentationFormProxy.EVENT_ITEM_UPDATED));
		}
		
		private function onDgTileDoubleClickItem(event:TileViewEvent):void
		{
			view.initReadOnlyForm();
		}
    }
}
