package game.ui.uibenefithall.subcom.xianshifangsong.msg 
{
	import modulecommon.net.msg.activityCmd.stActivityCmd;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stReqGetLBSARewardCmd extends stActivityCmd 
	{
		public var m_actid:uint;
		public function stReqGetLBSARewardCmd() 
		{
			super();
			byParam = PARA_REQ_GET_LBSA_REWARD_CMD;
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeShort(m_actid);
		}
	}

}
/*	//请求领取大放送奖励
    const BYTE PARA_REQ_GET_LBSA_REWARD_CMD = 11;
    struct stReqGetLBSARewardCmd : public stActivityCmd
    {
        stReqGetLBSARewardCmd()
        {
            byParam = PARA_REQ_GET_LBSA_REWARD_CMD;
            actid = 0;
        }
        WORD actid;
    };*/