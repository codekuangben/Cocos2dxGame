package modulecommon.net.msg.dazuoCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.propertyUserCmd.stPropertyUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stReqOtherFuYouTimePropertyUserCmd extends stPropertyUserCmd
	{
		public var num:int;
		public var userlist:Array;
		
		public function stReqOtherFuYouTimePropertyUserCmd() 
		{
			byParam = PARA_REQ_OTHER_FUYOUTIME_PROPERTY_USERCMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeShort(num);
			if (num)
			{
				for (var i:int = 0; i < num; i++)
				{
					byte.writeUnsignedInt(userlist[i]);
				}
			}
			else
			{
				byte.writeUnsignedInt(0);
			}
		}
	}

}
/*
const BYTE PARA_REQ_OTHER_FUYOUTIME_PROPERTY_USERCMD = 31; 
    struct stReqOtherFuYouTimePropertyUserCmd : public stPropertyUserCmd
    {   
        stReqOtherFuYouTimePropertyUserCmd()
        {   
            byParam = PARA_REQ_OTHER_FUYOUTIME_PROPERTY_USERCMD;
            num = 0;
        }   
        WORD num;
        DWORD userlist[0];
    };  

*/