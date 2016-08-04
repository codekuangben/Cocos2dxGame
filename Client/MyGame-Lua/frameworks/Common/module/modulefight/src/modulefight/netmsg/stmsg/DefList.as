package modulefight.netmsg.stmsg
{
	import datast.ListPart;
	import flash.utils.ByteArray;
	import modulefight.FightEn;
	/**
	 * ...
	 * @author 
	 * @brief 这个是 BattleArray 内部使用的数据结构    
	 */
	public class DefList
	{
		public var pos:uint;
		public var curShi:uint;
		public var curHp:uint;
		public var ref_dam:uint;
		public var bufferid:uint;	//被打断的bufferid
		
		public var pvPart:ListPart;
		public var bufferPart:ListPart;
		
		public function deserialize(byte:ByteArray):void
		{
			pos = byte.readUnsignedByte();
			curShi = byte.readUnsignedByte();
			curHp = byte.readUnsignedInt();
			ref_dam = byte.readUnsignedInt();
			bufferid = byte.readUnsignedShort();
			
			pvPart = new ListPart();
			pvPart.deserialize(byte, PkValue);
		
			bufferPart = new ListPart();
			bufferPart.deserialize(byte, stEntryState);		
		}
	}
}

/*DefList
{
	BYTE pos;	//十位数表示部队，个位数表示格子编号
	BYTE curShi;	//被攻击者士气
	DWORD curHp;	//被攻击者当前血量
	DWORD ref_dam;	//反击伤害
	WORD bufferid; //被打断的bufferid
	BYTE pkSize;
	PkValue pvs[0];
	BYTE stateSize;
	stEntryState[0];
}*/