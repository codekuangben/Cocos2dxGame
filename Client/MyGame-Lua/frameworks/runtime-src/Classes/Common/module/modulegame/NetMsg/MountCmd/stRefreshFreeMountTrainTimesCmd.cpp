package game.netmsg.mountcmd
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.mountscmd.stMountCmd;

	public class stRefreshFreeMountTrainTimesCmd extends stMountCmd
	{
		public var times:uint;

		public function stRefreshFreeMountTrainTimesCmd()
		{
			super();
			byParam = stMountCmd.PARA_REFRESH_FREE_MOUNT_TRAINTIMES_CMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			times = byte.readUnsignedShort();
		}
	}
}

//刷新免费坐骑培养次数
//const BYTE PARA_REFRESH_FREE_MOUNT_TRAINTIMES_CMD = 12; 
//struct stRefreshFreeMountTrainTimesCmd : public stMountCmd
//{   
//	stRefreshFreeMountTrainTimesCmd()
//	{   
//		byParam = PARA_REFRESH_FREE_MOUNT_TRAINTIMES_CMD;
//		times = 0;
//	}   
//	WORD times;     //已使用免费次数
//};