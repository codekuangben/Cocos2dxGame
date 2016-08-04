package game.ui.uiScreenBtn.subcom 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	
	/**
	 * ...
	 * @author 
	 * 藏宝窟
	 */
	
	public class Cangbaoku extends FunBtnBase 
	{
		
		public function Cangbaoku(parent:DisplayObjectContainer = null) 
		{
			super(ScreenBtnMgr.Btn_CANGBAOKU, parent);
		}
		
		override public function onInit():void 
		{
			super.onInit();
			
			var num:uint = m_gkContext.m_cangbaokuMgr.remainedTimes;
			var type:int = ScreenBtnMgr.LBLCNTBGTYPE_Red;
			
			if (m_gkContext.m_cangbaokuMgr.baoxiangCount)
			{
				num = m_gkContext.m_cangbaokuMgr.baoxiangCount;
				type = ScreenBtnMgr.LBLCNTBGTYPE_Blue;
			}
			
			setLblCnt(num, type);
		}
		
		override public function onClick(e:MouseEvent):void 
		{
			super.onClick(e);
			if (m_gkContext.m_mapInfo.m_isInFuben)
			{
				m_gkContext.m_mapInfo.promptInFubenDesc();
				return;
			}
			
			m_gkContext.m_cangbaokuMgr.reqEnterCangbaoku();
		}
	}
}