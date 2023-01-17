package classes.locator
{
	import model.vo.VersionVO;

	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.events.EventDispatcher;
	
	/**
	 * NativeModelLocator
	 * 
	 * Copyright @ - Prominic.NET
	 * @author santanu.k
	 * @date 06.21.2012
	 * @version 1.0
	 */
	[Bindable] 
	public dynamic class NativeModelLocator extends EventDispatcher
	{
		
		//--------------------------------------------------------------------------
		//
		//  PRIVATE STATIC
		//
		//--------------------------------------------------------------------------
		
		private static var instance:NativeModelLocator;
		
		/**
		 * CONSTRUCTOR
		 */
		public function NativeModelLocator()
		{
			if (instance != null) 
			{
				throw new Error( "New Instances Not Possible.", "NativeModelLocator" );
			}			
			else 
			{
				instance = this;
			}
		}
		
		/**
		 * Returns the Singleton Instance
		 */
		public static function getInstance(version:VersionVO = null) : NativeModelLocator 
		{	
			if (instance == null) 
			{
				instance = new NativeModelLocator();
			}
			
			if (version)
			{
				instance.isDevelopment = version.isDevelopment;
			}

			return instance;
		}
		
		//--------------------------------------------------------------------------
		//
		//  PUBLIC VARIABLES
		//	USES IN THE ALLOVER APPLICATION
		//	AREAS
		//
		//--------------------------------------------------------------------------
		
		public var countriesAC:ArrayList;
		public var timezoneAC:ArrayList;
		public var addressBillingAC:ArrayList;
		public var accountsAC:ArrayList;
		public var updateCreditCardNotAllowedMessage:String;
		
		public var isDevelopment:Boolean;		
	}
}