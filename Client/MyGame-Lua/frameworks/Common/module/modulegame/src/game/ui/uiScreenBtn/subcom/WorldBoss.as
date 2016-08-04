package game.ui.uiScreenBtn.subcom 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	/**
	 * ...
	 * @author ...
	 * 世界boss
	 */
	public class WorldBoss extends FunBtnBase
	{
		public function WorldBoss(parent:DisplayObjectContainer=null)
		{
			super(ScreenBtnMgr.Btn_WorldBoss, parent);
		}
		
		override public function onInit():void 
		{
			super.onInit();
			setLblCnt(m_gkContext.m_worldBossMgr.leftJoinTimes);
		}
		
		override public function onClick(e:MouseEvent):void 
		{
			super.onClick(e);
			
			m_gkContext.m_worldBossMgr.reqEnterWorldBoss();
		}
	}

}