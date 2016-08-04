package game.ui.uiScreenBtn.subcom 
{
	/**
	 * ...
	 * @author 
	 * 单击此按钮，打开精英关卡选择界面
	 */
	import flash.events.MouseEvent;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.ui.UIFormID;
	import game.ui.uiScreenBtn.UIScreenBtn;
	import flash.display.DisplayObjectContainer;
	
	public class EliteBarrier extends FunBtnBase 
	{
		
		public function EliteBarrier(parent:DisplayObjectContainer = null) 
		{
			super(ScreenBtnMgr.Btn_EliteBarrier, parent);
		}
		
		override public function onInit():void 
		{
			super.onInit();
			setLblCnt(m_gkContext.m_elitebarrierMgr.m_lfBossNum);
		}
		
		override public function onClick(e:MouseEvent):void 
		{
			super.onClick(e);
			if (m_gkContext.m_elitebarrierMgr.m_lfBossNum < 1)
			{
				m_gkContext.m_systemPrompt.prompt("精英boss挑战次数用完");
			}
			else
			{
				m_gkContext.m_elitebarrierMgr.reqEnterJBoss();
			}
		}
		
		
	}

}