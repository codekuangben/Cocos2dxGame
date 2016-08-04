package modulecommon.net.msg.stResRobCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class synResRobTimesUserCmd extends stResRobCmd 
	{
		public var times:int;
		public function synResRobTimesUserCmd() 
		{
			super();
			byParam = SYN_RES_ROB_TIMES_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			times = byte.readUnsignedByte();
		}
	}

}
//s->c
	/*const BYTE SYN_RES_ROB_TIMES_USERCMD = 1;
	struct synResRobTimesUserCmd : public stResRobCmd
	{
		synResRobTimesUserCmd()
		{
			byParam = SYN_RES_ROB_TIMES_USERCMD;
			times = 0;
		}
		BYTE times; //已进入次数
	};*/