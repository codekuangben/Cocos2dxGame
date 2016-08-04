package game.ui.uiTeamFBSys.msg
{
	import flash.utils.ByteArray;
	
	import common.net.endata.EnNet;

	public class UnFullCopyData
	{
		public var name:String;
		public var copytempid:uint; 
		public var level:uint;
		public var num:uint;
		
		public function deserialize(byte:ByteArray):void
		{
			name = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			copytempid = byte.readUnsignedInt();
			level = byte.readUnsignedByte();
			num = byte.readUnsignedByte();
		}
	}
}

//struct UnFullCopyData {
//	char name[MAX_NAMESIZE];
//	DWORD copytempid;
//	BYTE level;
//	BYTE num; //人数
//};