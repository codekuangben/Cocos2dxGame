package modulecommon.uiinterface
{
	//import flash.utils.ByteArray;
	import modulecommon.net.msg.chatUserCmd.stChannelChatUserCmd;
	import modulecommon.scene.prop.object.ZObject;
	/**
	 * ...
	 * @author 
	 */
	public interface IUIChat extends IUIBase
	{
		// 直接向输出对话框追加一行显示
		function debugMsg(str:String):void;
		function appendMsg(str:String):void;
		function processChatCmd(cmd:stChannelChatUserCmd):void;
		function exhibitZObject(obj:ZObject):void
		function updateOnCorps():void;
		function moveToLayer(layerID:uint):void
		function moveBackFirstLayer():void
		function addExpression(id:int):void
		function execGMCmd(param:String):void
	}
}