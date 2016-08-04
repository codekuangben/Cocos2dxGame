package modulefight.netmsg.stmsg 
{
	/**
	 * ...
	 * @author 
	 */
	import datast.ListPart;
	import flash.utils.ByteArray;
	public class stTianFuEffect 
	{
		public var pos:int;
		public var curhp:int;
		public var curshiqi:int;
		public var m_pkValuePart:ListPart;
		public function deserialize(byte:ByteArray):void
		{
			pos = byte.readUnsignedByte();
			curshiqi = byte.readUnsignedByte();
			curhp = byte.readUnsignedInt();			
			
			m_pkValuePart = new ListPart();
			m_pkValuePart.deserialize(byte,PkValue);
		}
	}

}

/*TianfuEffect
{
	BYTE pos;	//十位数表示部队，个位数表示格子编号	
	BYTE curShi;	//本次攻击后，攻击者的士气
	DWORD curHp;	//被攻击者当前血量
	BYTE pkSize;
	PkValue pvs[0];
}*/