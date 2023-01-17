package classes.stream
{
    import org.apache.royale.net.URLStream;

	public class URLStreamWithCorsCredentials extends URLStream 
	{
		public function URLStreamWithCorsCredentials()
		{
			super();
		}
		
		override protected function createXmlHttpRequest():void
		{
			super.createXmlHttpRequest();
			
			xhr.withCredentials = true;
		}
	}
}