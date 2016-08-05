package  modulecommon.net.msg.sceneUserCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	
	/**
	 * ...
	 * @author 
	 */
	public class stSetUserStateCmd extends stSceneUserCmd 
	{
		public var m_tempID:uint;
		public var m_state:uint;
		public var m_bSet:Boolean;
		public function stSetUserStateCmd() 
		{
			byParam = SceneUserParam.PARA_SET_USERSTATE_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_tempID  = byte.readUnsignedInt();
			m_state = byte.readUnsignedShort();
			m_bSet = byte.readBoolean();
		}
		
	}

}

/*
const BYTE PARA_SET_USERSTATE_USERCMD = 44; 
    struct stSetUserStateCmd : public stSceneUserCmd
    {   
        stSetUserStateCmd()
        {   
            byParam = PARA_SET_USERSTATE_USERCMD;
            state = 0;
            set = 0;
        }   
        WORD state;
        BYTE set;   //0-取消 1-设置
    };  */
