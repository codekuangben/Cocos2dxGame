package modulecommon.net.msg.corpscmd
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.corpscmd.stCorpsCmd;

	public class reqIntoCitySceneUserCmd extends stCorpsCmd
	{
		public var city:uint;

		public function reqIntoCitySceneUserCmd()
		{
			super();
			byParam = stCorpsCmd.REQ_INTO_CITY_SCENE_USERCMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeShort(city);
		}
	}
}

//请求进入某个城市地图 c->s
//const BYTE REQ_INTO_CITY_SCENE_USERCMD = 84;
//struct reqIntoCitySceneUserCmd : public stCorpsCmd
//{    
//	reqIntoCitySceneUserCmd()
//	{    
//		byParam = REQ_INTO_CITY_SCENE_USERCMD;
//		city = 0; 
//		type = 0; 
//	}    
//	WORD city;//城市id
//};