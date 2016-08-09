package modulecommon.net.msg.sceneHeroCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stHeroRebirthCacheHeroEquipCmd extends stSceneHeroCmd 
	{
		public var heroid:uint;
		public function stHeroRebirthCacheHeroEquipCmd() 
		{
			super();
			byParam = PARA_HERO_REBIRHT_CACHE_HERO_EQUIP_CMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			heroid = byte.readUnsignedInt();
		}
	}

}

//武将转生缓存装备
    /*const BYTE PARA_HERO_REBIRHT_CACHE_HERO_EQUIP_CMD = 42; 
    struct stHeroRebirthCacheHeroEquipCmd : public stSceneHeroCmd
    {   
        stHeroRebirthCacheHeroEquipCmd()
        {   
            byParam = PARA_HERO_REBIRHT_CACHE_HERO_EQUIP_CMD;
            heroid = 0;
        }   
        DWORD heroid;
    };*/