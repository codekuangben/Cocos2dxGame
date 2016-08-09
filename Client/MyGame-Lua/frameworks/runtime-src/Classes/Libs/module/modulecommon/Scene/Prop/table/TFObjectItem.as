package modulecommon.scene.prop.table
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 * @brief 掉落物表   
	 */
	public class TFObjectItem extends TDataItem
	{
		public var m_strModel:String;
		public var m_type:uint;		//0 - 手动拾取；1- 自动拾取
		
		override public function parseByteArray(bytes:ByteArray):void
		{
			super.parseByteArray(bytes);
			
			m_strModel = TDataItem.readString(bytes);
			m_type = bytes.readByte();
		}
	}
}