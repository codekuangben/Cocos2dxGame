package modulecommon.scene.prop.table 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class TExpressionItem extends TDataItem 
	{
		public var m_name:String;
		public var m_expressID:uint;
		override public function parseByteArray(bytes:ByteArray):void 
		{
			super.parseByteArray(bytes);
			m_name = TDataItem.readString(bytes);
			m_expressID = bytes.readByte();
		}
		
	}

}