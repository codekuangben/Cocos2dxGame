package modulecommon.net.msg.sceneHeroCmd 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	public class stPutCacheEquipToRebirthHeroCmd extends stSceneHeroCmd 
	{
		public var srcheroid:uint;
		public var dstheroid:uint;
		public function stPutCacheEquipToRebirthHeroCmd() 
		{
			super();
			byParam = PARA_PUT_CACHE_EQUIP_TO_REBIRTH_HERO_CMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			srcheroid = byte.readUnsignedInt();
			dstheroid = byte.readUnsignedInt();
		}
	}

}


//武将转生给转生武将穿上缓存装备
   /* const BYTE PARA_PUT_CACHE_EQUIP_TO_REBIRTH_HERO_CMD = 43; 
    struct  stPutCacheEquipToRebirthHeroCmd : public stSceneHeroCmd
    {   
        stPutCacheEquipToRebirthHeroCmd()
        {
            byParam = PARA_PUT_CACHE_EQUIP_TO_REBIRTH_HERO_CMD;
            heroid = 0;
        }
        DWORD srcheroid;
        DWORD dstheroid;

    };*/