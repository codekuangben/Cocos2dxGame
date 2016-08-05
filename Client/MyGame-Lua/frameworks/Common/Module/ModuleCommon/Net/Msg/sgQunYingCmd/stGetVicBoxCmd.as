package modulecommon.net.msg.sgQunYingCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stGetVicBoxCmd extends stSGQunYingCmd 
	{
		public var m_zhanjiId:uint;
		public function stGetVicBoxCmd() 
		{
			super();
			byParam = PARA_GET_VIC_BOX_CMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_zhanjiId = byte.readUnsignedInt();
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeUnsignedInt(m_zhanjiId);
		}
		
	}
	

}/*	//领取胜利宝箱
	const BYTE PARA_GET_VIC_BOX_CMD = 10;
	struct stGetVicBoxCmd : public stSGQunYingCmd
	{
		stGetVicBoxCmd()
		{
			byParam = PARA_GET_VIC_BOX_CMD;
			zjid = 0;
		}
		DWORD zjid;
	};*/