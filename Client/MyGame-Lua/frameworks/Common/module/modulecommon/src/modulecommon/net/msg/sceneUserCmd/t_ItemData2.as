package modulecommon.net.msg.sceneUserCmd 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	public class t_ItemData2 
	{
		public var type:uint;
		public var data1:uint;
		public var data2:uint;
		public function t_ItemData2() 
		{
			
		}
		public function deserialize(byte:ByteArray):void
		{
			type = byte.readUnsignedByte();
			data1 = byte.readUnsignedInt();
			data2 = byte.readUnsignedInt();
		}
		
		/*
		 * 先读取一个字节的整数，表示数据个数
		 * 再读取数据信息
		 */ 
		public static function readWidthNum_Array(byte:ByteArray):Array
		{
			var ret:Array = new Array();
			var num:uint = byte.readUnsignedByte();
			var i:int = 0;
			var data:t_ItemData2;
			
			while (i < num)
			{
				data = new t_ItemData2();
				data.deserialize(byte);
				ret.push(data);
				i++;
			}
			return ret;
		}
	}

}