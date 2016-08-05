package modulecommon.net.msg.sceneUserCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	
	/**
	 * ...
	 * @author 
	 */
	public class reqViewUserCmd extends stSceneUserCmd 
	{
		public var tempid:uint;
		public function reqViewUserCmd() 
		{
			 byParam = SceneUserParam.REQ_VIEW_USERCMD_PARA;
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeUnsignedInt(tempid);
		}
	}

}

//请求观察某人
/*    const BYTE REQ_VIEW_USERCMD_PARA = 41; 
    struct reqViewUserCmd : public stSceneUserCmd 
    {   
        reqViewUserCmd()
        {   
            byParam = REQ_VIEW_USERCMD_PARA;
            tempid = 0;
        }   
        DWORD tempid;//被观察者
    }; */