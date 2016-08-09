package modulecommon.scene.prop.object 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	public class SmallAttrData 
	{
		public static const SIZE:int = 5;
		public var m_type:int;
		public var m_value:int;		
		public function deserialize(byte:ByteArray):void
		{
			m_type = byte.readUnsignedByte();
			m_value = byte.readUnsignedInt();
		}
		public function serialize(byte:ByteArray):void
		{
			byte.writeByte(m_type);
			byte.writeUnsignedInt(m_value);		
		}
		public function clone():SmallAttrData
		{
			var ret:SmallAttrData = new SmallAttrData();
			ret.m_type = this.m_type;			
			ret.m_value = this.m_value;
			return ret;
		}
		
		
	}

}

/*
///装备小属性
    struct SmallAttrData
    {
        BYTE type;  //小属性类型    
        DWORD value;    //小属性数值       
    };  
*/