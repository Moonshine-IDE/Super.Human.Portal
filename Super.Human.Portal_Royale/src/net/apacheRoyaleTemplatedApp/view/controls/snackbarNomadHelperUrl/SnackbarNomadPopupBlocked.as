package view.controls.snackbarNomadHelperUrl
{
    import org.apache.royale.jewel.Snackbar;

	public class SnackbarNomadPopupBlocked extends Snackbar 
	{
		public function SnackbarNomadPopupBlocked()
		{
			super();
			
			this.typeNames = "jewel snackbar layout SnackbarNomadPopupBlocked";
		}
		
		public static function show(message:String = "", parent:Object = null):SnackbarNomadPopupBlocked
		{
			 var snackbar:SnackbarNomadPopupBlocked = new SnackbarNomadPopupBlocked();
            		 snackbar.message = message;
				 snackbar.duration = 0;
				 snackbar.action = "Close";
				 
           		 snackbar.show(parent);
			return snackbar;
		}
	}
}