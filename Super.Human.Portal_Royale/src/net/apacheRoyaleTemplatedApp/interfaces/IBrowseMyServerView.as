package interfaces
{
	import classes.breadcrump.Breadcrump;
	import classes.topMenu.TopMenu;
	import model.vo.ServerVO;
	import org.apache.royale.events.IEventDispatcher;

	public interface IBrowseMyServerView extends IResetView
	{
		function get breadcrump():Breadcrump;
		function get topMenu():TopMenu;
		function get selectedItem():ServerVO;
		function set selectedItem(value:ServerVO):void;
		function get openClient():Object;
		function get openNomadWeb():Object;
		function get copyToClipboardServer():IEventDispatcher;
		function get copyToClipboardDatabase():IEventDispatcher;
		function get copyToClipboardReplica():IEventDispatcher;
	}
}