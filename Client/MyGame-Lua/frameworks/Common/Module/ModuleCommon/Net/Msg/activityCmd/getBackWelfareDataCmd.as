package modulecommon.net.msg.activityCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class getBackWelfareDataCmd extends stActivityCmd 
	{
		public var m_type:uint;
		public var m_ret:uint;
		public function getBackWelfareDataCmd() 
		{
			super();
			byParam = GET_BACK_WELFARE_DATA_CMD;
			
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
/* //领取投资福利元宝 c->s->c
    const BYTE GET_BACK_WELFARE_DATA_CMD = 17;
    struct getBackWelfareDataCmd : public stActivityCmd
    {
        getBackWelfareDataCmd()
        {
            byParam = GET_BACK_WELFARE_DATA_CMD;
            type = ret= 0;
        }
        BYTE type;
        BYTE ret; //0:success, 1:fail
    };*/