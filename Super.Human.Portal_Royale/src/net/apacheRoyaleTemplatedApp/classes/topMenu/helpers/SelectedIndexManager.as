package classes.topMenu.helpers
{
	public class SelectedIndexManager 
	{
		private var _source:Array;
		
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
		
		public function SelectedIndexManager(source:Array, selectedIndex:int = -1, subSelectedIndex:int = -1)
		{
			_source = source;
			_currentSource = source;
			_selectedIndex = selectedIndex;
			_subSelectedIndex = subSelectedIndex;
		}
		
		public function calculateNextSelection():Object
		{
			var selection:int = this.selectedIndex;
			var subSelection:int = -1;
			if (_source)
			{
				var selectedItem:Object = _source[this.selectedIndex];
				
				if (selectedItem && selectedItem.children.length > 0)
				{
					if (selectedItem.children.length > this.subSelectedIndex + 1)
					{
						subSelection = this.subSelectedIndex + 1;
					}
					else
					{
						selection = this.getNextSelectedIndex(_source.length, this.selectedIndex);
						subSelection = -1;
					}
				}
				else
				{
					selection = this.selectedIndex + 1;
					if (_source.length - 1 < selection)
					{
						selection = 0;
					}
					
					subSelection = -1;
				}
			}
			
			this.selectedIndex = selection;
			this.subSelectedIndex = subSelection;
			
			return {selectedIndex: this.selectedIndex, subSelectedIndex: this.subSelectedIndex};
		}
		
		public function calculatePreviousSelection():Object
		{
			var selection:int = this.selectedIndex;
			var subSelection:int = -1;
			if (_source)
			{
				var selectedItem:Object = _source[this.selectedIndex];
				
				if (selectedItem && selectedItem.children.length > 0)
				{
					if (this.subSelectedIndex - 1 >= 0)
					{
						subSelection = this.subSelectedIndex - 1;
					}
					else
					{
						selection = this.getPreviousSelectedIndex(this.selectedIndex);
						subSelection = -1; 
					}
				}
				else
				{
					selection = this.selectedIndex - 1;
					if (selection < 0)
					{
						selection = _source.length - 1;
					}
					subSelection = this.getSubSelectionForPreviousStep(selection);
				}
			}
			
			this.selectedIndex = selection;
			this.subSelectedIndex = subSelection;
			
			return {selectedIndex: this.selectedIndex, subSelectedIndex: this.subSelectedIndex};
		}
		
		public function updateSource(source:Array):void
		{
			this._source = source;
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
			
			return 0;
		}
		
		private function getPreviousSelectedIndex(currentSelection:int):int
		{
			var previousSelection:int = currentSelection - 1;
			if (previousSelection > -1)
			{
				return previousSelection;
			}
			
			return _source.length - 1;
		}
		
		private function getSubSelectionForPreviousStep(selection:int):int
		{
			var selectedItem:Object = _source[selection];
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