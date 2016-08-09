package modulecommon.net.msg.sceneHeroCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stRetHeroTrainingInfoCmd extends stSceneHeroCmd
	{
		public var m_heroid:uint;
		public var m_curPower:uint;
		public var m_trainLevel:uint;
		public var m_baoji:uint;
		
		public function stRetHeroTrainingInfoCmd() 
		{
			byParam = PARA_RET_HEROTRAINING_INFO_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			m_heroid = byte.readUnsignedInt();
			m_curPower = byte.readUnsignedInt();
			m_trainLevel = byte.readUnsignedShort();
			m_baoji = byte.readUnsignedByte();
		}
	}

}

/*
//返回培养信息
    const BYTE PARA_RET_HEROTRAINING_INFO_USERCMD = 35; 
    struct stRetHeroTrainingInfoCmd : public stSceneHeroCmd
    {   
        stRetHeroTrainingInfoCmd()
        {
            byParam = PARA_RET_HEROTRAINING_INFO_USERCMD;
            heroid = 0;
            curpower = 0;
            trainlevel = 0;
            baoji = 0;
        }
        DWORD heroid;   //-1标识主角
        DWORD curpower;
        WORD trainlevel;
        BYTE baoji;
    };
*/