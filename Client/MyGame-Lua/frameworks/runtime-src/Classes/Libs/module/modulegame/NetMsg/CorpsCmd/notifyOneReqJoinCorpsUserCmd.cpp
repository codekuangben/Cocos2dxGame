package game.netmsg.corpscmd 
{
	import modulecommon.net.msg.corpscmd.stCorpsCmd;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class notifyOneReqJoinCorpsUserCmd extends stCorpsCmd 
	{
		public var reqNum:uint;
		public function notifyOneReqJoinCorpsUserCmd() 
		{
			byParam = NOTIFY_ONE_REQ_JOIN_CORPS_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			reqNum = byte.readUnsignedByte();			
		}
	}

}

//通知有人申请入团 s->c
    /*const BYTE NOTIFY_ONE_REQ_JOIN_CORPS_USERCMD = 7;
    struct notifyOneReqJoinCorpsUserCmd : public stCorpsCmd
    {   
        notifyOneReqJoinCorpsUserCmd()
        {   
            byParam = NOTIFY_ONE_REQ_JOIN_CORPS_USERCMD;
            reqNum= 0;
        }   
        BYTE reqNum;
    }; */
