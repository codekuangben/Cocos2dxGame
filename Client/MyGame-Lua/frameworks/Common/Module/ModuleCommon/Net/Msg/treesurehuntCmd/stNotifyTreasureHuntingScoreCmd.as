package modulecommon.net.msg.treesurehuntCmd 
{
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import flash.utils.ByteArray
	
	/**
	 * ...
	 * @author 
	 */
	public class stNotifyTreasureHuntingScoreCmd extends stSceneUserCmd 
	{
		public var m_score:uint;
		public function stNotifyTreasureHuntingScoreCmd() 
		{
			super();
			byParam = SceneUserParam.PARA_NOTIFY_TREASURE_HUNTING_SCORE_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			m_score = byte.readUnsignedInt();
		}
		
	}

}
/*//通知寻宝积分
    const BYTE PARA_NOTIFY_TREASURE_HUNTING_SCORE_USERCMD = 75;
    struct stNotifyTreasureHuntingScoreCmd : public stSceneUserCmd
    {    
        stNotifyTreasureHuntingScoreCmd()
        {    
            byParam =  PARA_NOTIFY_TREASURE_HUNTING_SCORE_USERCMD;
            score = 0; 
        }    
        DWORD score;
    };   */