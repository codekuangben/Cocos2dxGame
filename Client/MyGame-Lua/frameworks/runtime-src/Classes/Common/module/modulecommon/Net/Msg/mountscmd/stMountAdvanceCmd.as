package modulecommon.net.msg.mountscmd
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.mountscmd.stMountCmd;
	
	/**
	 * ...
	 * @author ...
	 */
	public class stMountAdvanceCmd extends stMountCmd
	{
		public var mountid:uint;

		public function stMountAdvanceCmd() 
		{
			super();
			byParam = stMountCmd.PARA_MOUNT_ADVANCE_CMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeUnsignedInt(mountid);
		}
	}
}

////坐骑进阶
//const BYTE PARA_MOUNT_ADVANCE_CMD = 6;
//struct stMountAdvanceCmd : public stMountCmd
//{
	//stMountAdvanceCmd()
	//{
		//byParam = PARA_MOUNT_ADVANCE_CMD;
		//mountid = 0;
	//}
	//DWORD mountid;
//};