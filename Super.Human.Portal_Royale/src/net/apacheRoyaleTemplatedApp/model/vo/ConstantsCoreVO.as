package model.vo
{
	import org.apache.royale.collections.ArrayList;

	public class ConstantsCoreVO
	{
		public static const MYDETAILS_CATS_AL:ArrayList = new ArrayList(["Personal Information", "Mailing Address(es)", "E-mail Account(s)", "Phone Number(s)"]);
		public static const IMTYPES:ArrayList = new ArrayList( ["Select your IM", "AOLIM", "GTalk", "Skype", "MSN", "Yahoo!"] );
		public static const CREDIT_CARD_TYPES:ArrayList = new ArrayList(["American Express", "Discover", "MasterCard", "Visa"]);
		public static const BUSY_INDICATOR_SCALE_FACTOR:Number = .1;
	}
}