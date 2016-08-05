package game.netmsg.sceneUserCmd.stmsg
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	import modulecommon.scene.beings.UserState;
	import com.util.UtilTools;
	/**
	 * ...
	 * @author 
	 */
	public class UserDataPos 
	{
		public var charid:uint;
		public var tempid:uint;
		public var name:String;
		public var platform:uint;
		public var zoneID:uint;
		public var x:uint;
		public var y:uint;
		public var dir:uint;
		public var sex:uint;
		public var job:uint;
		public var speed:uint;
		public var level:uint;
		public var vipscore:uint;
		public var mountid:uint;
		public var states:Vector.<uint>; 
		public var corpsname:String;
		public var guanzhi:String;
		
		public function deserialize(byte:ByteArray):void
		{
			charid = byte.readUnsignedInt();
			tempid = byte.readUnsignedInt();
			platform = byte.readUnsignedShort();
			zoneID = byte.readUnsignedShort();
			name = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);			
			x = byte.readShort();
			y = byte.readShort();
			dir = byte.readUnsignedByte();
			sex = byte.readUnsignedByte();
			job = byte.readUnsignedByte();
			speed = byte.readUnsignedByte();
			level = byte.readUnsignedByte();
			vipscore = byte.readUnsignedInt();
			mountid = byte.readUnsignedInt();
			
			states = UserState.createStates();
			states[0] = byte.readUnsignedInt();
			corpsname = UtilTools.readStr(byte, EnNet.MAX_NAMESIZE);
			guanzhi = UtilTools.readStr(byte, EnNet.MAX_NAMESIZE);
		}
	}
}

//struct UserDataPos
//{
	//DWORD charid;
    //DWORD tempid;
    //char name[MAX_NAMESIZE]; 
	//WORD game;
    //WORD zone;
    //WORD x;
    //WORD y;
    //BYTE dir;
	//BYTE sex;
    //BYTE speed;
	//BYTE level;
	//DWORD vipscore;
	//DWORD mountid;
	//DWORD states;
	//char corpsname[MAX_NAMESIZE];
	//char guanzhi[MAX_NAMESIZE];
//};