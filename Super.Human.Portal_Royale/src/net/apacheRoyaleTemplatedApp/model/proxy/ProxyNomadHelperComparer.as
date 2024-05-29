package model.proxy
{
	import model.proxy.login.ProxyLogin;

	import org.apache.royale.utils.async.PromiseTask;
	import org.apache.royale.utils.async.SequentialAsyncTask;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	import utils.NomadHelperLoaderTasks;
	import utils.UtilsCore;
	
	public class ProxyNomadHelperComparer extends Proxy
	{
		public static const NAME:String = "ProxyNomadHelperComparer";
		public static const NOTE_COMPARE_RESULTS:String = NAME + "NoteCompareResults";
		
		public function ProxyNomadHelperComparer()
		{
			super(NAME);
			
			setData(false);
		}

		public function isNomadHelpersEqual():Boolean
		{
			return Boolean(getData());
		}
		
		public function compareNomadHelpers():void
		{
			var loginProxy:ProxyLogin = facade.retrieveProxy(ProxyLogin.NAME) as ProxyLogin;
			if (loginProxy.isNomadHelperUrlExists())
			{
				var nomadHelperUrlTasks:NomadHelperLoaderTasks = new NomadHelperLoaderTasks();
					nomadHelperUrlTasks.done(function(task:PromiseTask):void {
						if (nomadHelperUrlTasks.failed)
						{
							setData(false);
							sendNotification(NOTE_COMPARE_RESULTS, getData());
						}
						else if (nomadHelperUrlTasks.completed)
						{
							compareNomadHelperUrl(nomadHelperUrlTasks.completedTasks[0], nomadHelperUrlTasks.completedTasks[1]);
						}
					});
				nomadHelperUrlTasks.run(loginProxy.config.config.nomad_helper_url);
			}
		}
	
		private function compareNomadHelperUrl(nomadHelperUrlTask:PromiseTask, nomadHelperUrlTask2:PromiseTask):void
		{
			var nomadHelperUrlHash:PromiseTask = UtilsCore.computeHash(nomadHelperUrlTask.result.target.element.responseText);
			var nomadHelperUrlHash2:PromiseTask = UtilsCore.computeHash(nomadHelperUrlTask2.result.target.element.responseText);
			
			var sequentialHashTask:SequentialAsyncTask = new SequentialAsyncTask([
				nomadHelperUrlHash,
				nomadHelperUrlHash2
			]);
			
			sequentialHashTask.done(function(task:PromiseTask) {
				if (sequentialHashTask.failed)
				{
					setData(false);
				}
				else if (sequentialHashTask.completed)
				{
					var hash1:String = sequentialHashTask.completedTasks[0].data;
					var hash2:String = sequentialHashTask.completedTasks[1].data;
					
					var isNomadHelpersEqual:Boolean = hash1 == hash2;
					setData(isNomadHelpersEqual);
				}
				
				sendNotification(NOTE_COMPARE_RESULTS, getData());
			})
			sequentialHashTask.run();
		}
	}
}