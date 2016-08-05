package modulecommon.net.msg.dazuoCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.propertyUserCmd.stPropertyUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stRetOtherFuYouTimePropertyUserCmd extends stPropertyUserCmd
	{
		public var infolist:Array;
		
		public function stRetOtherFuYouTimePropertyUserCmd() 
		{
			byParam = PARA_RET_OTHER_FUYOUTIME_PROPERTY_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			var num:int = byte.readUnsignedShort();
			var item:stUserDZInfo;
			infolist = new Array();
			for (var i:int = 0; i < num; i++)
			{
				item = new stUserDZInfo();
				item.deserialize(byte);
				infolist.push(item);
			}
		}
	}

}
/*
const BYTE PARA_RET_OTHER_FUYOUTIME_PROPERTY_USERCMD = 32;
    struct stRetOtherFuYouTimePropertyUserCmd : public stPropertyUserCmd
    {
        stRetOtherFuYouTimePropertyUserCmd()
        {
            byParam = PARA_RET_OTHER_FUYOUTIME_PROPERTY_USERCMD;
            num = 0;
        }
        WORD num;
        stUserDZInfo infolist[0];
    };

*/