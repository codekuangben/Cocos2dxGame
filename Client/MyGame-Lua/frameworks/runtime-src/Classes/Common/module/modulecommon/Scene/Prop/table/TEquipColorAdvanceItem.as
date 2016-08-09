package modulecommon.scene.prop.table 
{
	/**
	 * ...
	 * @author 
	 * 装备颜色提升表
	 * 装备颜色进阶表ID定义：万位表示装备类型, 个百千位表示装备等级
	 */
	import flash.utils.ByteArray;
	public class TEquipColorAdvanceItem extends TDataItem 
	{		
		public var m_materialID1:uint;
		public var m_num1:uint;
		public var m_materialID2:uint;
		public var m_num2:uint;
		public var m_materialID3:uint;
		public var m_num3:uint;
		
		public function TEquipColorAdvanceItem() 
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