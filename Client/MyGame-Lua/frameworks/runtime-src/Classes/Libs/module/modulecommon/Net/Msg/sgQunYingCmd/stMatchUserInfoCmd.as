package modulecommon.net.msg.sgQunYingCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stMatchUserInfoCmd extends stSGQunYingCmd 
	{
		public var m_userInfo:MatchUserInfo;
		public function stMatchUserInfoCmd() 
		{
			super();
			byParam = PARA_MATCH_USER_INFO_CMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_userInfo = new MatchUserInfo();
			m_userInfo.deserialize(byte);
		}
		
	}

}/*	//配对玩家信息
	const BYTE PARA_MATCH_USER_INFO_CMD = 6;
	struct stMatchUserInfoCmd : public stSGQunYingCmd
	{
		stMatchUserInfoCmd()
		{
			byParam = PARA_MATCH_USER_INFO_CMD;
		}
		MatchUserInfo matchuser;
	};*/