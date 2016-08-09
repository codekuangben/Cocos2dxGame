package modulecommon.net.msg.fndcmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.fndcmd.stFriendCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stHelpFriendIdFriendCmd extends stFriendCmd
	{
		public var m_fndIDs:Vector.<uint>;
		public var m_ret:int;
		
		public function stHelpFriendIdFriendCmd() 
		{
			byParam = PARA_HELP_FRIEND_ID_FRIENDCMD;
			m_fndIDs = new Vector.<uint>(2);
			m_ret = 0;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			
			byte.writeUnsignedInt(m_fndIDs[0]);
			byte.writeUnsignedInt(m_fndIDs[1]);
			byte.writeByte(m_ret);
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			m_fndIDs[0] = byte.readUnsignedInt();
			m_fndIDs[1] = byte.readUnsignedInt();
			m_ret = byte.readUnsignedByte();
		}
	}

}
/*
    //发送玩家选定的好友id（打井npc用) c->s
    const BYTE PARA_HELP_FRIEND_ID_FRIENDCMD = 25;
    struct stHelpFriendIdFriendCmd : public stFriendCmd
    {
        stHelpFriendIdFriendCmd()
        {
            byParam = PARA_HELP_FRIEND_ID_FRIENDCMD;
            ids[0] = ids[1] = 0;
			ret = 0;
        }
        DWORD ids[2];
		BYTE ret;    //0:id可用  1:不可用
    };
*/