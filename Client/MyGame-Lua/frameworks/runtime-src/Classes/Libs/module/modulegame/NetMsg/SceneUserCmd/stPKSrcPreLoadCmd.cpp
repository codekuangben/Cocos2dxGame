package game.netmsg.sceneUserCmd
{
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	
	public class stPKSrcPreLoadCmd extends stSceneUserCmd
	{
		public var type:uint;
		public var size:uint;
		public var names:String;
		
		public function stPKSrcPreLoadCmd()
		{
			byParam = SceneUserParam.PK_SRC_PRELOAD_USERCMD;
		}
		
		override public function deserialize (byte:ByteArray) : void
		{
			super.deserialize(byte);
			type = byte.readUnsignedByte();
			size = byte.readUnsignedShort();
			
			names = byte.readMultiByte(size, EnNet.UTF8);
		}
	}
}


//PK资源预加载
//const BYTE PK_SRC_PRELOAD_USERCMD = 37; 
//struct stPKSrcPreLoadCmd : public stSceneUserCmd
//{   
//	stPKSrcPreLoadCmd()
//	{
//		byParam = PK_SRC_PRELOAD_USERCMD;
//		type = 0;
//		size = 0;
//	}
//	BYTE type;
//	WORD size;
//	char names[0];
//};