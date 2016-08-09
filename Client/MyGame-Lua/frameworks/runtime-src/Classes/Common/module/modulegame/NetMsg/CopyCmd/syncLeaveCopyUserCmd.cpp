package game.netmsg.copycmd
{
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;
	import flash.utils.ByteArray;

	public class syncLeaveCopyUserCmd extends stCopyUserCmd
	{
		public var id:uint;
		
		public function syncLeaveCopyUserCmd()
		{
			byParam = SYNC_LEAVE_COPY_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			id = byte.readUnsignedInt();
		}
	}
}

//退出副本
//const BYTE  SYNC_LEAVE_COPY_USERCMD = 3;
//struct  syncLeaveCopyUserCmd: public stCopyUserCmd
//{
//	syncLeaveCopyUserCmd()
//	{
//		byParam = SYNC_LEAVE_COPY_USERCMD;
//	}
//  DWORD id;
//};