package modulecommon.net.msg.zhanXingCmd 
{
	/**
	 * ...
	 * @author ...
	 */
	import flash.utils.ByteArray;
	public class stLocation 
	{
		public static const SBCELLTYPE_NONE:int = 0;
		public static const SBCELLTYPE_MIANPACK:int = 1;
		public static const SBCELLTYPE_LOCKPACK:int = 2;
		public static const SBCELLTYPE_FRONT:int = 3;
		public static const SBCELLTYPE_CENTER:int = 4;
		public static const SBCELLTYPE_BACK:int = 5;
		public var location:uint;		
		public var x:int;
		public var y:int;
		
		public function stLocation(_loc:uint=0, _x:int=0,_y:int=0)
		{
			location = _loc;
			x = _x;
			y = _y;
		}
		public function deserialize(byte:ByteArray):void
		{
			location = byte.readUnsignedInt();
			x = byte.readUnsignedShort();
			y = byte.readUnsignedShort();
		}
		public function serialize(byte:ByteArray):void 
		{
			byte.writeUnsignedInt(location);
			byte.writeShort(x);
			byte.writeShort(y);
		}
	}

}

/*struct stLocation
{
	DWORD location;
		WORD x;
		WORD y;
	}
	//神兵格子类型
enum eShenBingCellType
{
    SBCELLTYPE_NONE = 0,
    SBCELLTYPE_MIANPACK = 1,    //神兵主包裹
    SBCELLTYPE_LOCKPACK = 2,    //不可合成神兵包裹
    SBCELLTYPE_FRONT = 3,       //神兵前军包裹
    SBCELLTYPE_CENTER = 4,      //神兵中军包裹
    SBCELLTYPE_BACK = 5,        //神兵后军包裹
}

	*/