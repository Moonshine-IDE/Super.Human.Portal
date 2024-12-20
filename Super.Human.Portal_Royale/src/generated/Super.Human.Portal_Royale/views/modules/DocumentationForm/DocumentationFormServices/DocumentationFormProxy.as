package Super.Human.Portal_Royale.views.modules.DocumentationForm.DocumentationFormServices
{
    import Super.Human.Portal_Royale.classes.events.ErrorEvent;
    import Super.Human.Portal_Royale.classes.utils.Utils;
    import Super.Human.Portal_Royale.classes.vo.Constants;
    import Super.Human.Portal_Royale.tasks.DocumentationLoaderTask;
    import Super.Human.Portal_Royale.views.modules.DocumentationForm.DocumentationFormServices.DocumentationFormServices;
    import Super.Human.Portal_Royale.views.modules.DocumentationForm.DocumentationFormVO.DocumentationFormVO;

    import classes.managers.ParseCentral;

    import model.proxy.login.ProxyLogin;
    import model.vo.CategoryVO;

    import org.apache.royale.events.EventDispatcher;
    import org.apache.royale.jewel.Snackbar;
    import org.apache.royale.net.events.FaultEvent;
    import org.apache.royale.utils.async.PromiseTask;
    import model.proxy.ProxySessionCheck;

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
        
        private var _itemsByCategory:Object = {};
        
        public function get itemsByCategory():Object
        {
         	return _itemsByCategory;
        }

        private var _mainItems:Array = [];
        
		[Bindable]
        public function get mainItems():Array
        {
        		return _mainItems;
        }

        public function set mainItems(value:Array):void
        {
        		_mainItems = value;
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
        		var documentationTask:DocumentationLoaderTask = new DocumentationLoaderTask();
        		Utils.setBusy();
        		
        		documentationTask.done(function(task:PromiseTask):void {
        			if (documentationTask.failed)
				{
					Utils.removeBusy();
					if (documentationTask.failedTasks.length == 2)
					{
						onCategoriesListFetchFailed(documentationTask.failedTasks[0].result);
						onDocumentationFormListLoadFailed(documentationTask.failedTasks[1].result);
					}
					else
					{
						onDocumentationFormListLoadFailed(documentationTask.failedTasks[0]);
					}
				}
				else if (documentationTask.completed)
				{
					onCategoriesListFetched(documentationTask.completedTasks[0].result);
					onDocumentationFormListLoaded(documentationTask.completedTasks[1].result);

					buildBreadcrumpModel();
				}
        		});
        		
        		documentationTask.run();
        }
        
        private var _breadcrumpItems:Object = {gettingStarted: {
        				id: "gettingStarted",
        				parent: null,
        				hash: null,
        				label: "Getting Started",
        				visited: -1,
        				icon: "folder_open",
        				data: {},
        				children: []
        			}};

        public function get breadcrumpItems():Object
        {
        		return _breadcrumpItems;
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
                this.dispatchEvent(new Event(EVENT_ITEM_REMOVED));
            }
        }

        private function onDocumentationFormListLoaded(event:Event):void
        {
            Utils.removeBusy();
            var fetchedData:String = event.target["data"];
            if (fetchedData)
            {
                var json:Object = JSON.parse(fetchedData as String);
                var facade:ApplicationFacade = ApplicationFacade.getInstance("SuperHumanPortal_Royale");
			    var sessionProxy:ProxySessionCheck = facade.retrieveProxy(ProxySessionCheck.NAME) as ProxySessionCheck;
			
			    if (json.status == sessionProxy.SESSION_AUTHLIMITEDACCESS)
			    {
			    		items = [];
			    		
			    		this.dispatchEvent(new Event(EVENT_ITEM_UPDATED));
			    }
                else if (!json.errorMessage)
                {				
                    loadConfig();
                        
                    if (("documents" in json) && (json.documents is Array))
                    {
                        items = [];
                        _itemsByCategory = {};
                        for (var i:int=0; i < json.documents.length; i++)
                        {
                            var item:DocumentationFormVO = DocumentationFormVO.getDocumentationFormVO(json.documents[i]);
	                            item.showUnid = this.showUnid;
                            items.push(item);
       						
                             refreshItemsByCategory(item);
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
        
        private function onCategoriesListFetched(event:Event):void
		{
			Utils.removeBusy();
			var fetchedData:String = event.target["data"];
			if (fetchedData)
			{
				var jsonData:Object = JSON.parse(fetchedData);
				var errorMessage:String = jsonData["errorMessage"];
				var facade:ApplicationFacade = ApplicationFacade.getInstance("SuperHumanPortal_Royale");
			    var sessionProxy:ProxySessionCheck = facade.retrieveProxy(ProxySessionCheck.NAME) as ProxySessionCheck;
			
			    if (jsonData.status == sessionProxy.SESSION_AUTHLIMITEDACCESS)
			    {
			    		mainItems = [];
			    }
                else if (errorMessage)
				{
					this.dispatchEvent(
                        new ErrorEvent(
                            ErrorEvent.SERVER_ERROR,
                            errorMessage,
                            ("validationErrors" in jsonData) ? jsonData.validationErrors : null
                        )
                    );
				}
				else
				{
					mainItems = ParseCentral.parseCategoriesList(jsonData.documents);
				}
			}
			else
			{
				this.dispatchEvent(
                        new ErrorEvent(
                            ErrorEvent.SERVER_ERROR,
                            "Getting application's categories list failed.")
                    );
			}
		}
		
		private function onCategoriesListFetchFailed(event:FaultEvent):void
        {
            Utils.removeBusy();
            Snackbar.show("Getting application's categories list failed: " + event.message.toLocaleString(), 8000, null);
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
                    		var docItem:DocumentationFormVO = DocumentationFormVO.getDocumentationFormVO(json.document);
                    		items.push(docItem);
                		
                			refreshItemsByCategory(docItem);
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
                        var removedItems:Array = items.splice(this.selectedIndex, 1);
                        
                        if (removedItems.length > 0)
                        {
							for each (var docItem:DocumentationFormVO in removedItems)
							{
									for each (var cat:String in docItem.Categories)
									{
										var docItems:Array = _itemsByCategory[cat];
										if (docItems)
										{
											for (var i:int = 0; i < docItems.length; i++)
											{
												var doc:Object = docItems[i];
												if (doc.DominoUniversalID == docItem.DominoUniversalID)
												{
													docItems.splice(i, 1);
													break;
												}
											}
										}
									}
							}
							
							buildBreadcrumpModel();
                   		}
                        this.selectedIndex = -1;
                        this.dispatchEvent(new Event(EVENT_ITEM_REMOVED));
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
                
        private function buildBreadcrumpModel():void
        {
        		var breadcrumpItems:Array = [];
        		
        		var bItem:Object = null;
        		for each (var category:CategoryVO in mainItems)
        		{      			
        			bItem = {
        				id: category.id,
        				parent: "gettingStarted",
        				hash: null,
        				label: category.label,
        				visited: -1,
        				icon: category.icon,
        				data: {},
        				children: []
        			};
        			
        			breadcrumpItems.push(bItem.id);
        			_breadcrumpItems[bItem.id] = bItem;
        			
        			var docItems:Array = items.filter(function itemsFilter(element:DocumentationFormVO, index:int, arr:Array):Boolean {
        				return element.containsCategory(category.id);
        			});
        			
        			for each (var dItem:DocumentationFormVO in docItems)
        			{
        				bItem.children.push(dItem.DominoUniversalID);
        				_breadcrumpItems[dItem.DominoUniversalID] = {
        					id: dItem.DominoUniversalID,
						parent: bItem.id,
						hash: null,
						label: dItem.DocumentationName,
						visited: -1,
						icon: null,
						data: dItem,
						children: []
        				};
        			}
        		}
        		
        		_breadcrumpItems.children = breadcrumpItems;	
        }
        
        public function loadConfig():void
        {
      		var facade:ApplicationFacade = ApplicationFacade.getInstance("SuperHumanPortal_Royale");
			var loginProxy:ProxyLogin = facade.retrieveProxy(ProxyLogin.NAME) as ProxyLogin;
			
			if (loginProxy.config)
			{
				this.editable = loginProxy.config.config.ui_documentation_editable && loginProxy.user && loginProxy.user.display.manageDocumentation;
				this.showUnid = loginProxy.config.config.ui_documentation_show_unid;
    			}
        }

        private function refreshItemsByCategory(item:DocumentationFormVO):void
        {
			for each (var cat:String in item.Categories)
			{
				if (!_itemsByCategory[cat])
				{
					_itemsByCategory[cat] = [];
				}
				
				_itemsByCategory[cat].push(item);
			}
        }
	}
}