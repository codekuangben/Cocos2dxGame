package modulecommon.uiinterface 
{
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public interface IUINpcTalk  extends IUIBase
	{
		function processNpcTalk():void;
		function endNpcTalk():void;
		function setStopExec(flag:Boolean):void;
		function get inTalk():Boolean;
		function onDescActionTimeEnd(strHtml:String):void
	}
	
}