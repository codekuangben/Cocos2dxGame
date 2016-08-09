package modulecommon.net.msg.mountscmd
{
	import flash.utils.ByteArray;

	public class stSetRideMountStateCmd extends stMountCmd
	{
		public var isset:uint;

		public function stSetRideMountStateCmd()
		{
			super();
			byParam = stMountCmd.PARA_SET_RIDE_MOUNT_STATE_CMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeByte(isset);
		}
	}
}

//设置骑乘状态
//const BYTE PARA_SET_RIDE_MOUNT_STATE_CMD = 11; 
//struct stSetRideMountStateCmd : public stMountCmd
//{   
//	stSetRideMountStateCmd()
//	{   
//		byParam = PARA_SET_RIDE_MOUNT_STATE_CMD;
//		isset = 0;
//	}   
//	BYTE isset; //0:取消 1:骑乘
//};  