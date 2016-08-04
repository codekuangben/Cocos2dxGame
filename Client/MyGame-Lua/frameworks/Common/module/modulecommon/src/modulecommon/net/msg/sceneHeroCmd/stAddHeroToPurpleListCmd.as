package modulecommon.net.msg.sceneHeroCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stAddHeroToPurpleListCmd extends stSceneHeroCmd
	{
		public var m_wuid:uint;
		
		public function stAddHeroToPurpleListCmd() 
		{
			byParam = PARA_ADD_HERO_PURPLE_HEROLIST_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			m_wuid = byte.readUnsignedInt();
		}
	}

}

/*
//将一个紫将加入到紫将列表中
    const BYTE PARA_ADD_HERO_PURPLE_HEROLIST_USERCMD = 36; 
    struct stAddHeroToPurpleListCmd : public stSceneHeroCmd
    {   
        stAddHeroToPurpleListCmd()
        {   
            byParam = PARA_ADD_HERO_PURPLE_HEROLIST_USERCMD;
            heroid = 0;
        }   
        DWORD heroid;
    };  
*/