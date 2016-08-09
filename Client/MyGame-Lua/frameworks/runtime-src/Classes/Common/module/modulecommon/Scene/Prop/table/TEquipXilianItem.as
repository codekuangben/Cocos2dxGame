package modulecommon.scene.prop.table 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class TEquipXilianItem extends TDataItem 
	{
		public var m_uplimit:uint;
		public function TEquipXilianItem() 
		{
			
		}
		override public function parseByteArray(bytes:ByteArray):void 
		{
			super.parseByteArray(bytes);
			m_uplimit = bytes.readUnsignedShort();
		}
		
	}

}