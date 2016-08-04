package modulecommon.net.msg.mountscmd
{
	import flash.utils.ByteArray;	
	import modulecommon.net.msg.mountscmd.stMountCmd;

	/**
	 * ...
	 * @author ...
	 */
	public class stChangeUserMountCmd extends stMountCmd
	{
		public var mountid:uint;

		public function stChangeUserMountCmd() 
		{
			super();
			byParam = stMountCmd.PARA_CHANGE_USERMOUNT_CMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			mountid = byte.readUnsignedInt();
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeUnsignedInt(mountid);
		}
	}
}

//更换坐骑
//const BYTE PARA_CHANGE_USERMOUNT_CMD = 9;
//struct stChangeUserMountCmd : public stMountCmd
//{
	//stChangeUserMountCmd()
	//{
		//byParam = PARA_CHANGE_USERMOUNT_CMD;
		//mountid = 0;
	//}
	//DWORD mountid;
//};