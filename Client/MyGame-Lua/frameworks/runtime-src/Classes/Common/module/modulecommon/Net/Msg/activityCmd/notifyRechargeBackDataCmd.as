package modulecommon.net.msg.activityCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class notifyRechargeBackDataCmd extends stActivityCmd 
	{
		public var m_yuanbao:uint;
		public var m_back:uint;
		public function notifyRechargeBackDataCmd() 
		{
			super();
			byParam = NOTIFY_RECHARGE_BACK_DATA_CMD;
			
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_yuanbao = byte.readUnsignedInt();
			m_back = byte.readUnsignedByte();
		}
		
	}

}
/*//累计充值上线数据
    const BYTE NOTIFY_RECHARGE_BACK_DATA_CMD = 26; 
    struct notifyRechargeBackDataCmd : public stActivityCmd
    {   
        notifyRechargeBackDataCmd()
        {   
            byParam = NOTIFY_RECHARGE_BACK_DATA_CMD;
            yuanbao = 0;
            back =0; 
        }   
        DWORD yuanbao; //累计充值
        BYTE back; //按位领取
    }; */