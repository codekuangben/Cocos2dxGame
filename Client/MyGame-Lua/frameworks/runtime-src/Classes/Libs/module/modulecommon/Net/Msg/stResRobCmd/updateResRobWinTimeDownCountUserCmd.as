package modulecommon.net.msg.stResRobCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class updateResRobWinTimeDownCountUserCmd extends stResRobCmd 
	{
		public var intervalTime:Number;
		public function updateResRobWinTimeDownCountUserCmd() 
		{
			super();
			byParam = UPDATE_RES_ROB_WIN_TIME_DOWN_COUNT_USERCMD;
			
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			intervalTime = byte.readUnsignedByte();
		}
		
	}

}

//胜利方收到开始战斗冷却倒计时 s->c
   /* const BYTE UPDATE_RES_ROB_WIN_TIME_DOWN_COUNT_USERCMD = 14; 
    struct updateResRobWinTimeDownCountUserCmd : public stResRobCmd
    {   
        updateResRobWinTimeDownCountUserCmd()
        {   
            byParam = UPDATE_RES_ROB_WIN_TIME_DOWN_COUNT_USERCMD;
            time = 0;
        }
        BYTE time;
    };*/