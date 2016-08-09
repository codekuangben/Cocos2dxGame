package modulecommon.scene.prop.table
{
	import flash.utils.ByteArray;

	// 强化上限
	public class TEnchUpperItem extends TDataItem
	{
		public var m_upperLimit:uint;	// 等级上限
		
		override public function parseByteArray(bytes:ByteArray):void
		{
			super.parseByteArray(bytes);
			m_upperLimit = bytes.readUnsignedShort();
		}
	}
}