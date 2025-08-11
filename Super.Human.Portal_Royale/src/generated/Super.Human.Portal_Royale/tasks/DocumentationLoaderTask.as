package Super.Human.Portal_Royale.tasks
{
    import Super.Human.Portal_Royale.classes.vo.Constants;
    import Super.Human.Portal_Royale.views.modules.DocumentationForm.DocumentationFormServices.DocumentationFormServices;

    import org.apache.royale.net.events.FaultEvent;
    import org.apache.royale.utils.async.PromiseTask;
    import org.apache.royale.utils.async.SequentialAsyncTask;

    import services.CategoriesDelegate;

	public class DocumentationLoaderTask extends SequentialAsyncTask 
	{
		public function DocumentationLoaderTask(tasks:Array=null)
		{
			super(tasks);
		}

		override public function run(data:Object=null):void 
		{
			var categoriesTask:PromiseTask = new PromiseTask(new Promise(function categoriesDelegate(resolve:Function, reject:Function):void {
				var categoryDelegate:CategoriesDelegate = new CategoriesDelegate();
					categoryDelegate.getCategoriesList(function(event:Event):void{
						resolve(event);
					}, function onFault(fault:FaultEvent):void{
						reject(fault);
					})
			}));
			
			this.addTask(categoriesTask);
			
			if (Constants.AGENT_BASE_URL)
			{
				var documentationTask:PromiseTask = new PromiseTask(new Promise(function documentationDelegate(resolve:Function, reject:Function):void {
					var documentationDelegate:DocumentationFormServices = new DocumentationFormServices();
						documentationDelegate.getDocumentationFormList(function(event:Event):void {
							resolve(event);
						}, function onFault(fault:FaultEvent):void{
							reject(fault);
						})
				}));
				this.addTask(documentationTask);
			}
			
			super.run(data);
		}
	}
}