package modulecommon.scene.prop.table 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class TTianfuXiaoguoItem extends TDataItem 
	{
		public var m_xiaoguo:int;
		public function TTianfuXiaoguoItem() 
		{
			
		}
		
		override public function parseByteArray(bytes:ByteArray):void 
		{
			super.parseByteArray(bytes);
			m_xiaoguo = bytes.readUnsignedShort();
		}
		
	}

}