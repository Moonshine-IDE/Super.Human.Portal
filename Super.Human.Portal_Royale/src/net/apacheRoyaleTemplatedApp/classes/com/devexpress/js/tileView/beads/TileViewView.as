package classes.com.devexpress.js.tileView.beads
{
    import classes.com.devexpress.js.tileView.TileView;
    import classes.com.devexpress.js.tileView.beads.models.TileViewModel;
    import classes.com.devexpress.js.tileView.events.TileViewEvent;
    import classes.com.devexpress.js.tileView.interfaces.ITileViewModel;

    import org.apache.royale.collections.ArrayList;
    import org.apache.royale.core.IChild;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.html.beads.GroupView;
    import org.apache.royale.jewel.View;
    import org.apache.royale.events.MouseEvent;

	public class TileViewView extends GroupView 
	{
		public function TileViewView()
		{
			super();
		}
		
		private var _model:ITileViewModel;
		private var _tileInstance:Object;

		override public function set strand(value:IStrand):void
	    {
	        super.strand = value;
	        
	        this._model = (host as TileView).model as ITileViewModel;
	        
	        window["$"](host.element).dxTileView({});
    			_tileInstance = window["$"](host.element).dxTileView("instance");
	        _tileInstance.option({
	        		onItemClick: function onItemClick(event:Object):void {
	        			host["selectedIndex"] = event.itemIndex;
	        			host["selectedItem"] = event.itemData;
	        			
					host.dispatchEvent(new TileViewEvent(TileViewEvent.CLICK_ITEM, event.itemData, event.itemIndex));
				},
				onDisposing: function onDisposing(element:Object, component:Object):void {
					var e:Object = element;
				}});

	        this._model.addEventListener("dataProviderChanged", handleDataProviderChanged);
	        this._model.addEventListener("itemRendererChanged", handleItemRendererChanged);
	        this._model.addEventListener("optionsChanged", handleOptionsChanged);
	        this._model.addEventListener("refreshChangedDataProvider", handleDataProviderChanged);
        }
        
        	protected function handleDataProviderChanged(event:Event):void
		{
			dpChanged();
		}
		
		protected function handleItemRendererChanged(event:Event):void
		{
			itemRendererChanged();
		}
		
		private function handleOptionsChanged(event:Event):void
		{
			optionsChanged();
		}
			
		private function dpChanged():void
		{
			var dp:Object;
			
			if (!(_model as TileViewModel).dataSource)
			{
				if (this._model.dataProvider is ArrayList) 
				{
					dp = this._model.dataProvider.source;
				}			
				else
				{
					dp = this._model.dataProvider as Array;
				}			
			}
			else
			{
				dp = (_model as TileViewModel).dataSource;
			}
		
			_tileInstance.beginUpdate();
			this.optionsChanged();
			this.itemRendererChanged();

	        _tileInstance.option({dataSource: dp});
	        _tileInstance.endUpdate();
		}
		
		private function itemRendererChanged():void
		{
			_tileInstance.option({
				itemTemplate: function itemTemplate(itemData:Object, itemIndex:int, itemElement:Object):void {
					var renderer:Object = _model.itemRenderer.newInstance();
						renderer.index = itemIndex;
						
					var div:View = new View();

					renderer.data = itemData;
					renderer.addEventListener(MouseEvent.DOUBLE_CLICK, function onItemDoubleClick(event:MouseEvent):void {
						host.dispatchEvent(new TileViewEvent(TileViewEvent.DOUBLE_CLICK_ITEM, _model.selectedItem, _model.selectedIndex));
					});
					div.addElement(renderer as IChild);	
					itemElement.append(div.element);
			}});
		}
		
		private function optionsChanged():void
		{
			_tileInstance.option({
				showScrollbar: _model.showScrollbar,
				height: "100%",
				width: "100%",				
				baseItemWidth: _model.baseItemWidth,
				baseItemHeight: _model.baseItemHeight,
				itemMargin: _model.itemMargin,
				noDataText: _model.noDataText,
				direction: _model.direction
			});
		}
	}
}