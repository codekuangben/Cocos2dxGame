package game.ui.uibenefithall.msg
{
	import flash.utils.ByteArray;
	/**
	 * @brief
	 */
	public class RewardBackItem
	{
		public var type:uint;
		public var count:uint;
		public var yuanbao:uint;
		public var size:uint;
		public var data:Vector.<RewardBackValue>;
		
		public function deserialize(byte:ByteArray):void
		{
			type = byte.readUnsignedByte();
			count = byte.readUnsignedByte();
			yuanbao = byte.readUnsignedInt();
			size = byte.readUnsignedByte();
			
			data = new Vector.<RewardBackValue>();
			var item:RewardBackValue;
			var idx:uint;
			while (idx < size)
			{
				item = new RewardBackValue();
				item.deserialize(byte);
				data.push(item);
				
				++idx;
			}
		}
	}
}

//struct RewardBackItem {
	//BYTE type; //功能类型 
	//BYTE count; //未领取次数
	//DWORD yuanbao; //找回这个功能的奖励所需元宝
	//BYTE size;
	//RewardBackValue data[0];
//};