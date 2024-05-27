package utils
{
    import org.apache.royale.utils.async.SequentialAsyncTask;
    import services.NomadHelperUrlDelegate;
    import org.apache.royale.utils.async.AsyncTask;
    import org.apache.royale.utils.async.PromiseTask;
    import org.apache.royale.net.events.FaultEvent;

	public class NomadHelperUrlTasks extends SequentialAsyncTask 
	{
		public function NomadHelperUrlTasks(tasks:Array=null)
		{
			super(tasks);
			
			
		}
		
		override public function run(data:Object=null):void 
		{
			if (data == null) 
			{
				cancel();
				return;
			}
			
			var localNomadHelperTask:PromiseTask = new PromiseTask(new Promise(function(resolve:Function, reject:Function){
				var localNomadHelper:NomadHelperUrlDelegate = new NomadHelperUrlDelegate();
					localNomadHelper.getLocalNomadHelper(function(event:Event):void{
						resolve(event);
					}, function onFault(fault:FaultEvent):void{
						reject(fault);
					})
			}));
			this.addTask(localNomadHelperTask);
			
			var remoteNomadHelperTask:PromiseTask = new PromiseTask(new Promise(function(resolve:Function, reject:Function){
				var localNomadHelper:NomadHelperUrlDelegate = new NomadHelperUrlDelegate();
					localNomadHelper.getNomadHelper(String(data), function(event:Event):void{
						resolve(event);
					}, function onFault(fault:FaultEvent):void{
						reject(fault);
					})
			}));
			this.addTask(remoteNomadHelperTask);
			
			super.run(data);
		}
	}
}