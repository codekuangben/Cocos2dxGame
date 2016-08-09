package game.netmsg.sceneUserCmd.stmsg
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	/**
	 * ...
	 * @author 
	 */
	public class NpcDataPos 
	{
		public var npcid:uint;
		public var tempid:uint;
		public var name:String;
		
		public var x:uint;
		public var y:uint;
		public var dir:uint;
		public var isArmy:Boolean;
		
		public function deserialize(byte:ByteArray):void
		{
			npcid = byte.readUnsignedInt();
			tempid = byte.readUnsignedInt();
			name = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			x = byte.readShort();
			y = byte.readShort();
			dir = byte.readUnsignedByte();
			var data:uint = byte.readUnsignedByte();
			if (data == 1)
			{
				isArmy = true;
			}
			else
			{
				isArmy = false;
			}
		}
	}
}

//struct NpcDataPos
//{
	//DWORD npcid; 
	//DWORD tempid;
	//char name[MAX_NAMESIZE];
	//WORD x;
	//WORD y;
	//BYTE dir;
	// BYTE flag; //有兵团为1，没有为 0

//};