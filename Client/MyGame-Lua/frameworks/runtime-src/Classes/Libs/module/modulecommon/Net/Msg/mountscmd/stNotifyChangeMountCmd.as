package modulecommon.net.msg.mountscmd
{
	import flash.utils.ByteArray;

	public class stNotifyChangeMountCmd extends stMountCmd
	{
		public var utempid:uint;
		public var mountid:uint;
		
		public function stNotifyChangeMountCmd()
		{
			super();
			byParam = stMountCmd.PARA_NOTIFY_CHANGE_MOUNT_CMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			utempid = byte.readUnsignedInt();
			mountid = byte.readUnsignedInt();
		}
	}
}

//通知九屏更换坐骑
//const BYTE PARA_NOTIFY_CHANGE_MOUNT_CMD = 10; 
//struct stNotifyChangeMountCmd : public stMountCmd
//{   
//	stNotifyChangeMountCmd()
//	{   
//		byParam = PARA_NOTIFY_CHANGE_MOUNT_CMD;
//		utempid = mountid = 0;
//	}   
//	DWORD utempid;  //玩家tempid
//	DWORD mountid;
//};