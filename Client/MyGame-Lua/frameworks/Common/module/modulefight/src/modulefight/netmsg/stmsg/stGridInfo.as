package modulefight.netmsg.stmsg 
{
	/**
	 * ...
	 * @author ...
	 */
	import flash.utils.ByteArray;
	public class stGridInfo 
	{
		public var pos:int;
		public var hp:int;
		public var shiqi:int;
		
		public function deserialize(byte:ByteArray):void
		{
			pos = byte.readUnsignedByte();
			hp = byte.readUnsignedInt();
			shiqi = byte.readUnsignedInt();
		}
	}

}

//攻击一次每个格子最后信息(调试信息)
	/*struct stGridInfo
	{
		BYTE pos;	//十位数表示部队，个位数表示格子编号
		DWORD hp;
		DWORD shiqi;
		stGridInfo()
		{
			pos = 0;
			hp = shiqi = 0;
		}
	};*/