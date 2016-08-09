package game.netmsg.teamcmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class retUserProfitInCopyUserCmd extends stCopyUserCmd
	{
		public var type:uint;
		
		public function retUserProfitInCopyUserCmd() 
		{
			byParam = stCopyUserCmd.RET_USE_PROFIT_IN_COPY_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			type = byte.readUnsignedByte();
		}
	}

}
/*
 //返回请求本副本使用收益 s->c
    const BYTE RET_USE_PROFIT_IN_COPY_USERCMD = 46; 
    struct retUserProfitInCopyUserCmd : public stCopyUserCmd
    {   
        retUserProfitInCopyUserCmd()
        {   
            byParam = RET_USE_PROFIT_IN_COPY_USERCMD;
            type = 0;
        }   
        BYTE type; //0：请求成功，使用副本收益 1：失败，无收益可用
    };  
*/