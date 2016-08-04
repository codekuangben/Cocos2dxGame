package modulecommon.net.msg.sceneHeroCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stPurpleHeroListCmd extends stSceneHeroCmd
	{
		public var m_list:Array;
		
		public function stPurpleHeroListCmd() 
		{
			byParam = PARA_PURPLE_HEROLIST_USERCMD;
			m_list = new Array();
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			var num:int = byte.readUnsignedShort();
			var wuid:uint;
			for (var i:int = 0; i < num; i++)
			{
				wuid = byte.readUnsignedInt();
				m_list.push(wuid);
			}
		}
	}

}

/*
	//可招募紫将列表
    const BYTE PARA_PURPLE_HEROLIST_USERCMD = 37; 
    struct stPurpleHeroListCmd : public stSceneHeroCmd
    {   
        stPurpleHeroListCmd()
        {   
            byParam = PARA_PURPLE_HEROLIST_USERCMD;
            num = 0;
        }   
        WORD num;
        DWORD list[0];
        WORD getSize()
        {
            return (sizeof(*this) + num*sizeof(DWORD));
        }
    };
*/