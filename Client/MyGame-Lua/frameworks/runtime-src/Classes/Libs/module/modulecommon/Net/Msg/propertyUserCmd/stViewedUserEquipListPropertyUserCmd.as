package modulecommon.net.msg.propertyUserCmd 
{
	/**
	 * ...
	 * @author 
	 */
	import modulecommon.scene.prop.object.T_Object;
	import flash.utils.ByteArray;
	public class stViewedUserEquipListPropertyUserCmd extends stPropertyUserCmd 
	{
		public var list:Array;
		public function stViewedUserEquipListPropertyUserCmd() 
		{
			byParam = VIEWED_USER_EQUIP_LIST_PROPERTY_USERCMD;
			list = new Array();
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			//var dataSize:uint = byte.readUnsignedInt();
			var num:uint = byte.readUnsignedShort();
			
			var i:uint = 0;
			var tobject:T_Object;
			while (i < num)
			{
				tobject = new T_Object;
				tobject.deserialize(byte);
				list.push(tobject);
				i++;
			}			
		}
	}

}

//被观察者的装备数据
    /*const BYTE VIEWED_USER_EQUIP_LIST_PROPERTY_USERCMD = 16; 
    struct stViewedUserEquipListPropertyUserCmd : public stPropertyUserCmd
    {   
        stViewedUserEquipListPropertyUserCmd()
        {   
            byParam = VIEWED_USER_EQUIP_LIST_PROPERTY_USERCMD;
            size = 0;
        }   
        WORD size;
        t_ObjData data[0];
        WORD getSize() const { return sizeof(*this) + size*(sizeof(t_ObjData) + sizeof(stEquipData)); }
    };  */
