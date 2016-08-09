package modulecommon.net.msg.activityCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class updateRechargeYuanbaoCmd extends stActivityCmd 
	{
		public var m_yuanbao:uint;
		public function updateRechargeYuanbaoCmd() 
		{
			super();
			byParam = UPDATE_RECHARGE_YUANBAO_CMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_yuanbao = byte.readUnsignedInt();
		}
	}

}
/* //更新累计充值数据
    const BYTE UPDATE_RECHARGE_YUANBAO_CMD = 27; 
    struct updateRechargeYuanbaoCmd : public stActivityCmd
    {   
        updateRechargeYuanbaoCmd()
        {   
            byParam = UPDATE_RECHARGE_YUANBAO_CMD;
            yuanbao = 0;
        }   
        DWORD yuanbao; //累计充值
    };*/