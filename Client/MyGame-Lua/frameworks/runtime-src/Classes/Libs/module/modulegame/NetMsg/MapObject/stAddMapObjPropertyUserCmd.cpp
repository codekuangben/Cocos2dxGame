package game.netmsg.mapobject
{
	import flash.utils.ByteArray;
	import game.netmsg.mapobject.stmsg.t_MapObjData;
	import modulecommon.net.msg.propertyUserCmd.stPropertyUserCmd;
	/**
	 * ...
	 * @author 
	 */
	public class stAddMapObjPropertyUserCmd extends stPropertyUserCmd
	{
		public var action:uint;
		public var data:t_MapObjData;
		
		public function stAddMapObjPropertyUserCmd() 
		{
			super();
			byParam = stPropertyUserCmd.ADD_MAPOBJECT_PROPERTY_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			action = byte.readUnsignedByte();
			data ||= new t_MapObjData();
			data.deserialize(byte);
		}
	}
}

//地图上增加物品
//const BYTE ADD_MAPOBJECT_PROPERTY_USERCMD = 8;
//struct stAddMapObjPropertyUserCmd : public stPropertyUserCmd
//{
    //stAddMapObjPropertyUserCmd()
    //{
        //byParam = ADD_MAPOBJECT_PROPERTY_USERCMD;
    //}
    //BYTE action;
    //t_MapObjData data;
//};