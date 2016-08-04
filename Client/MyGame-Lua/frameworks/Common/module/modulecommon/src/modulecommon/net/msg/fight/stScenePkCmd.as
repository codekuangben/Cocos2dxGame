package modulecommon.net.msg.fight
{
	import common.net.msg.basemsg.stNullUserCmd;
	import common.net.endata.EnNet;
	/**
	 * ...
	 * @author 
	 */
	public class stScenePkCmd extends stNullUserCmd
	{
		public static const PARA_PRE_ATTACK_USERCMD:uint = 1;
		public static const PARA_ATTACK_USERCMD:uint = 2;
		public static const PARA_ATTACK_RESULT_USERCMD:uint = 3;
		public static const PARA_ATTACK_VICTORY_INFO_USERCMD:uint = 4;
		public static const PARA_PK_OVER_USERCMD:uint = 5;
		public static const PARA_PRE_PK_USERCMD:uint = 6;
		
		public function stScenePkCmd() 
		{
			byCmd = SCENEPK_CMD;
		}	
	}
}


//场景PK
//struct stScenePkCmd : public stNullUserCmd
//{   
	//stScenePkCmd()
	//{   
		//byCmd = SCENEPK_CMD;
	//}       
//};