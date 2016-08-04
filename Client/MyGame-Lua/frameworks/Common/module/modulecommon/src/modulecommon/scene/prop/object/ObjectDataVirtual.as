package modulecommon.scene.prop.object 
{
	/**
	 * ...
	 * @author 
	 * 代表一个道具信息，这个道具是不存在的
	 */
	
	 import flash.utils.ByteArray;
	public class ObjectDataVirtual 
	{
		public var m_objID:uint;
		public var m_upgrade:uint;
		public var m_num:uint;
		public function ObjectDataVirtual() 
		{
			
		}
		public function deserialize(byte:ByteArray):void
		{
			m_objID = byte.readUnsignedInt();
			m_num = byte.readUnsignedShort();
			m_upgrade = byte.readUnsignedByte();
		}
		
		public static function s_readArray(byte:ByteArray):Array
		{
			var n:int = byte.readUnsignedShort();
			var list:Array = new Array();
			var i:int;
			var item:ObjectDataVirtual;
			for (i = 0; i < n; i++)
			{
				item = new ObjectDataVirtual();
				item.deserialize(byte);
				list.push(item);
			}
			return list;
		}
		
	}

}

/*struct stRewardObj
    {   
        DWORD id; 
        WORD num;
        BYTE upgrade;
        stRewardObj()
        {   
            id = 0;
            num = 0;
            upgrade = 0;
        }   
    }; */