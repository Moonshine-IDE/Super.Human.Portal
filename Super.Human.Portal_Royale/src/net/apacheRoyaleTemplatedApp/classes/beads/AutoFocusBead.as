package classes.beads
{
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.jewel.DropDownList;
    import org.apache.royale.jewel.TextInput;

	public class AutoFocusBead implements IBead 
	{
		private var _strand:IStrand;
		
		private var host:UIBase;
		
		private var _autoFocus:Boolean;

		public function set autoFocus(value:Boolean):void
		{
			if (_autoFocus != value)
			{
				_autoFocus = value;
				refreshAutoFocus();
			}
		}
		
		public function set strand(value:IStrand):void
        {
			_strand = value;
			
			host = value as UIBase;
			if (host && isAllowedComponent() && host.element)
			{
				refreshAutoFocus();
			}
        }
		
		private function refreshAutoFocus():void
		{
			if (!host || !isAllowedComponent()) return;
		
			host.element["autofocus"] = _autoFocus;
			if (_autoFocus)
			{
				host.element.focus();
			}
			else
			{
				host.element.blur();
			}
		}		
		
		private function isAllowedComponent():Boolean
		{
			if (!host) return false;
			
			if (host is TextInput || host is DropDownList)
			{
				return true;
			}
			
			return false;
		}
	}
}