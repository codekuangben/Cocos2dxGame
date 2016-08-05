package modulecommon.net.msg.propertyUserCmd 
{
	import modulecommon.scene.prop.object.T_Object;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stGmAddUserObjListPropertyUserCmd extends stPropertyUserCmd 
	{
		public var list:Array;
		public function stGmAddUserObjListPropertyUserCmd() 
		{
			super();
			byParam = GM_ADDUSEROBJECT_LIST_PROPERTY_USERCMD;
			list = new Array();
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			var dataSize:uint = byte.readUnsignedInt();
			var num:uint = byte.readUnsignedShort();
			
			var i:uint = 0;
			var tobject:T_Object;
			while (i < num)
			{
				tobject = new T_Object();
				tobject.deserialize(byte);
				list.push(tobject);
				i++;
			}			
		}
	}

}
/*//GM被观察者的装备数据
    const BYTE GM_ADDUSEROBJECT_LIST_PROPERTY_USERCMD = 45;
    struct stGmAddUserObjListPropertyUserCmd : public stPropertyUserCmd
    {        
        stGmAddUserObjListPropertyUserCmd()
        {        
            byParam = GM_ADDUSEROBJECT_LIST_PROPERTY_USERCMD;
            dataSize = 0;
            objnum = 0;
        }        
        DWORD dataSize;
        WORD objnum; 
        BYTE data[0];
        DWORD getSize()
        {        
            return sizeof(*this) + dataSize*sizeof(BYTE);
        }    
    };*/