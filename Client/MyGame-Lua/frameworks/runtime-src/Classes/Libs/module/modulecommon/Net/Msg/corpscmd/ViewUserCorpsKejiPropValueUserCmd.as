package modulecommon.net.msg.corpscmd 
{
	import flash.utils.ByteArray;
	import modulecommon.scene.prop.relation.KejiLearnedItem;
	/**
	 * ...
	 * @author ...
	 */
	public class ViewUserCorpsKejiPropValueUserCmd extends stCorpsCmd
	{
		public var m_list:Array;
		public function ViewUserCorpsKejiPropValueUserCmd() 
		{
			byParam = VIEW_USER_CORPS_KEJI_PROP_VALUE_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			
			var size:uint = byte.readUnsignedByte();
			m_list = KejiLearnedItem.readWidthNum_Array(byte, size);
		}
	}

}

/*
//观察玩家军团科技信息
    const BYTE VIEW_USER_CORPS_KEJI_PROP_VALUE_USERCMD = 97;
    struct ViewUserCorpsKejiPropValueUserCmd : public stCorpsCmd
    {    
        ViewUserCorpsKejiPropValueUserCmd()
        {    
            byParam = VIEW_USER_CORPS_KEJI_PROP_VALUE_USERCMD;
        }    
        BYTE size; 
        TypeValue tv[0]; //类型:值
        WORD getSize()const { return sizeof(*this) + size*sizeof(TypeValue); }

    };   
*/