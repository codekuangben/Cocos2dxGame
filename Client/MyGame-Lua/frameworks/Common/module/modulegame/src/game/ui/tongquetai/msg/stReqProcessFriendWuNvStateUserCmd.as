package game.ui.tongquetai.msg 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.wunvCmd.stWuNvCmd;
	
	/**
	 * ...
	 * @author ...
	 */
	public class stReqProcessFriendWuNvStateUserCmd extends stWuNvCmd 
	{
		public var m_friendid:int;
		public var m_tempid:int;
		public var m_state:int;
		public function stReqProcessFriendWuNvStateUserCmd() 
		{
			super();
			byParam = REQ_PROCESS_FRIEND_WU_NV_STATE_USERCMD;
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeUnsignedInt(m_friendid);
			byte.writeUnsignedInt(m_tempid);
			byte.writeByte(m_state);
		}
	}
	

}
/*//请求给某个好友的舞女消除指定状况 c->s
	const BYTE REQ_PROCESS_FRIEND_WU_NV_STATE_USERCMD = 8;
	struct stReqProcessFriendWuNvStateUserCmd : public stWuNvCmd
	{
		stReqProcessFriendWuNvStateUserCmd()
		{
			byParam = REQ_PROCESS_FRIEND_WU_NV_STATE_USERCMD;
			friendid = tempid = 0;
			state = 0;
		}
		DWORD friendid; 
		DWORD tempid;
		BYTE state;
	};*/