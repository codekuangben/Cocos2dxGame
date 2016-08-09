package modulecommon.net.msg.wunvCmd 
{
	import flash.utils.ByteArray
	/**
	 * ...
	 * @author ...
	 */
	public class stRetProcessFriendWuNvStateUserCmd extends stWuNvCmd 
	{
		public var m_pos:uint;
		public var m_state:uint;
		public function stRetProcessFriendWuNvStateUserCmd() 
		{
			super();
			byParam = RET_PROCESS_FRIEND_WU_NV_STATE_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_pos = byte.readUnsignedByte();
			m_state = byte.readUnsignedByte();
		}
		
	}

}
/*//返回请求给某个好友的舞女消除指定状况 s->c
	const BYTE RET_PROCESS_FRIEND_WU_NV_STATE_USERCMD = 9;
	struct stRetProcessFriendWuNvStateUserCmd : public stWuNvCmd
	{
		stRetProcessFriendWuNvStateUserCmd()
		{
			byParam = RET_PROCESS_FRIEND_WU_NV_STATE_USERCMD;
			pos = state = 0;
		}
		BYTE pos; 
		BYTE state; //被消除的状况
	};*/