package classes.com.devexpress.js.tileView.interfaces
{
    import org.apache.royale.core.IHasDataProvider;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.core.IFactory;
    import org.apache.royale.core.ISelectionModel;

	public interface ITileViewModel extends IHasDataProvider, IEventDispatcher, ISelectionModel
	{
		function get dataSource():Object;
		function set dataSource(value:Object):void;
		
		function get itemRenderer():IFactory;
		function set itemRenderer(value:IFactory):void;
		
		function get direction():String;
		function set direction(value:String):void;
		
		function get baseItemHeight():Number;
		function set baseItemHeight(value:Number):void;
		
		function get baseItemWidth():Number;
		function set baseItemWidth(value:Number):void;
		
		function get itemMargin():Number;
		function set itemMargin(value:Number):void;
	}
}