package modulecommon.net.msg.attrbufferCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stUserBufferListUserCmd extends stSceneUserCmd
	{
		public var m_bufferList:Array;
		
		public function stUserBufferListUserCmd() 
		{
			byParam = SceneUserParam.PARA_USER_BUFFER_LIST_USERCMD;
			m_bufferList = new Array();
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			var num:int = byte.readUnsignedShort();
			var i:int;
			var buffer:stBufferData;
			for (i = 0; i < num; i++)
			{
				buffer = new stBufferData();
				buffer.deserialize(byte);
				
				m_bufferList.push(buffer);
			}
		}
	}

}
/*
//玩家buff列表
    const BYTE PARA_USER_BUFFER_LIST_USERCMD = 58;
    struct stUserBufferListUserCmd : public stSceneUserCmd
    {
        stUserBufferListUserCmd()
        {
            byParam = PARA_USER_BUFFER_LIST_USERCMD;
            num = 0;
        }
        WORD num;
        stBufferData list[0];
        WORD getSize()
        {
            return (sizeof(*this) + num*sizeof(stBufferData));
        }
    };
*/