package modulecommon.net.msg.sgQunYingCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stUpdateUserInfoCmd extends stSGQunYingCmd 
	{
		public var m_myRank:uint;
		public var m_group:uint;
		public var m_score:uint;
		public function stUpdateUserInfoCmd() 
		{
			super();
			byParam = PARA_UPDATE_USER_INFO_CMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_myRank = byte.readUnsignedShort();
			m_group = byte.readUnsignedByte();
			m_score = byte.readUnsignedInt();
		}
		
	}

}/*//更新玩家信息
	const BYTE PARA_UPDATE_USER_INFO_CMD = 7;
	struct stUpdateUserInfoCmd : public stSGQunYingCmd
	{
		stUpdateUserInfoCmd()
		{
			byParam = PARA_UPDATE_USER_INFO_CMD;
			myrank = 0;
			group = 0;
			score = 0;
		}
		WORD myrank;	//排名 0 未上榜
		BYTE group;		//分组编号
		DWORD score;	//积分
	};*/