package game.netmsg.mapobject.stmsg 
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	import com.util.UtilTools;
	/**
	 * ...
	 * @author 
	 */
	public class t_MapObjData 
	{
		public var thisid:uint;
		public var objid:uint;
		public var objname:String;
		public var x:uint;
		public var y:uint;
		public var num:uint;
		
		public function deserialize(byte:ByteArray):void
		{
			thisid = byte.readUnsignedInt();
			objid = byte.readUnsignedInt();
			objname = UtilTools.readStr(byte, EnNet.MAX_NAMESIZE);
			
			x = byte.readUnsignedShort();
			y = byte.readUnsignedShort();
			num = byte.readUnsignedInt();
		}
	}
}

//struct t_MapObjData
//{
    //DWORD thisid;
    //DWORD objid;
    //char objname[MAX_NAMESIZE];
    //WORD x;     //物品在地图上的坐标
    //WORD y;
    //DWORD num;
//};