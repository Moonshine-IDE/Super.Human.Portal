/**
 * VersionVO
 * 
 *
 * Copyright @ - Prominic
 * @author santanu.k
 *
 * @date 06.30.2009
 * @version 0.1
 */
package model.vo {
	
	public class VersionVO {
		
		private var _appVersion: String;
		public function get appVersion():String
		{
			return _appVersion;
		}
		public function set appVersion(value:String):void
		{
			_appVersion = value;
		}

		private var _isDevelopment: Boolean;
		public function get isDevelopment():Boolean
		{
			return _isDevelopment;
		}
		public function set isDevelopment(value:Boolean):void
		{
			_isDevelopment = value;
		}
		
		private var _buildDateTime:String;
		public function get buildDateTime():String
		{
			return _buildDateTime;
		}
		public function set buildDateTime(value:String):void
		{
			_buildDateTime = value;
		}
		
		/**
		 * CONSTRUCTOR
		 */	
		public function VersionVO() 
		{
		}
	}
}