package modulecommon.net.msg.sceneUserCmd 
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 */
	public class stYetOpenNewFunctionUserCmd extends stSceneUserCmd
	{
		
		public function stYetOpenNewFunctionUserCmd() 
		{
			byParam = SceneUserParam.YET_OPEN_NEW_FUNCTION_USERCMD_PARA
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			byte.readUnsignedShort();
			//
		}
	}

}

/*
//s-c 新功能开启，上线发送已开启的功能
    const BYTE YET_OPEN_NEW_FUNCTION_USERCMD_PARA = 30; 
    struct stYetOpenNewFunctionUserCmd : public stSceneUserCmd
    {   
        stYetOpenNewFunctionUserCmd()
        {   
            byParam = YET_OPEN_NEW_FUNCTION_USERCMD_PARA
            num = 0;
        }   
        WORD num;
        DWORD funcs[0];
        WORD getSize()
        {   
            return (sizeof(*this) + num*sizeof(DWORD));
        }   
    };  
*/