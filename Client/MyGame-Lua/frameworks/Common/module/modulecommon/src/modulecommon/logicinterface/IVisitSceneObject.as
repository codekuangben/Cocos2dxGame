package modulecommon.logicinterface 
{
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public interface IVisitSceneObject 
	{
		function execFunction():void;
		function onPlayerMainArrive():void;
		function get posX():Number;
		function get posY():Number;
		function get isDisposed () : Boolean;
	}
	
}