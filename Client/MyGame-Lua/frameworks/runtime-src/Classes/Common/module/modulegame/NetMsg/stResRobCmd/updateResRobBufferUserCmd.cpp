package game.netmsg.stResRobCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.stResRobCmd.stResRobCmd;
	
	/**
	 * ...
	 * @author ...
	 */
	public class updateResRobBufferUserCmd extends stResRobCmd 
	{
		public var level:int;
		public function updateResRobBufferUserCmd() 
		{
			super();
			byParam = UPDATE_RES_ROB_BUFFER_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			level = byte.readUnsignedShort();
		}
		
	}

}

//卧薪尝胆 s->c
    /*const BYTE UPDATE_RES_ROB_BUFFER_USERCMD = 13; 
    struct updateResRobBufferUserCmd : public stResRobCmd
    {   
        updateResRobBufferUserCmd()
        {   
            byParam = UPDATE_RES_ROB_BUFFER_USERCMD;
            level = 0;
        }   
        WORD level; //以 1开始 0:去掉
    };*/  