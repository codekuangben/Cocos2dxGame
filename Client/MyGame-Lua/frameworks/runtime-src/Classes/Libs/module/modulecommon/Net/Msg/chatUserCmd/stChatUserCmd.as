package modulecommon.net.msg.chatUserCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import common.net.msg.basemsg.stNullUserCmd;
	import common.net.endata.EnNet;
	public class stChatUserCmd  extends stNullUserCmd
	{
		public static const CHANNEL_CHAT_USERCMD_PARAMETER:uint = 1;
		public static const WORDPROMPT_USERCMD_PARAMETER:uint = 2;
		public static const NPC_AI_CHAT_USERCMD:uint = 3;
		public static const PARA_USER_CHAT_BASEINFO_USERCMD:uint = 4;
		public static const PARA_REQ_CHAT_USERINFO_USERCMD:uint = 5;
		public static const PARA_RET_CHAT_USERINFO_USERCMD:uint = 6;
		
		public function stChatUserCmd() 
		{
			super();
			byCmd = CHAT_USERCMD;
		}
		
	}

}