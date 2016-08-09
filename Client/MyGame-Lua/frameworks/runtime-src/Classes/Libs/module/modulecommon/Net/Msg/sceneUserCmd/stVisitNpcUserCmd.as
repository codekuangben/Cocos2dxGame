package modulecommon.net.msg.sceneUserCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	
	public class stVisitNpcUserCmd extends stSceneUserCmd 
	{
		public var npctempid:uint;
		public function stVisitNpcUserCmd() 
		{
			byParam = SceneUserParam.VISIT_NPC_USERCMD_PARA;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeUnsignedInt(npctempid);			
		}
	}
}

/*
const BYTE  VISIT_NPC_USERCMD_PARA = 14; 
    struct stVisitNpcUserCmd:public stSceneUserCmd
    {   
        stVisitNpcUserCmd()
        {   
            byParam = VISIT_NPC_USERCMD_PARA;
            npctempid = 0;
        }   
        DWORD npctempid;
    };*/