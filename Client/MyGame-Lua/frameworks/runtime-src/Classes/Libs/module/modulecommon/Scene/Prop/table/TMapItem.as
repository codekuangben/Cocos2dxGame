package modulecommon.scene.prop.table
{
	import flash.utils.ByteArray;
	/**
	 * @brief 地图配置文件
	 * */
	public class TMapItem extends TDataItem
	{
		public var m_goStartID:uint;	// 地上物列表
		public var m_goEndID:uint;	// 地上物列表
		
		override public function parseByteArray(bytes:ByteArray):void
		{
			super.parseByteArray(bytes);
			// 地上物表,形势是 startid-endid,例如  121-502
			var tmpStr:String;
			var idlst:Array;
			var id:String;
			tmpStr = TDataItem.readString(bytes);
			idlst = tmpStr.split("-");
			m_goStartID = int(idlst[0]);
			m_goEndID = int(idlst[1]);
		}
	}
}