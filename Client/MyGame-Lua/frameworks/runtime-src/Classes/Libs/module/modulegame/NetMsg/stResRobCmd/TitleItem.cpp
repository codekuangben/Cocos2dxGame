package game.netmsg.stResRobCmd 
{
	/**
	 * ...
	 * @author ...
	 */
	
	import flash.utils.ByteArray;
	public class TitleItem 
	{
		public var tempid:uint;
		public var title:uint;
		public var zhengying:uint;
		public function deserialize(byte:ByteArray):void 
		{
			tempid = byte.readUnsignedInt();
			title = byte.readUnsignedByte();
			zhengying = byte.readUnsignedByte();
		}
		
	}

}

/*struct TitleItem{
		DWORD tempid;
		BYTE title;  // 0:士兵 1:偏将 2：大将 3：元帅4：秦王
		BYTE zhenying;
	};*/