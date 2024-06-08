package Super.Human.Portal_Royale.views.modules.DocumentationForm.DocumentationFormServices
{
    import Super.Human.Portal_Royale.classes.events.ErrorEvent;
    import Super.Human.Portal_Royale.classes.utils.Utils;
    import Super.Human.Portal_Royale.classes.vo.Constants;
    import Super.Human.Portal_Royale.views.modules.DocumentationForm.DocumentationFormServices.DocumentationFormServices;
    import Super.Human.Portal_Royale.views.modules.DocumentationForm.DocumentationFormVO.DocumentationFormVO;

    import model.proxy.login.ProxyLogin;

    import org.apache.royale.events.EventDispatcher;
    import org.apache.royale.jewel.Snackbar;
    import org.apache.royale.net.events.FaultEvent;

	public class DocumentationFormProxy extends EventDispatcher
	{
	    public static const EVENT_ITEM_UPDATED:String = "eventItemUpdated";
        public static const EVENT_ITEM_REMOVED:String = "eventItemRemoved";
        public static const EVENT_ITEM_SELECTED:String = "eventItemSelected";

		private var serviceDelegate:DocumentationFormServices = new DocumentationFormServices();
		private var lastEditingItem:DocumentationFormVO;
		
		private static var _instance:DocumentationFormProxy;
        public static function getInstance():DocumentationFormProxy
        {
            if (!_instance)
            {
                _instance = new DocumentationFormProxy();
            }
            return _instance;
        }
        
        public function DocumentationFormProxy()
        {
            if (_instance != null) 
            {
                throw new Error("New Instances Not Possible.", "DocumentationFormProxy");
            }			
            else 
            {
                _instance = this;
            }
        }
        
        private var _editable:Boolean;

        [Bindable]
        public function get editable():Boolean
        {
        		return _editable;
        }
        
        public function set editable(value:Boolean):void
        {
        		_editable = value;
        }
        
        private var _showUnid:Boolean;

        [Bindable]
        public function get showUnid():Boolean
        {
        		return _showUnid;
        }
        
        public function set showUnid(value:Boolean):void
        {
        		_showUnid = value;
        }

        private var _items:Array = new Array();
        
        [Bindable]
        public function get items():Array
        {
            return _items;
        }
        public function set items(value:Array):void
        {
            _items = value;
        }
        
        private var _selectedIndex:int;
        public function get selectedIndex():int
        {
            return _selectedIndex;
        }
        
        public function set selectedIndex(value:int):void
        {
            _selectedIndex = value;
        }

        public function requestItems():void
        {
            if (Constants.AGENT_BASE_URL)
            {
                this.serviceDelegate.getDocumentationFormList(onDocumentationFormListLoaded, onDocumentationFormListLoadFailed);
            }
        }
        
        public function submitItem(value:DocumentationFormVO):void
        {
            // simple in-memory add/update for now
            if (this.selectedIndex != -1)
            {
                this.lastEditingItem = value;
            if (Constants.AGENT_BASE_URL)
            	{
            		Utils.setBusy();
            		this.serviceDelegate.updateDocumentationForm(value.toRequestObject(), onDocumentationFormUpdated, onDocumentationFormUpdateFailed);
            	}
            	else
            	{
            		items[this.selectedIndex] = value;
            		this.dispatchEvent(new Event(EVENT_ITEM_UPDATED));
            	}
            }
            else
            {
                if (Constants.AGENT_BASE_URL)
            	{
            		Utils.setBusy();
            		this.serviceDelegate.addNewDocumentationForm(value.toRequestObject(), onDocumentationFormCreated, onDocumentationFormCreationFailed);
            	}
            	else
            	{
            		items.push(value);
            		this.dispatchEvent(new Event(EVENT_ITEM_UPDATED));
            	}
            }
        }
        
        public function removeItem(value:DocumentationFormVO):void
        {
            var indexOf:int = items.indexOf(value);
            if (indexOf == -1)
            {
                return;
            }

            if (Constants.AGENT_BASE_URL)
            {
                this.selectedIndex = indexOf;
                Utils.setBusy();
                this.serviceDelegate.removeDocumentationForm(
                    {DominoUniversalID: value.DominoUniversalID},
                    onDocumentationFormRemoved,
                    onDocumentationFormRemoveFailed
                );
            }
            else
            {
                items.splice(indexOf, 1);
                this.dispatchEvent(new Event(EVENT_ITEM_UPDATED));
            }
        }

        private function onDocumentationFormListLoaded(event:Event):void
        {
            Utils.removeBusy();
            var fetchedData:String = event.target["data"];
            if (fetchedData)
            {
                var json:Object = JSON.parse(fetchedData as String);
                if (!json.errorMessage)
                {				
                    loadConfig();
                        
                    if (("documents" in json) && (json.documents is Array))
                    {
                        items = [];
                        for (var i:int=0; i < json.documents.length; i++)
                        {
                            var item:DocumentationFormVO = new DocumentationFormVO();
                            items.push(
                                DocumentationFormVO.getDocumentationFormVO(json.documents[i])
                            );
                            item.showUnid = this.showUnid;
                        }
 
                        this.dispatchEvent(new Event(EVENT_ITEM_UPDATED));
                    }
                }
                else
                {
                    this.dispatchEvent(
                        new ErrorEvent(
                            ErrorEvent.SERVER_ERROR,
                            json.errorMessage,
                            ("validationErrors" in json) ? json.validationErrors : null
                        )
                    );
                }
            }
            else
            {
                Snackbar.show("Loading lists of new DocumentationForm failed!", 8000, null);
            }
        }

        private function onDocumentationFormListLoadFailed(event:FaultEvent):void
        {
            Utils.removeBusy();
            Snackbar.show("Loading lists of new DocumentationForm failed!\n"+ event.message.toLocaleString(), 8000, null);
        }
        
        private function onDocumentationFormCreated(event:Event):void
		{
			Utils.removeBusy();
			var fetchedData:String = event.target["data"];
			if (fetchedData)
			{
				var json:Object = JSON.parse(fetchedData as String);
                if (!json.errorMessage)
                {
                    if ("document" in json)
                    {
                        items.push(
                            DocumentationFormVO.getDocumentationFormVO(json.document)
                        );
                    }
                    this.dispatchEvent(new Event(EVENT_ITEM_UPDATED));
                }
                else
                {
                    this.dispatchEvent(
                        new ErrorEvent(
                            ErrorEvent.SERVER_ERROR,
                            json.errorMessage,
                            ("validationErrors" in json) ? json.validationErrors : null
                        )
                    );
                }
			}
			else
			{
				Snackbar.show("Creation of new DocumentationForm failed!", 8000, null);
			}
		}
		
		private function onDocumentationFormCreationFailed(event:FaultEvent):void
		{
			Utils.removeBusy();
			this.dispatchEvent(
                new ErrorEvent(
                    ErrorEvent.SERVER_ERROR,
                    "Creation of new DocumentationForm failed!\n"+ event.message.toLocaleString()
                )
            );
		}

		private function onDocumentationFormUpdated(event:Event):void
        {
            Utils.removeBusy();
            var fetchedData:String = event.target["data"];
            if (fetchedData)
            {
                var json:Object = JSON.parse(fetchedData as String);
                if (!json.errorMessage)
                {
                    if (this.selectedIndex > -1 && this.lastEditingItem)
                    {
                        this.items[this.selectedIndex] = this.lastEditingItem;
                    }
                    this.dispatchEvent(new Event(EVENT_ITEM_UPDATED));
                }
                else
                {
                    this.lastEditingItem = null;
                    this.dispatchEvent(
                        new ErrorEvent(
                            ErrorEvent.SERVER_ERROR,
                            json.errorMessage,
                            ("validationErrors" in json) ? json.validationErrors : null
                        )
                    );
                }
            }
            else
            {
                Snackbar.show("Update of new DocumentationForm failed!", 8000, null);
            }
        }

        private function onDocumentationFormUpdateFailed(event:FaultEvent):void
        {
            this.lastEditingItem = null;
            Utils.removeBusy();
            this.dispatchEvent(
                new ErrorEvent(
                    ErrorEvent.SERVER_ERROR,
                    "Update of DocumentationForm failed!\n"+ event.message.toLocaleString()
                )
            );
        }

		private function onDocumentationFormRemoved(event:Event):void
        {
            Utils.removeBusy();
            var fetchedData:String = event.target["data"];
            if (fetchedData)
            {
                var json:Object = JSON.parse(fetchedData as String);
                if (!json.errorMessage)
                {
                    if (selectedIndex > -1)
                    {
                        items.splice(this.selectedIndex, 1);
                        this.selectedIndex = -1;
                        this.dispatchEvent(new Event(EVENT_ITEM_UPDATED));
                    }
                }
                else
                {
                    this.dispatchEvent(
                        new ErrorEvent(
                            ErrorEvent.SERVER_ERROR,
                            json.errorMessage,
                            ("validationErrors" in json) ? json.validationErrors : null
                        )
                    );
                }
            }
            else
            {
                Snackbar.show("Deletion of DocumentationForm failed!", 8000, null);
            }
        }

        private function onDocumentationFormRemoveFailed(event:FaultEvent):void
        {
            Utils.removeBusy();
            this.dispatchEvent(
                new ErrorEvent(
                    ErrorEvent.SERVER_ERROR,
                    "Removal of DocumentationForm failed!\n"+ event.message.toLocaleString()
                )
            );
        }
        
        public function loadConfig():void
        {
      		var facade:ApplicationFacade = ApplicationFacade.getInstance("SuperHumanPortal_Royale");
			var loginProxy:ProxyLogin = facade.retrieveProxy(ProxyLogin.NAME) as ProxyLogin;
			
			if (loginProxy.config)
			{
				this.editable = true;//loginProxy.config.config.ui_documentation_editable;
				this.showUnid = loginProxy.config.config.ui_documentation_show_unid;
    			}
        }
	}
}