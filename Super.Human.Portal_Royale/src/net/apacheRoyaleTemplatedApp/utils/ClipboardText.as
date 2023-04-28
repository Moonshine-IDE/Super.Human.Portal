package utils
{
    
	public class ClipboardText  
	{
		public static function copyToClipboard(text:String):Boolean
		{
			var copied:Boolean = false;
			if (window.clipboardData && window.clipboardData.setData) 
			{
		        copied = window.clipboardData.setData("Text", text);
		
		    }
		    else if (document.queryCommandSupported && document.queryCommandSupported("copy")) 
		    {
		        var textarea:* = document.createElement("textarea");
		        textarea.textContent = text;
		        textarea.style.position = "fixed";  
		        document.body.appendChild(textarea);
		        textarea.select();
		        try 
		        {
		            document.execCommand("copy");  
		            copied = true;
		        }
		        catch (ex) 
		        {
		            console.warn("Copy to clipboard failed.", ex);
		            copied = false;
		        }
	
	            document.body.removeChild(textarea);
		    }
		    
            return copied;
		}
	}
}