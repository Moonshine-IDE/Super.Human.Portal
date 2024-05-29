package utils
{
    import org.apache.royale.utils.async.SequentialAsyncTask;
    import services.NomadHelperDelegate;
    import org.apache.royale.utils.async.AsyncTask;
    import org.apache.royale.utils.async.PromiseTask;
    import org.apache.royale.net.events.FaultEvent;

    /**
     * Class load local resources/nomadhelper.html and deployed nomadhelper.html
     **/
	public class NomadHelperLoaderTasks extends SequentialAsyncTask 
	{
		public function NomadHelperLoaderTasks(tasks:Array=null)
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
				var localNomadHelper:NomadHelperDelegate = new NomadHelperDelegate();
					localNomadHelper.getLocalNomadHelper(function(event:Event):void{
						resolve(event);
					}, function onFault(fault:FaultEvent):void{
						reject(fault);
					})
			}));
			this.addTask(localNomadHelperTask);
			
			var remoteNomadHelperTask:PromiseTask = new PromiseTask(new Promise(function(resolve:Function, reject:Function){
				var localNomadHelper:NomadHelperDelegate = new NomadHelperDelegate();
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