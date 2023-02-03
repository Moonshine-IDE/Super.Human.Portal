package mediator
{
    import interfaces.IViewHello;

    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;

    import view.general.BusyOperator;

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
			
			view.refreshItems();
		}

		override public function onRemove():void 
		{			
			super.onRemove();
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
    }
}
