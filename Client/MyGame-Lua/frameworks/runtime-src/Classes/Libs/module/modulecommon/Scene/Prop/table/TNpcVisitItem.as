package modulecommon.scene.prop.table
{
	/**
	 * ...
	 * @author 
	 * @brief 基本属性项    
	 */
	import flash.utils.ByteArray;	
	public class TNpcVisitItem extends TDataItem
	{		
		public var m_name:String;	
		public var m_iType:int;
		public var m_cursor:int;
		public var m_iLevel:int;
		public var m_strModel:String;
		override public function parseByteArray(bytes:ByteArray):void
		{
			super.parseByteArray(bytes);
			
			m_name = TDataItem.readString(bytes);
			m_iType = bytes.readShort();		
			m_cursor = bytes.readUnsignedByte();
			m_iLevel = bytes.readShort();
			m_strModel = TDataItem.readString(bytes);
		}
	}
}