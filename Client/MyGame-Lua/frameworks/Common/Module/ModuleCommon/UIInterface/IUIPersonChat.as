package modulecommon.uiinterface
{
	import modulecommon.net.msg.chatUserCmd.stUserChatBaseInfoCmd;
	import modulecommon.net.msg.chatUserCmd.stChannelChatUserCmd;

	public interface IUIPersonChat extends IUIBase
	{
		function appendMsg(str:stChannelChatUserCmd, aligh:uint = 0):void;
		function updateBaseInfo(msg:stUserChatBaseInfoCmd):void;
	}
}