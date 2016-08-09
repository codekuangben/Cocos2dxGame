package game.netmsg.mapobject
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.propertyUserCmd.stPropertyUserCmd;
	/**
	 * ...
	 * @author 
	 */
	public class stRmMapObjPropertyUserCmd extends stPropertyUserCmd
	{
		public var thisid:uint;
		
		public function stRmMapObjPropertyUserCmd() 
		{
			super();
			byParam = stPropertyUserCmd.RM_MAPOBJECT_PROPERTY_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			thisid = byte.readUnsignedInt();
		}
	}
}

//地图上删除物品
//const BYTE RM_MAPOBJECT_PROPERTY_USERCMD = 9;
//struct stRmMapObjPropertyUserCmd : public stPropertyUserCmd
//{
    //stRmMapObjPropertyUserCmd()
    //{
        //byParam = RM_MAPOBJECT_PROPERTY_USERCMD;
    //}
    //DWORD thisid;
//};