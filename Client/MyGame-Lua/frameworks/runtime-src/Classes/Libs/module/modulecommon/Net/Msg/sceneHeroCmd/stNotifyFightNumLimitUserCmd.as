package modulecommon.net.msg.sceneHeroCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stNotifyFightNumLimitUserCmd extends stSceneUserCmd
	{
		public var m_num:uint;
		
		public function stNotifyFightNumLimitUserCmd() 
		{
			byParam = SceneUserParam.PARA_NOTIFY_FIGHTNUM_LIMIT_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			m_num = byte.readUnsignedShort();
		}
	}

}
/*
//通知上阵人数上限
    const BYTE PARA_NOTIFY_FIGHTNUM_LIMIT_USERCMD = 50; 
    struct stNotifyFightNumLimitUserCmd : public stSceneUserCmd
    {   
        stNotifyFightNumLimitUserCmd()
        {   
            byParam = PARA_NOTIFY_FIGHTNUM_LIMIT_USERCMD;
            num = 0;
        }   
        WORD num;
    }; 
*/