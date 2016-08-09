package modulecommon.net.msg.copyUserCmd 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	public class stUpdateBoxList extends stCopyUserCmd 
	{
		public var m_itype:int;
		public var m_ibox:int;
		public function stUpdateBoxList() 
		{
			byParam = UPDATE_BOX_LIST;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			m_itype = byte.readUnsignedByte();
			m_ibox = byte.readUnsignedByte();
		}
	}

}

/*
 * //更新宝箱列表
	const BYTE  UPDATE_BOX_LIST = 16;
	struct  stUpdateBoxList: public stCopyUserCmd
	{
		stUpdateBoxList()
		{
			byParam = UPDATE_BOX_LIST;
			bzero(box, MAX_BOX_SIZE);
		}
		BYTE type; //0: 增加一个箱子，  1:删除一个箱子       
		BYTE box; // 0 : 添加宝箱的时候表示颜色值，其余时候表示箱子下标
	};
*/