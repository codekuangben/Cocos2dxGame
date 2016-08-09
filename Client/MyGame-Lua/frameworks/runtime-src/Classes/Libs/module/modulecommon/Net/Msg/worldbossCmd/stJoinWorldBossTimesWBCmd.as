package modulecommon.net.msg.worldbossCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stJoinWorldBossTimesWBCmd extends stWorldBossCmd
	{
		public var joinTimes:int; //今日已参与次数
		
		public function stJoinWorldBossTimesWBCmd() 
		{
			byParam = PARA_JOIN_WORLD_BOSS_TIMES_WBCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			joinTimes = byte.readUnsignedByte();
		}
	}

}

/*
    //世界BOSS今日参与次数
    const BYTE PARA_JOIN_WORLD_BOSS_TIMES_WBCMD = 15; 
    struct stJoinWorldBossTimesWBCmd : public stWorldBossCmd
    {   
        stJoinWorldBossTimesWBCmd()
        {   
            byParam = PARA_JOIN_WORLD_BOSS_TIMES_WBCMD;
            times = 0;
        }   
        BYTE times;
    };  
*/