package game.netmsg.sceneUserCmd.stmsg
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class FakeUserDataPos 
	{
		public var udp:UserDataPos;
		public var zhanli:uint;

		public function deserialize(byte:ByteArray):void
		{
			udp ||= new UserDataPos;
			udp.deserialize(byte);
			zhanli = byte.readUnsignedInt();
		}
	}
}

//struct FakeUserDataPos
//{   
    //UserDataPos udp;
    //DWORD zhanli;
//};