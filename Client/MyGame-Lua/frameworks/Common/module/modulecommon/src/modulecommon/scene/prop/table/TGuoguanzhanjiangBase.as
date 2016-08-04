package modulecommon.scene.prop.table 
{
	/**
	 * ...
	 * @author 
	 * //过关斩将表
	 */
	import flash.utils.ByteArray;
	public class TGuoguanzhanjiangBase extends TDataItem 
	{
		public var halfing:String;
		public var m_boxTip:String;
		public var m_exp:uint;
		
		override public function parseByteArray(bytes:ByteArray):void
		{
			super.parseByteArray(bytes);
			
			halfing = TDataItem.readString(bytes);
			m_boxTip = TDataItem.readString(bytes);
			m_exp = bytes.readUnsignedInt();
		}
	}

}