package game.ui.uiTeamFBSys.iteamzx
{
	//import com.bit101.components.Panel;
	
	import flash.display.DisplayObjectContainer;
	//import flash.geom.Rectangle;
	
	import modulecommon.GkContext;
	import modulecommon.appcontrol.WuIcon;
	import ui.player.PlayerResMgr;
	import modulecommon.scene.beings.NpcBattleBaseMgr;
	import modulecommon.scene.wu.WuMainProperty;
	//import modulecommon.scene.wu.WuProperty;

	public class WuIconZX extends WuIcon
	{
		public function WuIconZX(gk:GkContext, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(gk, parent, xpos, ypos);
			showZhenwei = true;
		}
		
		public function setIconNameByMainWu(wu:WuMainProperty, resmgr:PlayerResMgr):void
		{
			showZhenwei = false;
			m_iconResName = NpcBattleBaseMgr.composeSquareHeadResName(resmgr.uiName(wu.m_uJob, wu.m_playerMain.gender));
			setResName(m_iconResName, 0, 0);
		}
	}
}