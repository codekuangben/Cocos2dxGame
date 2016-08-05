package game.netmsg.sceneUserCmd
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	
	/**
	 * @author ...
	 */
	public class updateTrialTowerMapNameCmd extends stSceneUserCmd
	{
		public var mapid:uint;

		public function updateTrialTowerMapNameCmd() 
		{
			super();
			byParam = SceneUserParam.UPDATE_TRIAL_TOWER_MAP_NAME_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			mapid = byte.readUnsignedInt();
		}
	}
}

//更新过关斩将地图名
//const BYTE UPDATE_TRIAL_TOWER_MAP_NAME_USERCMD = 69;
//struct updateTrialTowerMapNameCmd : public stSceneUserCmd
//{    
	//updateTrialTowerMapNameCmd()
	//{    
		//byParam = UPDATE_TRIAL_TOWER_MAP_NAME_USERCMD;
		//bzero(name, MAX_NAMESIZE);
	//}    
	//DWORD mapid;		// 这个是地图的 id ，客户端根据 id 自己拼名字，参考 UIMapName MTGGZJ 的处理
//};