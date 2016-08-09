package modulecommon.net.msg.sceneUserCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	public class stNpcMoveUserCmd extends stSceneUserCmd 
	{
		public var dwNpcTempID:uint;
		public var x:uint;
		public var y:uint;
		public function stNpcMoveUserCmd() 
		{
			byParam = SceneUserParam.NPCMOVE_MOVE_USERCMD_PARA;
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			dwNpcTempID = byte.readUnsignedInt();
			x = byte.readUnsignedShort();
			y = byte.readUnsignedShort();
		}
	}

}


/*
 * // Npc移动指令
    const BYTE NPCMOVE_MOVE_USERCMD_PARA = 18; 
    struct stNpcMoveMoveUserCmd : public stSceneUserCmd
    {   
        stNpcMoveMoveUserCmd()
        {   
            byParam = NPCMOVE_MOVE_USERCMD_PARA;
        }   
        DWORD dwNpcTempID;    /**< Npc临时编号 */      
       // WORD x;             /**< 目的坐标 */
       // WORD y;
   // };  

//*/