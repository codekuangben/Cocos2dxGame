package modulecommon.uiinterface
{
	import flash.utils.Dictionary;
	
	import modulecommon.net.msg.chatUserCmd.stChannelChatUserCmd;
	import modulecommon.net.msg.chatUserCmd.stUserChatBaseInfoCmd;

	/**
	 * @brief 这个不是 UI 窗口，仅仅是所有私窗口的管理
	 * */
	public interface IPersonChat
	{
		function openAndAddPChatBuff(dic:Dictionary):void;
		function closePChat(othername:String):void;
		function addPChat(othername:String, data:stChannelChatUserCmd):void;
		function addPChatByCmd(msg:stChannelChatUserCmd):void;
		function openAndAddPChatByBaseInfo(msg:stUserChatBaseInfoCmd):void;
		function updateByAddFnd(charid:uint):void;
		function updateByAddBlack(charid:uint):void;
		function openIFPChat(msg:stChannelChatUserCmd):void;
		function existPChat(name:String):Boolean;
		function updateBaseInfo(msg:stUserChatBaseInfoCmd):void;
		function openHidePChat():void;
		function checkHideNum():void;
		function openPChat():void;
	}
}