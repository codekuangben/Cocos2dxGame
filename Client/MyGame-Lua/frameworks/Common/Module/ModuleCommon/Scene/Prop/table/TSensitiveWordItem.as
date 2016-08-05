package modulecommon.scene.prop.table 
{
	/**
	 * ...
	 * @author ...
	 */
	import flash.utils.ByteArray;
	
	public class TSensitiveWordItem extends TDataItem 
	{
		public var m_strWord:String;
		
		override public function parseByteArray(bytes:ByteArray):void
		{
			super.parseByteArray(bytes);			
			m_strWord = TDataItem.readString(bytes);
		}
	}

}