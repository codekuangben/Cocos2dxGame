package modulecommon.net.msg.attrbufferCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stRemoveOneBufferUserCmd extends stSceneUserCmd
	{
		public var m_bufferid:uint;
		
		public function stRemoveOneBufferUserCmd() 
		{
			byParam = SceneUserParam.PARA_REMOVE_ONE_BUFFER_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			m_bufferid = byte.readUnsignedShort();
		}
	}

}
/*
//删除人物身上一个buffer
    const BYTE PARA_REMOVE_ONE_BUFFER_USERCMD = 60;
    struct stRemoveOneBufferUserCmd : public stSceneUserCmd
    {
        stRemoveOneBufferUserCmd()
        {
            byParam = PARA_REMOVE_ONE_BUFFER_USERCMD;
            bufferid = 0;
        }
        WORD bufferid;
    };
*/