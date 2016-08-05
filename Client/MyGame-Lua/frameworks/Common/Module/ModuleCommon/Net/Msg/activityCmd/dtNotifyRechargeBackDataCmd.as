package modulecommon.net.msg.activityCmd 
{
	import flash.utils.ByteArray;
	/**
	 * 累计充值上线数据
	 * @author 
	 */
	public class dtNotifyRechargeBackDataCmd extends stActivityCmd 
	{
		public var m_bTime:uint;
		public var m_dTime:uint;
		public var m_yuanbao:uint;
		public var m_back:uint;
		public function dtNotifyRechargeBackDataCmd() 
		{
			super();
			byParam = DT_NOTIFY_RECHARGE_BACK_DATA_CMD;
			
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_bTime = byte.readUnsignedInt();
			m_dTime = byte.readUnsignedInt();
			m_yuanbao = byte.readUnsignedInt();
			m_back = byte.readUnsignedByte();
		}
	}

}
/*//累计充值上线数据
    const BYTE DT_NOTIFY_RECHARGE_BACK_DATA_CMD = 31; 
    struct dtNotifyRechargeBackDataCmd : public stActivityCmd
    {   
        dtNotifyRechargeBackDataCmd()
        {   
            byParam = DT_NOTIFY_RECHARGE_BACK_DATA_CMD;
            yuanbao = bTime = eTime = 0;
            back =0; 
        }   
        DWORD bTime;	//开始时间
        DWORD dTime; 	//持续时间
        DWORD yuanbao; 	//累计充值
        BYTE back; 		//按位领取
    };  
*/