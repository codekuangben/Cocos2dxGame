package game.ui.uibenefithall.msg 
{
	import flash.utils.ByteArray;
	/**
	 * @brief
	 */
	public class RewardBackValue 
	{
		public var type:uint;
		public var ybValue:uint;
		public var freeValue:uint;
		
		public function deserialize(byte:ByteArray):void
		{
			type = byte.readUnsignedInt();
			ybValue = byte.readUnsignedInt();
			freeValue = byte.readUnsignedInt();
		}
	}
}

//struct RewardBackValue {
	//DWORD type; //值类型参考 MoneyType,不在其中的则为道具id, -1 表示经验
	//DWORD ybValue;  //元宝找回数量
	//DWORD freeValue; //免费找回时数量
//};