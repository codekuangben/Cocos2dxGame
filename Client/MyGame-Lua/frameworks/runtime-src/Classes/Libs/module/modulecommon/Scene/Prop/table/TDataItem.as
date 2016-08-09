package modulecommon.scene.prop.table 
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class TDataItem 
	{
		public var m_uID:uint;	
		public function parseByteArray(bytes:ByteArray):void
		{
			m_uID = bytes.readUnsignedInt();
		}
		
		public static function readString(bytes:ByteArray):String
		{
			var size:uint = bytes.readUnsignedShort();
			return bytes.readMultiByte(size, EnNet.UTF8);
		}
	}
}