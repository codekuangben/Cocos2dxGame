package modulecommon.net.msg.propertyUserCmd 
{
	/**
	 * ...
	 * @author ...
	 */
	import flash.utils.ByteArray;
	public class SortItem 
	{
		public var thisID:uint;
		public var location:uint;
		public var x:uint;
		public var y:uint;
		public var num:uint;
		public function deserialize(byte:ByteArray):void
		{
			thisID = byte.readUnsignedInt();
			location = byte.readByte();
			x = byte.readByte();
			y = byte.readByte();
			num = byte.readUnsignedShort();
		}
		
	}

}

/*struct SortItem {
		DWORD thisid;
		BYTE location;
		BYTE x;
		BYTE y;
		WORD num;
	};*/