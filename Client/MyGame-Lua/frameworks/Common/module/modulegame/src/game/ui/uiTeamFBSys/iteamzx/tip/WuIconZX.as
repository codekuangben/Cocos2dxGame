package game.ui.uiTeamFBSys.iteamzx.tip
{
	import flash.display.DisplayObjectContainer;
	
	import modulecommon.GkContext;
	import modulecommon.appcontrol.WuIcon;
	import ui.player.PlayerResMgr;
	import modulecommon.scene.beings.NpcBattleBaseMgr;
	import modulecommon.scene.wu.WuMainProperty;
	import ui.player.PlayerResMgr;

	public class WuIconZX extends WuIcon
	{
		public function WuIconZX(gk:GkContext, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(gk, parent, xpos, ypos);
		}
		
		public function setIconNameByMainWu(wu:WuMainProperty, resmgr:PlayerResMgr):void
		{
			m_iconResName = NpcBattleBaseMgr.composeSquareHeadResName(resmgr.uiName(wu.m_uJob, wu.m_playerMain.gender));
			setResName(m_iconResName, 0, 0);
		}
	}
}