package modulecommon.scene.prop.table 
{
	/**
	 * ...
	 * @author 
	 * 编号定义
万位：表示装备类型
十、百、千位：表示装备等级
个位：表示装备颜色
	 */
	import flash.utils.ByteArray;
	public class TEquipLevelAdvanceItem extends TDataItem 
	{
		public var m_materialID1:uint;
		public var m_num1:uint;
		public var m_materialID2:uint;
		public var m_num2:uint;
		public var m_materialID3:uint;
		public var m_num3:uint;
		public function TEquipLevelAdvanceItem() 
		{
			
		}
		override public function parseByteArray(bytes:ByteArray):void
		{
			super.parseByteArray(bytes);
			m_materialID1 = bytes.readUnsignedInt();
			m_num1 = bytes.readUnsignedShort();
			m_materialID2 = bytes.readUnsignedInt();
			m_num2 = bytes.readUnsignedShort();
			m_materialID3 = bytes.readUnsignedInt();
			m_num3 = bytes.readUnsignedShort();			
			
		}
	}

}