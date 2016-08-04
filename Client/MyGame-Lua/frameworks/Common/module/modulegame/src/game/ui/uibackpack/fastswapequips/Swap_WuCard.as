package game.ui.uibackpack.fastswapequips 
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import game.ui.uibackpack.wujiang.WuCardBase;
	import modulecommon.GkContext;
	import flash.display.DisplayObjectContainer;
	import game.ui.uibackpack.wujiang.WuRelationPanelBase;
	/**
	 * ...
	 * @author 
	 */
	public class Swap_WuCard extends WuCardBase 
	{		
		public function Swap_WuCard(wurp:WuRelationPanelBase, gk:GkContext, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0) 
		{
			super(wurp,gk,parent,xpos,ypos);
		}
		
		public function cardPanelBecomeGray():void
		{
			m_cardPanel.becomeGray();
		}
		
		override protected function onActiveHeroMouseOver(event:MouseEvent):void
		{			
			m_gkContext.m_wuMgr.showWuMouseOverPanel(this);
			if (!m_gkContext.m_newHandMgr.isVisible())
			{
				var localP:Point = new Point(0, m_cardPanel.height);
				var pt:Point = this.localToScreen(localP);
				
				m_gkContext.m_uiTip.hintActiveWu(pt, m_wuMain.m_uHeroID, m_activeHero.tableID);
			}
		}
	}

}