package game.netmsg.fndcmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.fndcmd.stFriendCmd;
	
	/**
	 * ...
	 * @author ...
	 */
	public class stNotifyFriendRobbedFriendCmd extends stFriendCmd 
	{
		public var friendid:uint;
		public function stNotifyFriendRobbedFriendCmd() 
		{
			super();
			byParam = PARA_NOTIFY_FRIEND_ROBBED_FRIENDCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			friendid = byte.readUnsignedInt();
		}
	}

}

//通知好友宝物被抢
    /*const BYTE PARA_NOTIFY_FRIEND_ROBBED_FRIENDCMD = 34; 
    struct stNotifyFriendRobbedFriendCmd : public stFriendCmd
    {   
        stNotifyFriendRobbedFriendCmd()
        {   
            byParam = PARA_NOTIFY_FRIEND_ROBBED_FRIENDCMD;
            friendid = 0;
        }   
        DWORD friendid;
    }; */ 
