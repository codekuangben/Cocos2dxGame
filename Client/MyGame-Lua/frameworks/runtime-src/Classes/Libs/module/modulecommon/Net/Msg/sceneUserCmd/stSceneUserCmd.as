package modulecommon.net.msg.sceneUserCmd
{
	//import common.net.endata.EnNet;
	import common.net.msg.basemsg.stNullUserCmd;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class stSceneUserCmd extends stNullUserCmd 
	{
		
		public function stSceneUserCmd() 
		{
			super();
			byCmd = SCENE_USERCMD;
		}
		
		public static function initMsg():void
		{
			pushDic(SceneUserParam.NPCMOVE_MOVE_USERCMD_PARA, "stNpcMoveUserCmd--stSceneUserCmd");
			pushDic(SceneUserParam.PARA_SET_USERSTATE_USERCMD, "stSetUserStateCmd--stSceneUserCmd");
		}
		
		public static function pushDic(param:uint, name:String):void
		{
			s_dicMsg[s_toKey(SCENE_USERCMD, param)] = name;
		}
		
	}

}