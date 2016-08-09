package modulecommon.net.msg.copyUserCmd 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	public class stUpdateRemainingCount extends stCopyUserCmd 
	{
		public var m_iRemainedTimes:int;
		public function stUpdateRemainingCount() 
		{
			byParam = UPDATE_REMAINING_COUNT;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			m_iRemainedTimes = byte.readUnsignedByte();
		}
	}

}

/*
 * //更新剩余探宝次数
	const BYTE  UPDATE_REMAINING_COUNT = 14;
	struct  stUpdateRemainingCount: public stCopyUserCmd
	{
		stUpdateRemainingCount()
		{
			byParam = UPDATE_REMAINING_COUNT;
			remainingCount = 0;
		}
		BYTE remainingCount; //探宝次数
	};
*/