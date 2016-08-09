package modulecommon.net.msg.stResRobCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class synIntoRobResDataUserCmd extends stResRobCmd 
	{
		public var zhenying:int;
		public var time:int;
		public function synIntoRobResDataUserCmd() 
		{
			super();
			byParam = SYN_INTO_ROB_RES_DATA_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			zhenying = byte.readUnsignedByte();
			time = byte.readUnsignedInt();
		}
		
	}

}
//进入战场是同步阵营和倒计时
	/*const BYTE SYN_INTO_ROB_RES_DATA_USERCMD = 2;
	struct synIntoRobResDataUserCmd : public stMailCmd
	{
		synIntoRobResDataUserCmd()
		{
			byParam = SYN_INTO_ROB_RES_DATA_USERCMD;
			size = 0;
			zhenying = 1;
		}
		BYTE zhenying; //阵营 魏：1, 蜀：2，吴：3
		DWORD time; //剩余时间 (s)
	};*/