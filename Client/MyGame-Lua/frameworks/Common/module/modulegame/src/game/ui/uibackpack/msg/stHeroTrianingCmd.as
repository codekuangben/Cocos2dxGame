package game.ui.uibackpack.msg 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneHeroCmd.stSceneHeroCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stHeroTrianingCmd extends stSceneHeroCmd
	{
		public var m_heroid:uint;
		public var m_type:uint;
		public var m_fastXiulian:uint;
		
		public function stHeroTrianingCmd() 
		{
			byParam = PARA_HERO_TRAINING_USERCMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			
			byte.writeUnsignedInt(m_heroid);
			byte.writeByte(m_type);
			byte.writeUnsignedInt(m_fastXiulian);
		}
	}

}
/*
//武将培养
    const BYTE PARA_HERO_TRAINING_USERCMD = 34; 
    struct stHeroTrianingCmd : public stSceneHeroCmd
    {   
        stHeroTrianingCmd()
        {   
            byParam = PARA_HERO_TRAINING_USERCMD;
            heroid = 0;
            type = 0;
            fastxiulian = 0;
        }   
        DWORD heroid;   //-1标识主角
        BYTE type;  //0-普通培养    1-高级培养
        DWORD fastxiulian;  //是否快速修炼 0-快速修炼 非零:元气丹thisid
    };  
*/