package game.ui.uiZhenfa.netmsg 
{
	import modulecommon.net.msg.sceneHeroCmd.stSceneHeroCmd;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class stSmartSetJinNangCmd extends stSceneHeroCmd 
	{
		
		public function stSmartSetJinNangCmd() 
		{
			byParam = PARA_SMART_SET_JINNANG_USERCMD;
		}
		
	}

}
/*
 * //智能设置锦囊
	const BYTE PARA_SMART_SET_JINNANG_USERCMD = 10;
	struct stSmartSetJinNangCmd : public stSceneHeroCmd
	{
		stSmartSetJinNangCmd()
		{
			byParam = PARA_SMART_SET_JINNANG_USERCMD;
		}
	};
*/