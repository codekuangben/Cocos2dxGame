package modulecommon.net.msg.sceneHeroCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	public class stTakeDownKitCmd extends stSceneHeroCmd 
	{
		public var kitPos:int;
		public function stTakeDownKitCmd() 
		{
			 byParam = PARA_TAKEDOWN_KIT_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);			
			kitPos = byte.readUnsignedByte();
		}
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);			
			byte.writeByte(kitPos);			
		}
	}

}

/*
 * //取下锦囊
    const BYTE PARA_TAKEDOWN_KIT_USERCMD = 13; 
    struct stTakeDownKitCmd : public stSceneHeroCmd
    {   
        stTakeDownKitCmd()
        {   
            byParam = PARA_TAKEDOWN_KIT_USERCMD;
            kitpos = 0;
        }   
        BYTE  kitpos;   //锦囊所在位置
    };
*/