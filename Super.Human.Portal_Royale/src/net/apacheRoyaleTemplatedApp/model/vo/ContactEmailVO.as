/**
 * ContactEmail
 * 
 *
 * Copyright @ - Prominic
 * @author santanu.k
 *
 * @date 04.13.2009
 * @version 0.1
 */
package model.vo 
{
	
	import org.apache.royale.utils.ObjectUtil;

	[Bindable] public class ContactEmailVO {
		
		private var _orderID:int;
		private var _email:String;
		private var _verified:Boolean;
		private var _primary:Boolean;
		private var _isInEditMode:Boolean
		private var _isDeleteConfirmation:Boolean;
		
		public function ContactEmailVO() {
			super();
		}
		
		public function set email(value:String):void {
			_email = value;
		}
		
		public function get email():String {
			return _email;
		}
		
		public function set orderID(_oid:int):void {
			_orderID = _oid;
		}
		
		public function get orderID():int {
			return _orderID;
		}
		
		public function set verified(_vrf:Boolean):void {
			_verified = _vrf;
		}
		
		public function get verified():Boolean {
			return _verified;
		}
		
		public function set primary(_prm:Boolean):void {
			_primary = _prm;
		}
		
		public function get primary():Boolean {
			return _primary;
		}
		
		public function set isInEditMode(_prm:Boolean):void {
			_isInEditMode = _prm;
		}
		
		public function get isInEditMode():Boolean {
			return _isInEditMode;
		}
		
		public function set isDeleteConfirmation(_prm:Boolean):void {
			_isDeleteConfirmation = _prm;
		}
		
		public function get isDeleteConfirmation():Boolean {
			return _isDeleteConfirmation;
		}
		
		public function deepCopy():ContactEmailVO
		{
			var copyObj:ContactEmailVO = ObjectUtil.shallowCopy(this, new ContactEmailVO()) as ContactEmailVO;

			return copyObj;
		}
		
		public function equals(email:ContactEmailVO):Boolean 
		{
			return this.email == email.email && this.primary == email.primary && 
				   this.orderID == email.orderID && this.verified == email.verified;	
		}
	}
}