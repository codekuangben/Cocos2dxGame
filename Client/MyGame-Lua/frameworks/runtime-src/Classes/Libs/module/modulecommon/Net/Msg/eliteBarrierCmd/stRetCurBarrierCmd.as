package modulecommon.net.msg.eliteBarrierCmd
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.eliteBarrierCmd.stEliteBarrierCmd;

	/**
	 * ...
	 * @author readUnsignedShort
	 */
	public class stRetCurBarrierCmd extends stEliteBarrierCmd
	{
		public var curbarrier:uint;
		public function stRetCurBarrierCmd() 
		{
			byParam = PARA_RET_CUR_BARRIER_CMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			curbarrier = byte.readUnsignedShort();
		}
		
		public function getCurBarrier():uint
		{
			return curbarrier;
		}
	}

}

/*
	//请求进入关卡
	const BYTE PARA_RET_CUR_BARRIER_CMD = 3;
	struct stRetCurBarrierCmd : public stEliteBarrierCmd
	{
		stRetCurBarrierCmd()
		{
			byParam = PARA_RET_CUR_BARRIER_CMD;
			curbarrier = 0;
		}
		WORD curbarrier;	//玩家当前通过的关卡id
	};
*/