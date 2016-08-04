package game.netmsg.sceneUserCmd
{
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author 
	 */
	public class stAutoMoveUserCmd extends stSceneUserCmd
	{
		public var size:uint;
		public var param:String;
		
		public function stAutoMoveUserCmd()
		{
			super();
			byParam = SceneUserParam.AUTO_MOVE_USERCMD_PARA;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			size = byte.readUnsignedShort();
			param = byte.readMultiByte(size, EnNet.UTF8)
		}
	}
}


//const BYTE AUTO_MOVE_USERCMD_PARA = 19; 
//struct stAutoMoveUserCmd : public stSceneUserCmd
//{   
//	stAutoMoveUserCmd()
//	{   
//		byParam = AUTO_MOVE_USERCMD_PARA;
//		size = 0;
//	}   
//	WORD size;
//	char param[0];  //命令行 //"goto mapid=1001 x=52 y=25 dir=0"
//	WORD getSize()
//	{   
//		return sizeof(*this) + size;
//	}
//};