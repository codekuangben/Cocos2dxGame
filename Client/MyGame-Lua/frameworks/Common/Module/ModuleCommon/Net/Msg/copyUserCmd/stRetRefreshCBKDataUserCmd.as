package modulecommon.net.msg.copyUserCmd
{
	import flash.utils.ByteArray;

	public class stRetRefreshCBKDataUserCmd extends stCopyUserCmd
	{
		public var refreshtimes:uint;
		public var needmoney:uint;

		public function stRetRefreshCBKDataUserCmd()
		{
			byParam = PARA_RET_REFRESH_CBK_DATA_USERCMD; 
		}
		
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			refreshtimes = byte.readUnsignedShort();
			needmoney = byte.readUnsignedInt();
		}
	}
}


//const BYTE PARA_RET_REFRESH_CBK_DATA_USERCMD = 35; 
//struct stRetRefreshCBKDataUserCmd : public stCopyUserCmd
//{   
//	stRetRefreshCBKDataUserCmd()
//	{   
//		byParam = PARA_RET_REFRESH_CBK_DATA_USERCMD;
//		refreshtimes = 0;
//		needmoney = 0;
//	}   
//	WORD refreshtimes;
//	DWORD needmoney;
//};