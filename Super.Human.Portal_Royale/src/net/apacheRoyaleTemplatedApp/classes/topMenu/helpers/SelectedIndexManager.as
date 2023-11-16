package classes.topMenu.helpers
{
	public class SelectedIndexManager 
	{
		private var model:Object;
		
		private var _currentSource:Array;
		private var _currentSubSource:Array;
		
		private var _selectedIndex:int;

		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		public function set selectedIndex(value:int):void
		{
			_selectedIndex = value;
		}
		
		private var _subSelectedIndex:int;

		public function get subSelectedIndex():int
		{
			return _subSelectedIndex;
		}

		public function set subSelectedIndex(value:int):void
		{
			_subSelectedIndex = value;
		}
		
		public function SelectedIndexManager(model:Object, rootMenuDataProvider:Object, subMenuDataProvider:Object, selectedIndex:int = -1, subSelectedIndex:int = -1)
		{
			this.model = model;
			_currentSource = rootMenuDataProvider ? rootMenuDataProvider.source : [];
			_currentSubSource = subMenuDataProvider ? subMenuDataProvider.source : [];
			_selectedIndex = selectedIndex;
			_subSelectedIndex = subSelectedIndex;
		}
		
		public function calculateNextSelection():Object
		{
			var selection:int = this.selectedIndex;
			var selectedItem:Object = null;
			var subSelection:int = -1;
			if (_currentSource)
			{
				selectedItem = _currentSource[this.selectedIndex];
				
				if (selectedItem && selectedItem.children.length > 0)
				{
					if (selectedItem.children.length > this.subSelectedIndex + 1)
					{
						subSelection = this.getNextSelectedIndex(selectedItem.children.length, this.subSelectedIndex);
					}
					else
					{
						selection = this.getNextSelectedIndex(_currentSource.length, this.selectedIndex);
						subSelection = -1;
					}
				}
				else
				{
					selection = this.getNextSelectedIndex(_currentSource.length, this.selectedIndex);
					subSelection = -1;
				}
			}
			
			var navigateToParent:Object = null;
			if (selection == -1 && subSelection == -1)
			{
				navigateToParent = model[selectedItem.parent];
			}
			
			this.selectedIndex = selection;
			this.subSelectedIndex = subSelection;
	
			return {selectedIndex: this.selectedIndex, subSelectedIndex: this.subSelectedIndex, navigateToParent: navigateToParent};
		}
		
		public function calculatePreviousSelection():Object
		{
			var selection:int = this.selectedIndex;
			var selectedItem:Object = null;
			var subSelection:int = -1;
			if (_currentSource)
			{
				selectedItem = _currentSource[this.selectedIndex];
				
				if (selectedItem && selectedItem.children.length > 0)
				{
					if (this.subSelectedIndex - 1 >= 0)
					{
						subSelection = this.getPreviousSelectedIndex(this.subSelectedIndex);
					}
					else
					{
						selection = this.getPreviousSelectedIndex(this.selectedIndex);
						subSelection = -1; 
					}
				}
				else
				{
					selection = this.getPreviousSelectedIndex(this.selectedIndex);
					subSelection = this.getPreviousSelectedIndex(this.subSelectedIndex);
				}
			}
			
			var navigateToParent:Object = null;
			if (selection == -1 && subSelection == -1)
			{
				navigateToParent = model[selectedItem.parent];
			}
			
			this.selectedIndex = selection;
			this.subSelectedIndex = subSelection;
			
			return {selectedIndex: this.selectedIndex, subSelectedIndex: this.subSelectedIndex, navigateToParent: navigateToParent};
		}
		
		public function updateSource(source:Array):void
		{
			this._currentSource = source;
		}
		
		public function getSubSelectedIndex():int
		{
			return -1;	
		}
		
		public function refreshSelectedIndex(selectedIndex:int, subSelectedIndex:int):void
		{
			this.selectedIndex = selectedIndex;
			this.subSelectedIndex = subSelectedIndex;
		}
		
		private function getNextSelectedIndex(sourceLength:int, currentSelection:int):int
		{
			var nextSelection:int = currentSelection + 1;
			if (sourceLength > nextSelection)
			{
				return nextSelection;
			}
			
			return -1;
		}
		
		private function getPreviousSelectedIndex(currentSelection:int):int
		{
			var previousSelection:int = currentSelection - 1;
			if (previousSelection > -1)
			{
				return previousSelection;
			}
			
			return -1;
		}
		
		private function getSubSelectionForPreviousStep(selection:int):int
		{
			var selectedItem:Object = _currentSource[selection];
			var subSelection:int = 0;
			if (selectedItem.children)
			{
				if (selectedItem.children.length > 0)
				{
					subSelection = selectedItem.children.length - 1;
				}
			}
			return subSelection;
		}
	}
}