package game.netmsg.mountcmd
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.mountscmd.stMountCmd;
	import modulecommon.net.msg.mountscmd.stMountData;
	
	/**
	 * ...
	 * @author ...
	 */
	public class stAddMountToUserCmd extends stMountCmd
	{
		public var action:uint;
		public var mount:stMountData;
		
		public function stAddMountToUserCmd() 
		{
			super();
			byParam = stMountCmd.PARA_ADD_MOUNT_TO_USER_CMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			action = byte.readUnsignedByte();
			mount = new stMountData();
			mount.deserialize(byte);
		}
	}
}

//增加一个坐骑
//const BYTE PARA_ADD_MOUNT_TO_USER_CMD = 5;
//struct stAddMountToUserCmd : public stMountCmd
//{
	//stAddMountToUserCmd()
	//{
		//byParam = PARA_ADD_MOUNT_TO_USER_CMD;
		//action = 0;
		//bzero(&mount,sizeof(mount));
	//}
	//BYTE action;	//0-加入 1-刷新
	//stMountData mount;
//};