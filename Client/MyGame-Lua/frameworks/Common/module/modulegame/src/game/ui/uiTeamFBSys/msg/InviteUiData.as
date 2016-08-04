package game.ui.uiTeamFBSys.msg
{
	import flash.utils.ByteArray;
	
	import common.net.endata.EnNet;

	public class InviteUiData
	{
		public var name:String;
		public var level:uint;
		public var zhanli:uint;
		
		public function deserialize(byte:ByteArray):void
		{
			name = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			level = byte.readUnsignedByte();
			zhanli = byte.readUnsignedInt();
		}
	}
}

//struct InviteUiData {
//	char name[MAX_NAMESIZE];
//	BYTE level;
//	DWORD zhanli;
//};