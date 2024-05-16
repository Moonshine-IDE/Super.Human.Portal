package view.controls.snackbarNomadHelperUrl.beads
{
    import org.apache.royale.jewel.beads.views.SnackbarView;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.html.elements.Div;
    import org.apache.royale.jewel.beads.models.SnackbarModel;
    import org.apache.royale.jewel.Snackbar;
    import view.controls.snackbarNomadHelperUrl.SnackbarNomadHelperUrlContent;

	public class SnackbarNomadHelperUrlView extends SnackbarView 
	{
		public function SnackbarNomadHelperUrlView()
		{
			super();
		}
		
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
			var model:SnackbarNomadHelperUrlModel = host.model as SnackbarNomadHelperUrlModel;
            model.addEventListener("messageChange", messageChangeHandler);
            model.addEventListener("actionChange", actionChangeHandler);
            
			var content:NodeList = host.element.getElementsByClassName("snackbar-content");
				host.element.removeChild(content.item(0));
				
			var snackbarMessage:SnackbarNomadHelperUrlContent = new SnackbarNomadHelperUrlContent();
				snackbarMessage.className = "jewel snackbar-message";
				snackbarMessage.nomadBaseUrl = model.nomadBaseUrl;
				snackbarMessage.dataDirectory = model.dataDirectory;
				snackbarMessage.configurationNomadUrl = model.configurationNomadUrl;
				
			var snackbarContent:Div = new Div();
				snackbarContent.className = "jewel snackbar-content";
				snackbarContent.addElement(snackbarMessage);
			host.addElement(snackbarContent);
			
			this.actionElement = null;
			if (model.action)
			{ 
				actionChangeHandler(null);
			}
		}
		
		/**
         *  Update the text when message changed. 
         */
        protected function messageChangeHandler(event:Event):void {
            COMPILE::JS
            {
               // HTMLElement(host.element.firstChild.firstChild).innerHTML = SnackbarModel(host.model).message;
            }
        }

        /**
         *  Show the action element or remove it, based on action text.
         */
        protected function actionChangeHandler(event:Event):void {
            var model:SnackbarModel = host.model as SnackbarModel;

            if (model.action) {
				if (!actionElement) {
					actionElement = document.createElement("div");
					actionElement.className = "jewel snackbar-action";
					actionElement.addEventListener("click", actionClickHandler);
					host.element.firstChild.appendChild(actionElement);
				}
				actionElement.innerText = model.action;
			} else {
				if (actionElement) {
					actionElement.removeEventListener("click", actionClickHandler);
					host.element.firstChild.removeChild(actionElement);
					actionElement = null;
				}
			}
        }
        
         /**
         *  Trigger event and dismiss the host when action clicked.
         */
        protected function actionClickHandler(event:Event):void {
            	actionElement.removeEventListener("click", actionClickHandler);
            	host.dispatchEvent(new Event(Snackbar.ACTION));
            	SnackbarModel(host.model).duration = -1; // set -1 to dismiss
        }
	}
}