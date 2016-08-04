package game.ui.uibackpack.fastswapequips 
{
	import modulecommon.net.msg.sceneHeroCmd.ActiveHero;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.wu.WuProperty;
	import game.ui.uibackpack.wujiang.WuRelationPanelBase;
	import modulecommon.GkContext;	
	import flash.display.DisplayObjectContainer;	
	/**
	 * ...
	 * @author 
	 */
	public class Swap_WuRelationPanel extends WuRelationPanelBase 
	{
		protected var m_cardList:Vector.<Swap_WuCard>;
		public function Swap_WuRelationPanel(gk:GkContext, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(gk, parent, xpos, ypos);
			m_cardList = new Vector.<Swap_WuCard>();
		}
		public function setWu(wu:WuHeroProperty):void
		{
			m_wu = wu;
			var i:int;
			var wuCard:Swap_WuCard;
			var activeWu:ActiveHero;
			var left:int = m_cardList.length * WuProperty.SQUAREHEAD_WIDHT;
			for (i = 0; i < m_wu.m_vecActiveHeros.length; i++)
			{
				activeWu = m_wu.m_vecActiveHeros[i];
				wuCard = new Swap_WuCard(this, m_gkContext, m_cardParent, left);
				wuCard.setIDs(m_wu, activeWu);
				if (activeWu.bOwned == false)
				{
					wuCard.cardPanelBecomeGray();
				}
				m_cardList.push(wuCard);
				left += WuProperty.SQUAREHEAD_WIDHT;
			}		
			
			m_cardParent.x = (245 - wu.m_vecActiveHeros.length * WuProperty.SQUAREHEAD_WIDHT) / 2;
		}
	}

}