package classes.stream
{
    import org.apache.royale.net.URLBinaryLoader;

	public class URLBinaryLoaderWithCorsCredentials extends URLBinaryLoader 
	{
		public function URLBinaryLoaderWithCorsCredentials()
		{
			super();
		}
		
		override protected function createStream():void
		{
			this.stream = new URLStreamWithCorsCredentials();
		}
	}
}