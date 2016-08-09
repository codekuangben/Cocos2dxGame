package modulecommon.scene.prop.table 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 * @brief 特效基本表   
	 */
	public class TEffBaseItem extends TDataItem 
	{
		public var m_strModel:String;
		
		override public function parseByteArray(bytes:ByteArray):void
		{
			super.parseByteArray(bytes);
			
			m_strModel = TDataItem.readString(bytes);
		}
	}
}