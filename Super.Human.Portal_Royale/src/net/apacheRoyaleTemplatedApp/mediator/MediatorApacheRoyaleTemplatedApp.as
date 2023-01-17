package mediator
{
	import interfaces.IApplication;

	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
								
	public class MediatorApacheRoyaleTemplatedApp extends Mediator implements IMediator
	{
		public static const NAME:String  = 'MediatorApacheRoyaleTemplatedApp';

		public function MediatorApacheRoyaleTemplatedApp(component:IApplication) 
		{
			super(NAME, component);
		}
		
		override public function onRegister():void 
		{			
			super.onRegister();
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
		
		override public function handleNotification(note:INotification):void {
			
			switch (note.getName()) 
			{
				
			}
		}		
		
		public function get view():IApplication
		{
			return viewComponent as IApplication;
		}
		
		//--------------------------------------------------------------------------
		//
		//  PRIVATE API
		//
		//--------------------------------------------------------------------------
	}
}