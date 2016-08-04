package modulefight.netmsg.stmsg 
{
	/**
	 * ...
	 * @author 
	 */
	import datast.ListPart;
	import flash.utils.ByteArray;
	public class stTianFuData 
	{
		public var pos:int;
		public var m_effPart:ListPart;
		
		public function deserialize(byte:ByteArray):void
		{
			pos = byte.readUnsignedByte();
			m_effPart = new ListPart();
			m_effPart.deserialize(byte, stTianFuEffect);
		}
	}
}

/*stTianfu
{
	BYTE pos;	//十位数表示部队，个位数表示格子编号
	BYTE size
	TianfuEffect tianfuEffect[0];	
}*/