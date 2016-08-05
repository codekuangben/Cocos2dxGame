package game.netmsg.mapobject
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.propertyUserCmd.stPropertyUserCmd;
	import common.net.endata.EnNet;
	/**
	 * ...
	 * @author 
	 */
	public class stAddLostMapObjPropertyUserCmd extends stPropertyUserCmd
	{
		public var id:uint;
		public var thisid:uint;
		public var name:String;
		public var x:uint;
		public var y:uint;
		public var type:int;
		public var num:int;
		
		public function stAddLostMapObjPropertyUserCmd() 
		{
			super();
			byParam = stPropertyUserCmd.RM_LOST_MAPOBJECT_PROPERTY_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			id = byte.readUnsignedInt();
			thisid = byte.readUnsignedInt();
			name = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			x = byte.readUnsignedInt();
			y = byte.readUnsignedInt();
			
			type = byte.readUnsignedByte();
			num = byte.readUnsignedInt();
		}
	}
}

//地图上增加掉落物品
//const BYTE ADD_LOST_MAPOBJECT_PROPERTY_USERCMD = 10;
//struct stAddLostMapObjPropertyUserCmd : public stPropertyUserCmd
//{
	//stAddLostMapObjPropertyUserCmd()
	//{
		//byParam = ADD_LOST_MAPOBJECT_PROPERTY_USERCMD;
		//id = thisid = x = y;
	//}
	//DWORD id;
	//DWORD thisid;
	//char name[MAX_NAMESIZE];
	//DWORD x;
	//DWORD y;
	//BYTE type;
    //DWORD num;

//};