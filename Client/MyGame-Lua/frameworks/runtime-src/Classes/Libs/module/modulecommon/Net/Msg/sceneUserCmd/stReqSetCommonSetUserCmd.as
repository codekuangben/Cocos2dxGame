package modulecommon.net.msg.sceneUserCmd 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	
	public class stReqSetCommonSetUserCmd extends stSceneUserCmd 
	{
		public var m_state:uint;
		public var m_bClear:Boolean;
		public function stReqSetCommonSetUserCmd() 
		{
			byParam = SceneUserParam.REQ_SET_COMMONSET_USERCMD_PARA;
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			m_state = byte.readUnsignedShort();
			var data:uint = byte.readUnsignedByte();
			m_bClear = (data == 0 ? false:true);
		}
		
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeShort(m_state);
			
			var data:int = m_bClear?1:0;
			byte.writeByte(data);
		}		
	}

}

/*
 * ///请求设置玩家通用设置
    const BYTE REQ_SET_COMMONSET_USERCMD_PARA = 24; 
    struct stReqSetCommonSetUserCmd : public stSceneUserCmd
    {   
        stReqSetCommonSetUserCmd()
        {   
            byParam = REQ_SET_COMMONSET_USERCMD_PARA;
            state = 0;
            clear = 0;
        }   
        WORD state;
        BYTE clear; //clear 0-设置  1-清除
    };  

*/