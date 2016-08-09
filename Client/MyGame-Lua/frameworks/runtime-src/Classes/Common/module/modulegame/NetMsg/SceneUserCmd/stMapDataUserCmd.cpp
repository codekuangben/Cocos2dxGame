package  game.netmsg.sceneUserCmd
{
	/**
	 * ...
	 * @author zouzhiqiang
	 * 
	 * //发送地图信息
		const BYTE MAP_DATA_USERCMD_PARA = 2;
		struct stMapDataUserCmd : public stSceneUserCmd
	{
		stMapDataUserCmd()
		{
			byParam = MAP_DATA_USERCMD_PARA;
		}

		DWORD width;    // 场景宽 
		DWORD height;    // 场景高 
		DWORD id;        //地图id
		DWORD battlemap;  // 战斗地图
		DWORD servermapconfigID;	//服务器地图配置文件ID;
		char mapname[MAX_NAMESIZE]; //地图名字
		char filename[MAX_NAMESIZE];  // 文件名称 
		char backmusic[MAX_NAMESIZE];   //背景音乐名字
		WORD x;   //跳转点
		WORD y;
	};
	 */
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	import common.net.endata.EnNet;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	public final class stMapDataUserCmd  extends stSceneUserCmd
	{
		public var width:uint;
		public var height:uint;
		public var id:uint;
		public var battlemap:uint;
		public var servermapconfigID:uint;
		public var mapname:String;
		public var filename:String;
		public var backmusic:String;
		public var x:uint;
		public var y:uint;
		
		public function stMapDataUserCmd() 
		{
			byParam = SceneUserParam.MAP_DATA_USERCMD_PARA;
		}
		override public function deserialize (byte:ByteArray) : void
		{
			super.deserialize(byte);
			width = byte.readUnsignedInt();
			height = byte.readUnsignedInt();
			id = byte.readUnsignedInt();
			battlemap = byte.readUnsignedInt();
			servermapconfigID = byte.readUnsignedInt();
			mapname = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			filename = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			backmusic = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			x = byte.readUnsignedShort();
			y = byte.readUnsignedShort();
		}
	}

}