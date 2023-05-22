package model.proxy
{
	import classes.locator.NativeModelLocator;
	import classes.managers.UrlProvider;

	import model.vo.VersionVO;

	import org.apache.royale.events.Event;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	import services.VersionServiceDelegate;
	import org.apache.royale.net.events.FaultEvent;
	
	public class ProxyVersion extends Proxy
	{
		public static const NAME:String = "ProxyVersion";
		public static const NOTE_OBSOLETE_CURRENT_VERSION:String = "NoteCurrentVersionIsObsolete";
		public static const NOTE_VERSION_INFORMATION_LOADED:String = "NoteVersionInformationLoaded";
		
		protected var versionServiceDelegate:VersionServiceDelegate;
		
		private var _currentVersion:String;
		private var _currentMajor:int = -1;
		private var _currentMinor:int = -1;
		private var _currentRevision:int = -1;
		
		private var nativeLocator:NativeModelLocator;
		
		public function ProxyVersion()
		{
			super(NAME, new VersionVO());
			
			versionServiceDelegate = new VersionServiceDelegate();
		}
		
		public function get version():VersionVO
		{
			return (getData() as VersionVO);
		}
		
		public function loadVersionInformation():void
		{
			versionServiceDelegate.loadLocalVersionInformation(onLocalVersionLoadSuccess, onLocalVersionLoadFailed);
		}
		
		private function onLocalVersionLoadSuccess(event:Event):void
		{
			var fetchedData:String = event.target["data"];
			if (fetchedData)
			{
				parseVersion(new XML(fetchedData));
			}

			UrlProvider.getInstance().setAppVersion(version.appVersion);
		}
		
		private function onLocalVersionLoadFailed(event:FaultEvent):void
		{			
			UrlProvider.getInstance().setAppVersion("");
		}
		
		private function parseVersion(value:XML):void
		{
			version.appVersion = String(value['version']);
			version.buildDateTime = String(value['build']);
			
			if ((version.appVersion.toLowerCase().indexOf("-snapshot") != -1) || 
				(version.appVersion.indexOf("${pom.version}") != -1))
			{
				version.isDevelopment = false;
				
				// no need of further process
				// in development
				nativeLocator = NativeModelLocator.getInstance(version);
				sendNotification(NOTE_VERSION_INFORMATION_LOADED);
				return;
			}
			
			var tmpArr:Array = version.appVersion.split(".");
			if (tmpArr.length == 3)
			{
				_currentMajor = parseInt(tmpArr[0]);
				_currentMinor = parseInt(tmpArr[1]);
				_currentRevision = parseInt(tmpArr[2]);
			}
		}
		
		private function validateVersion(value:String):void
		{
			var isCurrentVersionObsolete:Boolean;
			
			var tmpSplit:Array = value.split(".");
			var uv1:Number = Number(tmpSplit[0]);
			var uv2:Number = Number(tmpSplit[1]);
			var uv3:Number = Number(tmpSplit[2]);
			
			if (uv1 > _currentMajor) 
			{
				isCurrentVersionObsolete = true;
			}
			else if (uv1 >= _currentMajor && uv2 > _currentMinor) 
			{
				isCurrentVersionObsolete = true;
			}
			else if (uv1 >= _currentMajor && uv2 >= _currentMinor && uv3 > _currentRevision) 
			{
				isCurrentVersionObsolete = true;
			}
			
			if (isCurrentVersionObsolete)
			{
				sendNotification(NOTE_OBSOLETE_CURRENT_VERSION);
			}
		}
	}
}