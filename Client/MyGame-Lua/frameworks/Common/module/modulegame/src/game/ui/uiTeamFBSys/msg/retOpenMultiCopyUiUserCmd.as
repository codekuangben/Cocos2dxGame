package game.ui.uiTeamFBSys.msg
{
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;
	import flash.utils.ByteArray;

	public class retOpenMultiCopyUiUserCmd extends stCopyUserCmd
	{
		public var count:uint;
		public var copyid:Vector.<uint>;
		
		public function retOpenMultiCopyUiUserCmd()
		{
			super();
			byParam = stCopyUserCmd.RET_OPEN_MULTI_COPY_UI_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			count = byte.readUnsignedByte();
			copyid = new Vector.<uint>(2, true);
			copyid[0] = byte.readUnsignedInt();
			copyid[1] = byte.readUnsignedInt();
		}
	}
}

//const BYTE RET_OPEN_MULTI_COPY_UI_USERCMD = 38;
//struct retOpenMultiCopyUiUserCmd : public stCopyUserCmd
//{
//	retOpenMultiCopyUiUserCmd()
//	{
//		byParam = RET_OPEN_MULTI_COPY_UI_USERCMD;
//		count = 0;
//		copyid[0] = copyid[1] = 0;
//	}
//	BYTE count; //本日收益次数
//	DWORD copyid[2]; //已领奖副本
//};