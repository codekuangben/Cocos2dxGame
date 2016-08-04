package modulecommon.net.msg.eliteBarrierCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stReqBarrierDataCmd extends stEliteBarrierCmd 
	{
		public var m_hasdata:int;
		public function stReqBarrierDataCmd() 
		{
			byParam = PARA_REQ_BARRIER_DATA_CMD;
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeByte(m_hasdata);
		}
		
		public function set hasData(value:int):void
		{
			m_hasdata = value;
		}
	}

}

///请求关卡数据
	/*const BYTE PARA_REQ_BARRIER_DATA_CMD = 1;
	struct stReqBarrierDataCmd : public stEliteBarrierCmd
	{
		stReqBarrierDataCmd()
		{
			byParam = PARA_REQ_BARRIER_DATA_CMD;
		}
		BYTE hasdata;	//0-没有数据 1-有数据
	};*/