package modulecommon.scene.prop.table
{
	import flash.utils.ByteArray;

	/**
	 * ...
	 * @大地图配置表 author panqiangqiang
	 */
	public class TWorldmapItem extends TDataItem
	{
		public var name:String;
		public var type:uint;
		public var city_checkpoint:uint;
		public var level:uint;
		public var checkpoint:uint;  
		public var x:uint;
		public var y:uint;
		public var pic:String;
		
		public var strArrowPos:String;	//由3该数字构成（由"-"分隔）.前2个数字表示末端的坐标，最后的数字表示方向，顺时针方向，单位是360制
		public var strOpenFunctions:String;	//2部分组成,有";"分隔。第一部分3该数字构成，表示虚线的方位，第二部分表示功能
		public function TWorldmapItem()
		{
			super();
		}
		override public function parseByteArray(bytes:ByteArray):void
		{
			super.parseByteArray(bytes);
			name = TDataItem.readString(bytes);
			type = bytes.readUnsignedByte();
			city_checkpoint = bytes.readUnsignedInt();
			level = bytes.readUnsignedByte();		
			checkpoint = bytes.readUnsignedByte();
			x = bytes.readUnsignedShort();
			y = bytes.readUnsignedShort();
			pic = TDataItem.readString(bytes);
			
			strOpenFunctions = TDataItem.readString(bytes);
			strArrowPos = TDataItem.readString(bytes);
		}
	}
}