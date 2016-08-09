package modulecommon.net.msg.giftCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class GiftItem 
	{
		public var id:uint;
		public var num:uint;
		public var upgrade:uint;
		
		public function deserialize(byte:ByteArray):void
		{
			id = byte.readUnsignedInt();
			num = byte.readUnsignedInt();
			upgrade = byte.readUnsignedByte();
		}
	}
}

//struct GiftItem
//{
	//DWORD id;
	//DWORD num;
	//BYTE upgrade;
//};