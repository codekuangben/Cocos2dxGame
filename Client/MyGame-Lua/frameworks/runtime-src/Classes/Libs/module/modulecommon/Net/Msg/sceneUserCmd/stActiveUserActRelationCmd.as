package modulecommon.net.msg.sceneUserCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stActiveUserActRelationCmd extends stSceneUserCmd
	{
		public var m_group:uint;
		
		public function stActiveUserActRelationCmd() 
		{
			byParam = SceneUserParam.PARA_ACTIVE_USER_ACT_RELATION_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			m_group = byte.readUnsignedShort();
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			
			byte.writeShort(m_group);
		}
	}

}
/*
	const BYTE PARA_ACTIVE_USER_ACT_RELATION_USERCMD = 74;
    struct stActiveUserActRelationCmd : public stSceneUserCmd
    {    
        stActiveUserActRelationCmd()
        {    
            byParam = PARA_ACTIVE_USER_ACT_RELATION_USERCMD;
            group = 0;
        }
        WORD group;
    };
*/