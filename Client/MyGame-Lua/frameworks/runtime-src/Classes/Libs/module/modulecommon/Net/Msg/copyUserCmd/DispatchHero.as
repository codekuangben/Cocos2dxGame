package modulecommon.net.msg.copyUserCmd
{
	import flash.utils.ByteArray;

	public class DispatchHero
	{
		public var ds:uint;
		public var id:uint;
		
		public function deserialize(byte:ByteArray):void
		{
			ds = byte.readUnsignedByte();
			id = byte.readUnsignedInt();
		}
		
		public function serialize(byte:ByteArray):void
		{
			byte.writeByte(ds);
			byte.writeUnsignedInt(id);
		}
		
		public function copyFrom(rh:DispatchHero):void
		{
			this.ds = rh.ds;
			this.id = rh.id;
		}
		
		public function logInfo():String
		{
			var str:String = "";
			str += ("ds:=" + ds + "; 第0位:" + (ds & 0x01) + "; 后七位:" + (ds >> 1) + "; id:" + id);
			return str;
		}
	}
}

//struct DispatchHero {
//	BYTE ds;  // 第0位 0：武将 1：主角 。 后7位值为位置信息 如 0， 1， 2
//	DWORD id; //武将合成id /charid (武将合成/10 ->武将id)
//};