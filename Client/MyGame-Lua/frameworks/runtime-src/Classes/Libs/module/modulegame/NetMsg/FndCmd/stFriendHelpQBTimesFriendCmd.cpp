package game.netmsg.fndcmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.fndcmd.stFriendCmd;
	
	/**
	 * ...
	 * @author ...
	 */
	public class stFriendHelpQBTimesFriendCmd extends stFriendCmd 
	{
		public var times:int;
		public function stFriendHelpQBTimesFriendCmd() 
		{
			super();
			byParam = PARA_FRIEND_HELP_QBTIMES_FRIENDCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			times = byte.readUnsignedByte();
		}
		
	}

}


//好友帮助自己的抢宝的次数
   /* const BYTE PARA_FRIEND_HELP_QBTIMES_FRIENDCMD = 26; 
    struct stFriendHelpQBTimesFriendCmd : public stFriendCmd
    {   
        stFriendHelpQBTimesFriendCmd()
        {   
            byParam = PARA_FRIEND_HELP_QBTIMES_FRIENDCMD;
            times = 0;
        }   
        BYTE times;
    };*/