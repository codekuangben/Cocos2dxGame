package modulecommon.scene.prop.table 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class TZhanxingItem extends TDataItem 
	{
		public var m_name:String;
		public var m_color:int;
		public var m_attr:int;
		public var m_icon:String;
		override public function parseByteArray(bytes:ByteArray):void 
		{
			super.parseByteArray(bytes);
			m_name = TDataItem.readString(bytes);
			m_color = bytes.readUnsignedByte();
			m_attr = bytes.readUnsignedByte();
			m_icon = TDataItem.readString(bytes);
		}
		
	}

}