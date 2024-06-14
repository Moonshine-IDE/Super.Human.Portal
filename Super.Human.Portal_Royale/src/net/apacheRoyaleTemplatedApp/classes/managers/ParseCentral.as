package classes.managers
{	
	import classes.locator.NativeModelLocator;

	import model.vo.AccountVO;
	import model.vo.ApplicationVO;
	import model.vo.BookmarkVO;
	import model.vo.CountriesDataModelVO;
	import model.vo.GenesisDirVO;

	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.utils.StringUtil;

	import utils.UtilsCore;
	import model.vo.ServerVO;
	import model.vo.CategoryVO;
	
	/**
	 * ParseCentral
	 * 
	 * Copyright @ - Prominic.NET
	 * @author santanu.k
	 * @date 07.02.2012
	 * @version 1.0
	 */
	public class ParseCentral
	{
		private static var appModelLocator:NativeModelLocator = NativeModelLocator.getInstance();
		
		//--------------------------------------------------------------------------
		//
		//  PUBLIC STATIC API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Countries data parse
		 * 
		 * @return Boolean
		 */
		public static function parseCountries(xmlData:XML, outArr:ArrayList = null):Boolean {
			
			// parsing
			var outCountries:ArrayList = outArr;
			if (!outArr)
			{
				outCountries = new ArrayList();
				appModelLocator.countriesAC = outCountries;
			}						
			
			var viewEntry:XMLList = xmlData..viewentry;
			var viewEntryCount:int = viewEntry.length();
			
			for (var i:int = 0; i < viewEntryCount; i++)
			{
				var c:XML = viewEntry[i];
				if (c)
				{
					var tmpRegion:ArrayList = new ArrayList();
					var entryData:XMLList = c..entrydata;
					var entryDataCount:int = entryData.length();
					
					for (var j:int = 0; j < entryDataCount; j++)
					{
						var r:XML = entryData[j];
						if (r)
						{
							// multi-threading as some Country doesn't has <textlist> in its 
							// Region nodes but only direct <text> node.
							if ( r.@name == "countryRegions" ) 
							{
								var textEntry:XMLList = r..text;
								var textEntryCount:int = textEntry.length();
								
								for (var k:int = 0; k < textEntryCount; k++)
								{
									var n:XML = textEntry[k];
									if (n)
									{
										if (n.valueOf().toString() != "") 
										{
											tmpRegion.addItem(n.toString());
										}
									}
								}
							}
						}
					}
					var country : CountriesDataModelVO = new CountriesDataModelVO (
						int( c.@position ),
						String( c.entrydata.( @name=="countryName" ).text ),
						String( c.entrydata.( @name=="countryCode" ).text ),
						String( c.entrydata.( @name=="countryIDC" ).text ),
						tmpRegion
					);
					
					outCountries.addItem(country);
				}
			}
			
			// finally
			return true;
		}
		
		/**
		 * Parse the dynamic URLs data
		 *
		 * @return Boolean
		 */
		public static function parseAppConfig( xmlData:XML ) : Boolean {
			
			var urlProvider:UrlProvider = UrlProvider.getInstance();

			// server mapped agent URL setup
			urlProvider.logoutUser = getURLbetweenProductionAndTest(xmlData.form.( @id == "LOGOUT_USER" ));
			urlProvider.accountsdataurl = getURLbetweenProductionAndTest(xmlData.form.( @id == "ACCOUNTSDATAURL" ));

			urlProvider.accountsposturl = getURLbetweenProductionAndTest(xmlData.form.( @id == "NewAccountRequest" ));
			
			return true;
		}
		
		/**
		 * Parsing Native specific config data
		 *
		 * required
		 * XML
		 */
		public static function parseNativeConfig( xmlData:XML ) : void {
			
			// ssh forwarding ports
			var portsProvider:PortsProvider = PortsProvider.getInstance();
			portsProvider.sshForwdPortMin = Number(xmlData.SSHForwarding.ForwardingPortMin);
			portsProvider.sshForwdPortMax = Number(xmlData.SSHForwarding.ForwardingPortMax);
			portsProvider.sshForwdPortPresent = portsProvider.sshForwdPortMin - 1;
		}
		
		/**
		 * Accounts data parse
		 * 
		 * @return Boolean
		 */
		public static function parseAccounts( xmlData:XML ) : Boolean {
			
			appModelLocator.accountsAC = new ArrayList();
			var tempArrayForCustomerID:Array = [];
			var tempArrayForCustomerName:Array = [];
			var tempRolesArr:Array = [];
			var tmpCloseAccountArr:Array = [];
			var tmpAllowUpdateCCAccountArr:Array = [];	
			var tmpAllowNet30:Array = [];
			var tmpVBoxAvaibalityArr:Array = [];
			var tmpAutoInstallAvaibalityArr:Array = [];
			var tmpVMNebulaAccessArr:Array = [];
			
			// Customer ID
			var i:int;
			var viewEntries:XMLList = xmlData..document.item.( @name == "CustomerID" );
			var viewEntryCount:int = viewEntries.length();
			var viewEntry:XML;
			for (i = 0; i < viewEntryCount; i++)
			{
				viewEntry = viewEntries[i];
				tempArrayForCustomerID.push( String(viewEntry.text) );
				// close account notifier check
				var tmpXML : XML = viewEntry.parent();
				tmpCloseAccountArr.push( ( tmpXML.item.(@name == "CustomerID_AllowFlexCloseAccount") != undefined ) ? tmpXML.item.(@name == "CustomerID_AllowFlexCloseAccount").text : "" );
				tmpVMNebulaAccessArr.push( (tmpXML.item.(@name == "CustomerID_AllowVMNebulaAccess") != undefined ) ? tmpXML.item.(@name == "CustomerID_AllowVMNebulaAccess").text : "" );
				tmpAllowUpdateCCAccountArr.push( (tmpXML.item.(@name == "AllowUpdateCreditCard") != undefined ) ? tmpXML.item.(@name == "AllowUpdateCreditCard").text : "" );
				tmpAllowNet30.push( (tmpXML.item.(@name == "AllowNet30") != undefined ) ? tmpXML.item.(@name == "AllowNet30").text : "" );
			}
			
			// Customer Account Name
			viewEntries = xmlData..document.item.( @name == "CustomerID_AccountName" );
			viewEntryCount = viewEntries.length();
			for (i = 0; i < viewEntryCount; i++)
			{
				viewEntry = viewEntries[i];
				tempArrayForCustomerName.push( String(viewEntry.text) );
			}
			
			// Access Lists
			viewEntries = xmlData..document.item.( @name == "CustID_AccessList" )..text;
			viewEntryCount = viewEntries.length();
			for (i = 0; i < viewEntryCount; i++)
			{
				viewEntry = viewEntries[i];
				if (StringUtil.trim(viewEntry).length != 0) tempRolesArr.push( String(viewEntry) );
			}
			
			// vBOX avaibality
			viewEntries = xmlData..document.item.( @name == "CustomerID_AllowVBoxHosts" )..text;
			viewEntryCount = viewEntries.length();
			for (i = 0; i < viewEntryCount; i++)
			{
				viewEntry = viewEntries[i];
				tmpVBoxAvaibalityArr.push( String(viewEntry) );
			}
			
			// autoInstall avaibality
			viewEntries = xmlData..document.item.( @name == "CustomerID_AllowAutoinstallAccess" )..text;
			viewEntryCount = viewEntries.length();
			for (i = 0; i < viewEntryCount; i++)
			{
				viewEntry = viewEntries[i];
				tmpAutoInstallAvaibalityArr.push( String(viewEntry) );
			}
			
			// AccountVO creation
			for ( var customer:String in tempArrayForCustomerID ) {
				
				var tmpRoles : String = "";
				var tmpCommaCheck : Boolean = false;
				for ( var role:String in tempRolesArr ) {
					
					if ( tempRolesArr[role].substring( 0, 6 ) == tempArrayForCustomerID[customer] ) {
						if ( tmpCommaCheck ) tmpRoles += ", ";
						tmpRoles += tempRolesArr[role].substring( 7, tempRolesArr[role].length );
						tmpCommaCheck = true;
					}
				}
				
				var tmpAccount : AccountVO = new AccountVO(
					appModelLocator.accountsAC.length+1,
					tempArrayForCustomerID[customer],
					tempArrayForCustomerName[customer],
					"",
					""
				);
				
				tmpAccount.roles = tmpRoles;
				tmpAccount.isVBOXavailable = ( tmpVBoxAvaibalityArr[customer] == "true" ) ? true : false;
				tmpAccount.isAutoInstallAvailable = ( tmpAutoInstallAvaibalityArr[customer] == "true" ) ? true : false;
				tmpAccount.isCloseAccountEnabled = ( tmpCloseAccountArr[customer] == "true" ) ? true : false;
				tmpAccount.isVMNebulaAccess = ( tmpVMNebulaAccessArr[customer] == "true" ) ? true : false;
				tmpAccount.isUpdateCreditCardEnabled = ( tmpAllowUpdateCCAccountArr[customer] == "true" ) ? true : false;
				tmpAccount.isAllowNet30 = ( tmpAllowNet30[customer] == "true" ) ? true : false;
				
				appModelLocator.accountsAC.addItem( tmpAccount ); 
			}

			UtilsCore.sortItems(appModelLocator.accountsAC.source, "displayLabel");
			// finally
			return true;
		}
		
		/**
		 * Parse genesis application catalog list
		 *
		 * @return Array
		 */
		public static function parseGenesisCatalogList(jsonData:Array):Array 
		{
			var tmpArr:Array = [];
			
			var viewEntryCount:int = jsonData.length;
			
			for (var i:int = 0; i < viewEntryCount; i++)
			{
				var app:Object = jsonData[i];
				var tmpVO:ApplicationVO = new ApplicationVO(app.AppID, app.DetailsURL, app.Label, app.InstallCommand, app.Installed, app.InstallTimeS, app.access, app.directory);
				
				tmpArr.push(tmpVO);
			}
			
			UtilsCore.sortItems(tmpArr, "label");
			return tmpArr;
		}
		
		/**
		 * Parse genesis private dirs list
		 *
		 * @return Array
		 */
		public static function parseGenesisPrivDirsList(jsonData:Array):Array 
		{
			var tmpArr:Array = [];
			
			var viewEntryCount:int = jsonData.length;
			
			for (var i:int = 0; i < viewEntryCount; i++)
			{
				var privateDir:Object = jsonData[i];
				var tmpVO:GenesisDirVO = new GenesisDirVO(privateDir.DominoUniversalID, privateDir["private"] == "true", privateDir.label, privateDir.url);
				
				tmpArr.push(tmpVO);
			}
			
			UtilsCore.sortItems(tmpArr, "label");
			return tmpArr;
		}
		
		/**
		 * Parse Custom bookmarks list
		 *
		 * @return Array
		 */
		public static function parseCustomBookmarksList(jsonData:Array):Array 
		{
			var tmpArr:Array = [];
			
			var viewEntryCount:int = jsonData.length;
			
			for (var i:int = 0; i < viewEntryCount; i++)
			{
				var bookmark:Object = jsonData[i];
				var tmpVO:BookmarkVO = new BookmarkVO(bookmark.group, bookmark.DominoUniversalID, bookmark.name,
																 bookmark.server, bookmark.database, bookmark.view,
																 bookmark.type, bookmark.url, bookmark.nomadURL, bookmark.defaultAction, bookmark.description);
				
				tmpArr.push(tmpVO);
			}

			return tmpArr;
		}
		
		public static function parseDatabases(databases:Array):Array
		{
			var folders:Array = [];
			var nonFolders:Array = [];
			
			var viewEntryCount:int = databases.length;
			
			for (var i:int = 0; i < viewEntryCount; i++)
			{
				var db:Object = databases[i];
				var bookmarks:Array = parseCustomBookmarksList(db.bookmarks);
				
				var tmpVO:ServerVO = new ServerVO(db.name, db.type, db.url, db.nomadURL, db.server, db.database, 
												 db.view, db.replicaID, db.hasBookmarks, db.bookmarkCount, bookmarks);
				folders.push(tmpVO);
			}
			
			return folders;
		}
		
		/**
		 * Parse genesis application catalog list
		 *
		 * @return Array
		 */
		public static function parseCategoriesList(jsonData:Array):Array 
		{
			var tmpArr:Array = [];
			
			var viewEntryCount:int = jsonData.length;
			
			for (var i:int = 0; i < viewEntryCount; i++)
			{
				var cat:Object = jsonData[i];
				var tmpVO:CategoryVO = new CategoryVO(cat.DominoUniversalID, cat.CategoryID, cat.Description,
													 Number(cat.Order), cat.Label, cat.Icon);
				
				tmpArr.push(tmpVO);
			}
			
			UtilsCore.sortItems(tmpArr, "order", false, true);
			
			return tmpArr;
		}
		
		//--------------------------------------------------------------------------
		//
		//  PRIVATE STATIC API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Returns between production and test
		 * URLs as returns by the server
		 * 
		 * @return String
		 */
		private static function getURLbetweenProductionAndTest(value:XMLList):String
		{
			if (appModelLocator.isDevelopment)
			{
				return value.test_mode.post_url.toString();
			}
			
			return value.prod_mode.post_url.toString()
		}
		
		/**
		 * Returns between production and test
		 * URLs as returns by the server
		 * (Note: Differnce between general-config nodes)
		 * 
		 * @return String
		 */
		private static function getURLbetweenProductionAndTestForNative(value:XMLList):String
		{
			if (appModelLocator.isDevelopment)
			{
				return value.test_mode.url.toString();
			}
			
			return value.prod_mode.url.toString()
		}
		
		/**
		 * Returns upload-field-id between 
		 * production and test
		 * URLs as returns by the server
		 * 
		 * @return String
		 */
		private static function getUploadFieldbetweenProductionAndTest(value:XMLList):String
		{
			if (appModelLocator.isDevelopment)
			{
				return value.test_mode.file_upload_control_id.toString();
			}
			
			return value.prod_mode.file_upload_control_id.toString()
		}
	}
}