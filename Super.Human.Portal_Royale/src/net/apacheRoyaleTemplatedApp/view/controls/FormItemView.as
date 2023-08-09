package view.controls
{
    import org.apache.royale.core.IChild;
    import org.apache.royale.core.IContainerBaseStrandChildrenHost;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.core.ValuesManager;
    import org.apache.royale.events.Event;
    import org.apache.royale.html.util.getModelByType;
    import org.apache.royale.jewel.beads.controls.TextAlign;
    import org.apache.royale.jewel.beads.models.FormItemModel;
    import org.apache.royale.jewel.beads.views.FormItemView;

	public class FormItemView extends org.apache.royale.jewel.beads.views.FormItemView
	{
		public function FormItemView()
		{
			super();
		}
		
		private var textLabelCreated:Boolean;
		private var requiredLabelCreated:Boolean;
		
		/**
         *  @copy org.apache.royale.core.IBead#strand
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         *  @royaleignorecoercion org.apache.royale.core.UIBase
         *  @royaleignorecoercion org.apache.royale.core.IBeadLayout
         *  @royaleignorecoercion org.apache.royale.core.IChild
         *  @royaleignorecoercion org.apache.royale.core.IViewport
         */
        override public function set strand(value:IStrand):void
		{
			_strand = value;

            model = getModelByType(_strand, FormItemModel) as FormItemModel;
			model.addEventListener("textChange", textChangeHandler);
			model.addEventListener("htmlChange", textChangeHandler);
            model.addEventListener("requiredChange", requiredChangeHandler);

            if (!contentArea)
            {
                var cls:Class = ValuesManager.valuesImpl.getValue(_strand, "iFormItemContentArea");
                // add the layout bead to the content area.
                if (cls)
                {
                    contentArea = new cls() as UIBase;
                }
                else
                {
                    setupContentAreaLayout();
                }
				
				if (model["fullContentWidth"])
				{
					contentArea.percentWidth = 100;
				}
            }

            createLabels();
            addLabels();

			if (contentArea.parent == null) {
				(_strand as IContainerBaseStrandChildrenHost).$addElement(contentArea as IChild);
			}

            setupLayout();
		}
		
		override public function textChangeHandler(event:Event):void
		{
			createLabels();
			addLabels();
				
			super.textChangeHandler(event);			
		}		
		
		override public function requiredChangeHandler(event:Event):void
		{
			createLabels();
			addLabels();
			
			super.requiredChangeHandler(event);	
		}
		
		protected function addLabels():void
        {
            if (textLabel && !textLabelCreated)
            {
                (_strand as IContainerBaseStrandChildrenHost).$addElementAt(textLabel, 0);
				textLabelCreated = true;
            }

            if (requiredLabel != null && requiredLabel.parent == null && !requiredLabelCreated)
            {
				var requiredLabelIndex:int = model.text ? 1 : 0;
                (_strand as IContainerBaseStrandChildrenHost).$addElementAt(requiredLabel, requiredLabelIndex);
				requiredLabelCreated = true;
            }
        }
		
		protected function createLabels():void
		{
			if (textLabel == null && model.text) 
			{
                textLabel = createLabel(model.text);
                textLabel.multiline = true;
                textLabel.className = model["labelClass"];
            }

            if (textLabel != null && textLabel.parent == null) 
			{
                textLabelAlign = new TextAlign();
                textLabelAlign.align = model.labelAlign;
                textLabel.addBead(textLabelAlign);
            }

            if (requiredLabel == null && model.required) 
			{
                requiredLabel = createLabel("*");
                requiredLabel.className = "required";
            }
		}
	}
}