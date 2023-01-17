package classes.com.devexpress.js.dataGrid.beads
{
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.events.Event;
    
	public class TooltipRendererColumn implements IBead
	{
		private var _strand:IStrand;
		private var host:IUIBase;
		
		private var _dataField:String;
		
		public function set dataField(value:String):void
		{
			_dataField = value;	
		}
		
		public function get dataField():String
		{
			return _dataField;	
		}
		
		private var _tooltipText:String;
		
		public function set tooltipText(value:String):void
		{
			_tooltipText = value;
		}
		
		public function set strand(value:IStrand):void
		{
			this._strand = value;
			
			this.host = value as IUIBase;
			this.host.addEventListener("initComplete", onToltipInitComplete);
		}
		
		private function onToltipInitComplete(event:Event):void
		{
			this.host.removeEventListener("initComplete", onToltipInitComplete);
			
			window["$"]("<div/>").dxTooltip({
			        target: window["$"](this.host.element),
			        showEvent: 'mouseenter',
    					hideEvent: 'mouseleave',
			        contentTemplate: function(contentElement:Object):void {
			        		var text:String = _tooltipText ? _tooltipText : host["data"][host["dataField"]];
			            contentElement.append(text);
			        }
		     }).appendTo(window["$"](host.parent["element"]));
		}
	}
}