package game.netmsg.copycmd
{
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;
	import flash.utils.ByteArray;

	public class stRetCreateCopyUserCmd extends stCopyUserCmd
	{
		public var id:uint;
		
		public function stRetCreateCopyUserCmd()
		{
			byParam = RET_CREATE_COPY_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			id = byte.readUnsignedInt();
		}
	}
}


//创建副本返回
//const BYTE  RET_CREATE_COPY_USERCMD = 18; 
//struct  stRetCreateCopyUserCmd: public stCopyUserCmd
//{   
//	stRetCreateCopyUserCmd()
//	{   
//		byParam = RET_CREATE_COPY_USERCMD;
//	}
//  DWORD id;
//};