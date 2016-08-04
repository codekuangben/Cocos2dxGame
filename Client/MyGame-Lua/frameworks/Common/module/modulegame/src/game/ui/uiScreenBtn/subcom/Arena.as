package game.ui.uiScreenBtn.subcom 
{
	/**
	 * ...
	 * @author 
	 * 竞技场,又名武举擂台
	 */
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.GkContext;
	import modulecommon.scene.arena.ArenaMgr;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import game.ui.uiScreenBtn.UIScreenBtn;

	
	public class Arena extends FunBtnBase 
	{
		public function Arena(parent:DisplayObjectContainer = null) 
		{
			super(ScreenBtnMgr.Btn_Arena, parent);
		}
		
		override public function onInit():void 
		{
			super.onInit();
			
			setLblCnt(m_gkContext.m_arenaMgr.leftPkCounts);
			if (ArenaMgr.SALARYSTATE_NORECEIVED == m_gkContext.m_arenaMgr.receiveSalaryState)
			{
				showEffectAni();
			}
		}
		
		override public function onClick(e:MouseEvent):void 
		{
			super.onClick(e);
			
			m_gkContext.m_arenaMgr.enterArena();
		}
	}
}