package modulecommon.net.msg.activityCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class getRechargeBackRewardCmd extends stActivityCmd 
	{
		public var m_index:uint;
		public function getRechargeBackRewardCmd() 
		{
			super();
			byParam = GET_RECHARGE_BACK_REWARD_CMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_index = byte.readUnsignedByte();
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeByte(m_index);
		}
		
	}

}
/*//请求领取累计充值奖励 c<->s
    const BYTE GET_RECHARGE_BACK_REWARD_CMD = 28;
    struct getRechargeBackRewardCmd : public stActivityCmd
    {
        getRechargeBackRewardCmd()
        {
            byParam = GET_RECHARGE_BACK_REWARD_CMD;
            index =0;
        }
        BYTE index; //第几位 0-6
    };
*/