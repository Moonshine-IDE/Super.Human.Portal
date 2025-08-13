package view.controls.snackbarNomadHelperUrl
{
    import org.apache.royale.jewel.Snackbar;
    import view.controls.snackbarNomadHelperUrl.beads.SnackbarNomadHelperUrlModel;

	public class SnackbarNomadHelperUrl extends Snackbar 
	{
		public function SnackbarNomadHelperUrl()
		{
			super();
			
			this.typeNames = "jewel snackbar layout SnackbarNomadHelperUrl";
		}
		
		public static function show(dataDirectory:String, nomadBaseUrl:String, configurationNomadUrl:String, 
								   configurationNotesUrl:String, showOutdatedNomadHelperMessage:Boolean = false, parent:Object = null):SnackbarNomadHelperUrl
		{
			 var snackbar:SnackbarNomadHelperUrl = new SnackbarNomadHelperUrl();
            		 snackbar.message = "";
				 snackbar.duration = 0;
				 snackbar.action = "Close";
				 snackbar.dataDirectory = dataDirectory;
				 snackbar.nomadBaseUrl = nomadBaseUrl;
				 snackbar.configurationNomadUrl = configurationNomadUrl;
				 snackbar.configurationNotesUrl = configurationNotesUrl;
				 snackbar.showOutdatedNomadHelperMessage = showOutdatedNomadHelperMessage;
				 
           		 snackbar.show(parent);
			return snackbar;
		}
		
		public function get dataDirectory():String
		{
			return SnackbarNomadHelperUrlModel(model).dataDirectory;
		}

		public function set dataDirectory(value:String):void
		{
			SnackbarNomadHelperUrlModel(model).dataDirectory = value;
		}
		
		public function get nomadBaseUrl():String
		{
			return SnackbarNomadHelperUrlModel(model).nomadBaseUrl;
		}

		public function set nomadBaseUrl(value:String):void
		{
			SnackbarNomadHelperUrlModel(model).nomadBaseUrl = value;
		}
		
		public function get configurationNomadUrl():String
		{
			return SnackbarNomadHelperUrlModel(model).configurationNomadUrl;
		}

		public function set configurationNomadUrl(value:String):void
		{
			SnackbarNomadHelperUrlModel(model).configurationNomadUrl = value;
		}
		
		public function get configurationNotesUrl():String
		{
			return SnackbarNomadHelperUrlModel(model).configurationNotesUrl;
		}

		public function set configurationNotesUrl(value:String):void
		{
			SnackbarNomadHelperUrlModel(model).configurationNotesUrl = value;
		}

		public function get showOutdatedNomadHelperMessage():Boolean
		{
			return SnackbarNomadHelperUrlModel(model).showOutdatedNomadHelperMessage;
		}

		public function set showOutdatedNomadHelperMessage(value:Boolean):void
		{
			SnackbarNomadHelperUrlModel(model).showOutdatedNomadHelperMessage = value;
		}
	}
}