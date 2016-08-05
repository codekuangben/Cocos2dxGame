package modulecommon.scene.prop.table
{
	import flash.geom.Point;
	import flash.utils.ByteArray;

	/**
	 * @brief 地上物,地上物只能显示一个面,类似 npc 流程
	 * */
	public class TGroundObjectItem extends TDataItem
	{
		public var m_strModel:String;		// object id 就是 c121
		public var m_pos:Point;

		override public function parseByteArray(bytes:ByteArray):void
		{
			super.parseByteArray(bytes);
			m_strModel = TDataItem.readString(bytes);
			m_pos = new Point();
			m_pos.x = bytes.readUnsignedInt();
			m_pos.y = bytes.readUnsignedInt();
		}
	}
}