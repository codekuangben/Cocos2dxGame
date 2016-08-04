package game.ui.tongquetai.msg 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.wunvCmd.stWuNvCmd;
	
	/**
	 * ...
	 * @author ...
	 */
	public class stReqFriendWuNvDancingUserCmd extends stWuNvCmd 
	{
		public var m_id:int;
		public function stReqFriendWuNvDancingUserCmd() 
		{
			super();
			byParam = REQ_FRIEND_WU_NV_DANCING_USERCMD;
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeUnsignedInt(m_id);
		}
	}

}
/*//请求某个好友宴会跳舞界面信息 c->s
	const BYTE REQ_FRIEND_WU_NV_DANCING_USERCMD = 6;
	struct stReqFriendWuNvDancingUserCmd : public stWuNvCmd
	{
		stReqFriendWuNvDancingUserCmd()
		{
			byParam = REQ_FRIEND_WU_NV_DANCING_USERCMD;
			id = 0;
		}
		DWORD id; //好友id
	};*/