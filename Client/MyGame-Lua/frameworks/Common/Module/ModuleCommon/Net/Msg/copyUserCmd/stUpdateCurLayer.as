package modulecommon.net.msg.copyUserCmd 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	public class stUpdateCurLayer extends stCopyUserCmd 
	{
		public var m_ilayer:int;
		public function stUpdateCurLayer() 
		{
			byParam = UPDATE_CUR_LAYER;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			m_ilayer = byte.readUnsignedByte();
		}
	}

}

/*
 * //更新当前层数
	const BYTE  UPDATE_CUR_LAYER = 15;
	struct  stUpdateCurLayer: public stCopyUserCmd
	{
		stUpdateCurLayer()
		{
			byParam = UPDATE_CUR_LAYER;
			layer = 0;
		}
		BYTE layer; 
	};
*/