package modulecommon.uiinterface
{
	/**
	 * ...
	 * @author 
	 */
	public interface IUILog extends IUIBase
	{
		function addText(str:String):void;
		function clearText():void;
		
		function get fightInterval():Number;		
		function get moveVel():uint;
	}
}