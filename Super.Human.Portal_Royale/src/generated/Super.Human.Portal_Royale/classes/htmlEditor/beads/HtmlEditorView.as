package Super.Human.Portal_Royale.classes.htmlEditor.beads
{
    import Super.Human.Portal_Royale.classes.htmlEditor.events.HtmlEditorEvent;
    import Super.Human.Portal_Royale.classes.htmlEditor.interfaces.IHtmlEditorModel;

    import org.apache.royale.core.IStrand;
    import org.apache.royale.events.Event;
    import org.apache.royale.html.beads.GroupView;
    import org.apache.royale.html.elements.Div;

	public class HtmlEditorView extends GroupView 
	{
		private var _richTextEditorContainer:Div;
		
		public function HtmlEditorView()
		{
			super();
		}
		
		private var _model:IHtmlEditorModel;
		
		override public function set strand(value:IStrand):void
		{
			super.strand = value;

			_richTextEditorContainer = new Div();	
			_richTextEditorContainer.percentWidth = 100;
			_richTextEditorContainer.percentHeight = 100;
					
			this.host["addElement"](_richTextEditorContainer);
			
			this._model = host["model"] as IHtmlEditorModel;

        	    this._model.addEventListener("optionsChanged", handleOptionsChanged);
        	    this._model.addEventListener("toolbarChanged", toolbarChanged);
		}

		override protected function handleInitComplete(event:Event):void
        	{
        	    this.optionsChanged();
        	    this.toolbarChanged();
        	}  
		
		private function handleOptionsChanged(event:Event):void
		{
			this.optionsChanged();	
		}
		
		private function optionsChanged():void
		{
			window["$"](_richTextEditorContainer.element).dxHtmlEditor({
				value: _model.data,
				readOnly: _model.readOnly,
				onValueChanged: function(event:Object):void {
					_model.data = event.value;
					host.dispatchEvent(new HtmlEditorEvent(HtmlEditorEvent.TEXT_CHANGE, event.value));
				}
			});		
		}

		private function toolbarChanged():void
		{
			var toolbar:Object = _model.toolbar ? _model.toolbar : {};

			toolbar.items = _model.toolbarItems;
			toolbar.multiline = _model.toolbarMultiline;
			
			window["$"](_richTextEditorContainer.element).dxHtmlEditor({
				toolbar: toolbar
			});
		}
	}
}