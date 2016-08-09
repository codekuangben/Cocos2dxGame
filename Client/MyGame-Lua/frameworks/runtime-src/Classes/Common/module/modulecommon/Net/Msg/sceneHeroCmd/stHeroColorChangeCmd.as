package modulecommon.net.msg.sceneHeroCmd 
{
	/**
	 * ...
	 * @author ...
	 */
	import flash.utils.ByteArray;
	public class stHeroColorChangeCmd extends stSceneHeroCmd 
	{
		public var heroid:uint;
		public var color:uint;
		public function stHeroColorChangeCmd() 
		{
			byParam = PARA_HEROCOLOR_CHANGE_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			heroid = byte.readUnsignedInt();
			color = byte.readUnsignedByte();		
		}
	}
}

/*
 * const BYTE PARA_HEROCOLOR_CHANGE_USERCMD = 17; 
    struct stHeroColorChangeCmd : public stSceneHeroCmd
    {   
        stHeroColorChangeCmd()
        {   
            byParam = PARA_HEROCOLOR_CHANGE_USERCMD;
            heroid = 0;
            color = 0;
        }   
        DWORD heroid;
        BYTE color;
    };
*/