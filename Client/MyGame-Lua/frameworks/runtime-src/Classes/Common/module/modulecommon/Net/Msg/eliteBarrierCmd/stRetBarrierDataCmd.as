package modulecommon.net.msg.eliteBarrierCmd
{
	import flash.utils.ByteArray;

	/**
	 * ...
	 * @author 
	 */
	public class stRetBarrierDataCmd extends stEliteBarrierCmd
	{
		public var m_list:Array;
		public function stRetBarrierDataCmd() 
		{
			byParam = PARA_RET_BARRIER_DATA_CMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			var len:uint;
			len = byte.readUnsignedShort();
			
			m_list = new Array(len);
			var info:stBarrier;
			for (var i:uint = 0; i < len; i++)
			{
				info = new stBarrier(this, i);
				info.deserialize(byte);
				m_list[i] = info;
			}
		}
	}
}

/*
	///返回关卡数据
	const BYTE PARA_RET_BARRIER_DATA_CMD = 2;
	struct stRetBarrierDataCmd : public stEliteBarrierCmd
	{
		stRetBarrierDataCmd()
		{
			byParam = PARA_RET_BARRIER_DATA_CMD;
			num = 0;
		}
		WORD num;
		stBarrier list[0];	//关卡列表
		WORD getSize()
		{
			WORD tempsize = 0;
			for(WORD i = 0; i < num; ++i)
			{
				tempsize += list[i].getSize();
			}

			return (sizeof(*this) + tempsize);
		}
	};
*/
