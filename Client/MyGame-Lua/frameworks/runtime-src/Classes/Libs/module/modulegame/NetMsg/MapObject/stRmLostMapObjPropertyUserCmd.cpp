package game.netmsg.mapobject
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.propertyUserCmd.stPropertyUserCmd;
	/**
	 * ...
	 * @author 
	 */
	public class stRmLostMapObjPropertyUserCmd extends stPropertyUserCmd
	{
		public var thisid:uint;
		public function stRmLostMapObjPropertyUserCmd() 
		{
			super();
			byParam = stPropertyUserCmd.ADD_LOST_MAPOBJECT_PROPERTY_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			thisid = byte.readUnsignedInt();
		}
	}
}

//删除地图上的掉落物品
//const BYTE RM_LOST_MAPOBJECT_PROPERTY_USERCMD = 11;
//struct stRmLostMapObjPropertyUserCmd : public stPropertyUserCmd
//{
	//stRmLostMapObjPropertyUserCmd()
	//{
		//byParam = RM_LOST_MAPOBJECT_PROPERTY_USERCMD;
	//}
	//DWORD thisid;
//};