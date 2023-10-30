package interfaces
{
	import classes.breadcrump.Breadcrump;
	import classes.topMenu.TopMenu;
	import model.vo.ServerVO;

	public interface IBrowseMyServerView extends IResetView
	{
		function get breadcrump():Breadcrump;
		function get topMenu():TopMenu;
		function get selectedItem():ServerVO;
		function set selectedItem(value:ServerVO):void;
	}
}