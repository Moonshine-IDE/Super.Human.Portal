package view.bookmarks.event
{
    import org.apache.royale.events.Event;

	public class AppImprovementReqEvent extends Event 
	{
		public static const APP_IMPROVEMENT_REQ:String = "appImprovementReq";
		 
		public function AppImprovementReqEvent(type:String)
		{
			super(type);
		}
	}
}