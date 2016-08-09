package modulecommon.net.msg.attrbufferCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stAddBufferToUserUserCmd extends stSceneUserCmd
	{
		public var m_action:uint;
		public var m_buffer:stBufferData;
		
		public function stAddBufferToUserUserCmd() 
		{
			byParam = SceneUserParam.PARA_ADD_BUFFER_TO_USER_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			m_action = byte.readUnsignedByte();
			
			m_buffer = new stBufferData();
			m_buffer.deserialize(byte);
		}
	}

}
/*
//人物身上添加buffer
    const BYTE PARA_ADD_BUFFER_TO_USER_USERCMD = 59;
    struct stAddBufferToUserUserCmd : public stSceneUserCmd
    {
        stAddBufferToUserUserCmd()
        {
            byParam = PARA_ADD_BUFFER_TO_USER_USERCMD;
        }
		BYTE action;    //0-增加buff 1-刷新buff
        stBufferData buffer;
    };
*/