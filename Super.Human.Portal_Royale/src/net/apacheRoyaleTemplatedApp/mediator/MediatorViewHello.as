package mediator
{
    import interfaces.IViewHello;

    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;

    import view.general.BusyOperator;

    public class MediatorViewHello extends Mediator implements IMediator
    {
		public static const NAME:String = 'MediatorViewHello';
		
		public function MediatorViewHello(component:IViewHello) 
		{
			super(NAME, component);
		}
		
		override public function onRegister():void 
		{
			super.onRegister();
		}

		public function get busyOperatory():BusyOperator
		{
			return BusyOperator.defaultOperator;
		}

		override public function onRemove():void 
		{			
			super.onRemove();
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
		
		public function get view():IViewHello
		{
			return viewComponent as IViewHello;
		}
    }
}
