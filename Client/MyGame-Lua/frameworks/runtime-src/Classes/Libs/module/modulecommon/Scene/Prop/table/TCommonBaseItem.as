package modulecommon.scene.prop.table 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	public class TCommonBaseItem extends TDataItem 
	{
		public var m_value:String;
		override public function parseByteArray(bytes:ByteArray):void
		{
			super.parseByteArray(bytes);			
			m_value = TDataItem.readString(bytes);		
		}
		
	}

}