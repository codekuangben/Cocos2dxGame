package modulecommon.net.msg.sceneHeroCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stRobEnemyTimesHeroCmd extends stSceneHeroCmd
	{
		public var robenemytimes:uint;//复仇次数(被抢了宝物)
		
		public function stRobEnemyTimesHeroCmd() 
		{
			byParam = PARA_ROB_ENEMY_TIMES_HERO_CMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			robenemytimes = byte.readUnsignedShort();
		}
	}

}

/*
//抢劫敌人次数变化
    const BYTE PARA_ROB_ENEMY_TIMES_HERO_CMD = 45;
    struct stRobEnemyTimesHeroCmd : public stSceneHeroCmd
    {
        stRobEnemyTimesHeroCmd()
        {
            byParam = PARA_ROB_ENEMY_TIMES_HERO_CMD;
            robenemytimes = 0;
        }
        WORD robenemytimes;
    };
*/