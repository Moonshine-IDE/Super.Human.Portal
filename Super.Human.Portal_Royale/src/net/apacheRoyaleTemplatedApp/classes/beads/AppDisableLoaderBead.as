
package classes.beads
{
	import org.apache.royale.html.LoadIndicator;
	import org.apache.royale.utils.PointUtils;
	import org.apache.royale.core.IPopUpHost;
	import org.apache.royale.utils.UIUtils;
	import org.apache.royale.geom.Point;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.html.beads.ShrinkableDisableLoaderBead;
	import org.apache.royale.core.IChild;
	import org.apache.royale.jewel.Label;
	/**
	 *  The AppDisableLoaderBead extends ShrinkableDisableLoaderBead to search parent path for platform of load indicator
	 */
	public class AppDisableLoaderBead extends ShrinkableDisableLoaderBead
	{
		private var _label:Label;
		private var _loaderText:String;
		
		public function get loaderText():String
		{
			return _loaderText;
		}

		public function set loaderText(value:String):void
		{
			_loaderText = value;
			
			if (_label)
			{
				_label.text = value;
			}	
		}
		
        override protected function addLoadIndicator():void
		{
            var platform:IUIBase = getPlatform();
			var point:Point = PointUtils.localToGlobal(new Point(0, 0), platform);
			_loader = new LoadIndicator();
			_loader.width = (platform as IUIBase).width * resizeFactor;
			_loader.height = (platform as IUIBase).height * resizeFactor;
			_loader.x = point.x + (platform as IUIBase).width / 2 - _loader.width / 2;
			_loader.y = point.y + (platform as IUIBase).height / 2 - _loader.height / 2;
			COMPILE::JS
			{
				_loader.element.style.position = "absolute";
			}
			var popupHost:IPopUpHost = UIUtils.findPopUpHost(platform);
			popupHost.popUpParent.addElement(_loader);
			
			_label = new Label();
			_label.element.style.position = "absolute";
			_label.element.style.textAlign = "center";
			_label.element.style.fontWeight = "bold";
			
			_label.height = _loader.height;
			_label.minWidth = _loader.width;
			_label.x = _loader.x;
			_label.y = _loader.y + _loader.height + 10;
			_label.text = loaderText;
							
			popupHost.popUpParent.addElement(_label);
		}
		
		override protected function removeLoadIndicator():void
		{
			super.removeLoadIndicator();
			
			if (_label)
			{
				_label.parent.removeElement(_label);
				this.loaderText = null;
			}
		}

        private function getPlatform():IUIBase
        {
			var currentUiBase:IUIBase = host as IUIBase;
			while (!currentUiBase.width || !currentUiBase.height)
			{
				currentUiBase = ((currentUiBase as IChild).parent) as IUIBase;
			}
			return currentUiBase;
        }
	}
}
