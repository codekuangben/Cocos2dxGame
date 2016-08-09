package modulecommon.net.msg.mountscmd
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.mountscmd.stMountCmd;
	
	/**
	 * ...
	 * @author ...
	 */
	public class stActiveMountCmd extends stMountCmd
	{
		public var mountid:uint;
		
		public function stActiveMountCmd() 
		{
			super();
			byParam = stMountCmd.PARA_ACTIVE_MOUNT_CMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeUnsignedInt(mountid);
		}
	}
}


////激活坐骑
//const BYTE PARA_ACTIVE_MOUNT_CMD = 4;
//struct stActiveMountCmd : public stMountCmd
//{
	//stActiveMountCmd()
	//{
		//byParam = PARA_ACTIVE_MOUNT_CMD;
	//}
	//DWORD mountid;
//};