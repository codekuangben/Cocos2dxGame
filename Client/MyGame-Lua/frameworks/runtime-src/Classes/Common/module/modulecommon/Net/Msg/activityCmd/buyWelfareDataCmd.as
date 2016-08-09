package modulecommon.net.msg.activityCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class buyWelfareDataCmd extends stActivityCmd 
	{
		public var m_type:uint;
		public var m_ret:uint;
		public function buyWelfareDataCmd() 
		{
			super();
			byParam = BUY_WELFARE_DATA_CMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_type = byte.readUnsignedByte();
			m_ret = byte.readUnsignedByte();
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeByte(m_type);
			byte.writeByte(0);
		}
		
	}

}
/*//购买投资福利 c->s->c
    const BYTE BUY_WELFARE_DATA_CMD = 16;
    struct buyWelfareDataCmd : public stActivityCmd
    {
        buyWelfareDataCmd()
        {
            byParam = BUY_WELFARE_DATA_CMD;
            type = ret= 0;
        }
        BYTE type;
        BYTE ret; //0:success, 1:fail
    };*/