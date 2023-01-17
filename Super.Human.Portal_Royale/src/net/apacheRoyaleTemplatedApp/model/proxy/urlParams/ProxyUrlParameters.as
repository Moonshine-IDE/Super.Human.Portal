package model.proxy.urlParams
{
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	public class ProxyUrlParameters extends Proxy
	{
		public static const NAME:String = "ProxyUrlParameters";

		public function ProxyUrlParameters()
		{
			super(NAME);
		}
		
		public function get hasTarget():Boolean
		{
			return this.data && this.data["params"].hasOwnProperty("target");
		}
		
		public function get target():Object
		{
			if (!this.hasTarget) return null;
			
			return this.data["params"]["target"];
		}
		
		public function get component():String
		{
			if (!this.data) return null;
			
			return this.data["component"];
		}
		
		public function get hasParams():Boolean 
		{
			return this.data && this.data.hasOwnProperty("params");	
		}		
		
		public function get params():Object 
		{
			if (!this.hasParams) return null;
			
			return this.data["params"];	
		}		
		
		public function get isForgotPassword():Boolean
		{
			if (!this.data) return false;
			
			return this.data["params"].hasOwnProperty("target") && 
				   this.data["params"]["target"] == "ForgotPassword";
		}
		
		public function get isPasswordReset():Boolean
		{
			if (!this.data) return false;
			
			return this.data["params"].hasOwnProperty("target") && 
				   this.data["params"]["target"] == "PasswordReset" && 
				   this.data["params"].hasOwnProperty("code") && 
				   this.data["params"].hasOwnProperty("email");
		}
		
		public function get isRegister():Boolean 
		{
			if (!this.data) return false;
			
			return this.data["params"].hasOwnProperty("target") && 
				   this.data["params"]["target"] == "Register";
		}			
			
		public function cleanParams():void
		{
			if (!hasParams) return;
			
			if (this.data.hasOwnProperty("params"))
			{
				this.data["params"] = {};
			}
			
			if (this.data.hasOwnProperty("component"))
			{
				this.data["component"] = null;
			}
		}
	}
}