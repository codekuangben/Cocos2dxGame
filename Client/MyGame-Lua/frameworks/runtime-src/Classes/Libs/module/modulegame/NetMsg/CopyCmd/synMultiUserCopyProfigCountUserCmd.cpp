package game.netmsg.copycmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class synMultiUserCopyProfigCountUserCmd extends stCopyUserCmd
	{
		public var m_count:uint;
		
		public function synMultiUserCopyProfigCountUserCmd() 
		{
			byParam = SYN_MULTI_USER_COPY_PROFIG_COUNT_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			m_count = byte.readUnsignedByte();
		}
	}

}
/*
//组队副本今日挑战剩余次数
const BYTE SYN_MULTI_USER_COPY_PROFIG_COUNT_USERCMD = 61; 
    struct  synMultiUserCopyProfigCountUserCmd: public stCopyUserCmd
    {   
        synMultiUserCopyProfigCountUserCmd()
        {   
            byParam = SYN_MULTI_USER_COPY_PROFIG_COUNT_USERCMD;
            count = 0;
        }   
        BYTE count;
    };  
*/