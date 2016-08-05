package modulecommon.net.msg.sceneUserCmd 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	public class stRetCommonSetUserCmd extends stSceneUserCmd 
	{
		
		public function stRetCommonSetUserCmd() 
		{
			byParam = SceneUserParam.RET_COMMONSET_USERCMD_PARA;
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			byte.readUnsignedShort();
			
			//后面的数据在处理这个消息的地方进行处理
		}
		
	}

}

/*
 * const BYTE RET_COMMONSET_USERCMD_PARA = 25; 
    struct stRetCommonSetUserCmd : public stSceneUserCmd
    {
        stRetCommonSetUserCmd()
        {
            byParam = RET_COMMONSET_USERCMD_PARA;
            size = 0;
        }
        WORD size;
        DWORD state[0];
        WORD getSize()
        {   
            return (sizeof(*this) +size*sizeof(DWORD));
        }   
    }; 
*/