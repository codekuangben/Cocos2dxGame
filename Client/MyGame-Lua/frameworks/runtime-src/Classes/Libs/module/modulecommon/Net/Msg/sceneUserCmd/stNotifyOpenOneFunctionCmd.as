package modulecommon.net.msg.sceneUserCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stNotifyOpenOneFunctionCmd extends stSceneUserCmd
	{
		public var funcType:uint;
		
		public function stNotifyOpenOneFunctionCmd() 
		{
			byParam = SceneUserParam.OPEN_ONE_FUNCTION_USERCMD_PARA;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			funcType = byte.readUnsignedShort();
		}
	}

}

/*
//s->c 开启一项新功能
    const BYTE OPEN_ONE_FUNCTION_USERCMD_PARA = 31; 
    struct stNotifyOpenOneFunctionCmd : public stSceneUserCmd
    {
        stNotifyOpenOneFunctionCmd()
        {
            byParam = OPEN_ONE_FUNCTION_USERCMD_PARA;
            func = 0;
        }
        WORD func;
    };
*/