/**
 * ContactTelephone
 * 
 *
 * Copyright @ - Prominic
 * @author santanu.k
 *
 * @date 04.13.2009
 * @version 0.1
 */
package model.vo {
	
	import org.apache.royale.utils.ObjectUtil;

	[Bindable] 
	public class ContactTelephoneVO 
	{
		
		private var _orderID:int;
		private var _type:String;
		private var _idc:String = "";
		private var _areaCode:String = "";
		private var _phoneNumber:String;
		private var _extentsion:String = "";
		private var _verified:Boolean;
		private var _primary:Boolean;
		private var _isInEditMode:Boolean;
		private var _isDeleteConfirmation:Boolean;
		private var _notes:String = "";
		private var _telToString:String;

		public function ContactTelephoneVO() {
			super();
		}
		
		public function set idc(_typ:String):void {
			_idc = _typ;
			telToString = _idc + _areaCode + _phoneNumber + _extentsion;
		}
		
		public function get idc():String {
			return _idc;
		}
		
		public function set areaCode(_typ:String):void {
			_areaCode = _typ;
			telToString = _idc + _areaCode + _phoneNumber + _extentsion;
		}
		
		public function get areaCode():String {
			return _areaCode;
		}
		
		public function set phoneNumber(_typ:String):void {
			_phoneNumber = _typ;
			telToString = _idc + _areaCode + _phoneNumber + _extentsion;
		}
		
		public function get phoneNumber():String {
			return _phoneNumber;
		}
		
		public function set extentsion(_typ:String):void {
			_extentsion = _typ;
			telToString = _idc + _areaCode + _phoneNumber + _extentsion;
		}
		
		public function get extentsion():String {
			return _extentsion;
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
		
		public function set type(_typ:String):void {
			_type = _typ;
			verified = false;
		}
		
		public function get type():String {
			return _type;
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
		
		public function get notes():String
		{
			return _notes;
		}

		public function set notes(value:String):void
		{
			_notes = value;
		}
		
		public function get telToString():String
		{
			return _telToString;
		}

		public function set telToString(value:String):void
		{
			_telToString = value;
		}
		
		public function toString():String {
			return "&lt;type&gt;"+type+"&lt;/type&gt;&lt;idc&gt;"+idc+"&lt;/idc&gt;&lt;areacode&gt;"+areaCode+"&lt;/areacode&gt;&lt;number&gt;"+phoneNumber+"&lt;/number&gt;&lt;extension&gt;"+extentsion+"&lt;/extension&gt;&lt;notes&gt;"+notes+"&lt;/notes&gt;";
		}
		
		public function deepCopy():ContactTelephoneVO
		{
			var copyObj:ContactTelephoneVO = ObjectUtil.shallowCopy(this, new ContactTelephoneVO()) as ContactTelephoneVO;

			return copyObj;
		}
		
		public function equals(phone:ContactTelephoneVO):Boolean 
		{
			return this.type == phone.type && this.idc == phone.idc && this.areaCode == phone.areaCode &&
				   this.phoneNumber == phone.phoneNumber && this.extentsion == phone.extentsion &&
				   this.verified == phone.verified && this.primary == phone.primary && this.notes == phone.notes;
		}
	}
}