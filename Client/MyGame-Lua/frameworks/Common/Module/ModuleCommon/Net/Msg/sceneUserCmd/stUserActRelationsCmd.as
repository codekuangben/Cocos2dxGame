package modulecommon.net.msg.sceneUserCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 * List中数据含义：(groupID * 10 + itemID) (useractrelations.xml配置表)
	 */
	public class stUserActRelationsCmd extends stSceneUserCmd
	{
		public var m_uarList:Vector.<uint>;
		
		public function stUserActRelationsCmd() 
		{
			byParam = SceneUserParam.PARA_USER_ACT_RELATIONS_USERCMD;
			m_uarList = new Vector.<uint>();
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			var num:int = byte.readUnsignedByte();
			var uar:uint;
			for (var i:int = 0; i < num; i++)
			{
				uar = byte.readUnsignedShort();
				m_uarList.push(uar);
			}
		}
	}

}

/*
    //主角激活关系
    const BYTE PARA_USER_ACT_RELATIONS_USERCMD = 73;
    struct stUserActRelationsCmd : public stSceneUserCmd
    {    
        stUserActRelationsCmd()
        {    
            byParam = PARA_USER_ACT_RELATIONS_USERCMD;
            num = 0; 
        }    
        BYTE num; 
        WORD uarlist[0];
        WORD getSize()
        {    
            return (sizeof(*this) + num*sizeof(WORD));
        }    
    };
*/