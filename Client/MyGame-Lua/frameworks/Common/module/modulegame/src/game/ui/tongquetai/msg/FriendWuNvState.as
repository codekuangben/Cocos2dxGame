package game.ui.tongquetai.msg 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class FriendWuNvState 
	{
		public var id:uint;
		public var state:uint;
		
		public function deserialize(byte:ByteArray):void
		{
			id = byte.readUnsignedInt();
			state = byte.readUnsignedByte();
		}
		
	}

}
/*	struct FriendWuNvState{
		enum { NONE = 0, MATURE=1, SICK=2, };
		DWORD id; //好友id
		BYTE state; // { NONE = 0, MATURE=1, SICK=2}
	};*/