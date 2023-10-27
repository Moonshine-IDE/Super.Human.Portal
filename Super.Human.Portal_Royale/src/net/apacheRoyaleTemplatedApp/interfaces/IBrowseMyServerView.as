package interfaces
{
	import classes.breadcrump.Breadcrump;
	import classes.topMenu.TopMenu;

	public interface IBrowseMyServerView extends IResetView
	{
		function get breadcrump():Breadcrump;
		function get topMenu():TopMenu;
	}
}