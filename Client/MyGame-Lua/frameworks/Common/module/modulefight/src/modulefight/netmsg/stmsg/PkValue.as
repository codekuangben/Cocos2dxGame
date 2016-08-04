package modulefight.netmsg.stmsg
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class PkValue 
	{
		public var type:uint;	//FightEn.DAM \FightEn.ADD_HP\FightEn.DAM_TYPE_BAOJI\FightEn.DAM_TYPE_GEDANG
		public var value:uint;
		
		public function deserialize(byte:ByteArray):void
		{
			type = byte.readUnsignedByte();
			value = byte.readUnsignedInt();
		}
	}
}

//struct PkValue
//{
	//PkValue(){bzero(this, sizeof(PkValue));}
	//PK_Value_TYPE type;
	//DWORD value;
//};