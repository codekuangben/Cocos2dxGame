package modulecommon.net.msg.mountscmd
{
	import flash.utils.ByteArray;
	/**
	 * @brief 
	 */
	public class TypeValue 
	{	
		public var type:uint;
		public var value:uint;
		
		public function deserialize(byte:ByteArray):void
		{
			type = byte.readUnsignedByte();
			value = byte.readUnsignedInt();
		}
	}
}

//struct TypeValue
//{
    //TypeValue():type(0), value(0){}
    //TypeValue(BYTE _t, DWORD _v):type(_t),value(_v){}
    //TypeValue& operator = (const TypeValue& tv) 
    //{   
        //if(this == &tv) return *this;
        //type = tv.type;
        //value = tv.value;
        //return *this;
    //}   
    //BYTE type;
    //DWORD value;
//};