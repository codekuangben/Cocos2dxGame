package modulecommon.scene.prop.table
{
	import flash.utils.ByteArray;

	public class TMusicItem extends TDataItem
	{
		public var m_name:String;		// 对应的音效的名字
		
		override public function parseByteArray(bytes:ByteArray):void
		{
			super.parseByteArray(bytes);
			m_name = TDataItem.readString(bytes);
		}
	}
}