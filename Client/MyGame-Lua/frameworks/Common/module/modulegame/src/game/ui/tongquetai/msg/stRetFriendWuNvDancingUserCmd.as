package game.ui.tongquetai.msg 
{
	import flash.utils.ByteArray
	import flash.utils.Dictionary;
	import modulecommon.net.msg.wunvCmd.stWuNvCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stRetFriendWuNvDancingUserCmd extends stWuNvCmd 
	{
		public var m_id:uint;
		public var m_data:Dictionary;
		public function stRetFriendWuNvDancingUserCmd() 
		{
			super();
			byParam = RET_FRIEND_WU_NV_DANCING_USERCMD;
			
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_data = new Dictionary();
			var i:int
			m_id = byte.readUnsignedInt();
			var size:uint = byte.readUnsignedByte();
			var data:FriendDancingWuNv;
			for (i = 0; i < size; i++ )
			{
				data = new FriendDancingWuNv();
				data.deserialize(byte);
				m_data[data.pos] = data;
			}
		}
	}

}
/*//返回请求某个好友宴会跳舞界面信息 s->c
	const BYTE RET_FRIEND_WU_NV_DANCING_USERCMD = 7;
	struct stRetFriendWuNvDancingUserCmd : public stWuNvCmd
	{
		stRetFriendWuNvDancingUserCmd()
		{
			byParam = RET_FRIEND_WU_NV_DANCING_USERCMD;
		}
		DWORD id; //好友id
		BYTE size;
		FriendDancingWuNv data[0];
		WORD getSize( void ) const { return sizeof(*this) + sizeof(FriendDancingWuNv)*size; }
	};*/