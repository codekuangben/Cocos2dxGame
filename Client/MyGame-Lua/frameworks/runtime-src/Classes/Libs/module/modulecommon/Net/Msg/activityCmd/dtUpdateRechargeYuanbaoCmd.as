package modulecommon.net.msg.activityCmd 
{
	import flash.utils.ByteArray;
	/**
	 * 更新累计充值元宝
	 * @author 
	 */
	public class dtUpdateRechargeYuanbaoCmd extends stActivityCmd 
	{
		public var m_yuanbao:uint;
		public function dtUpdateRechargeYuanbaoCmd() 
		{
			super();
			byParam = DT_UPDATE_RECHARGE_YUANBAO_CMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_yuanbao = byte.readUnsignedInt();
		}
	}

}
/* //更新累计充值数据
    const BYTE DT_UPDATE_RECHARGE_YUANBAO_CMD = 32; 
    struct dtUpdateRechargeYuanbaoCmd : public stActivityCmd
    {   
        dtUpdateRechargeYuanbaoCmd()
        {   
            byParam = DT_UPDATE_RECHARGE_YUANBAO_CMD;
            yuanbao = 0;
        }   
        DWORD yuanbao; //累计充值
    };  
*/
