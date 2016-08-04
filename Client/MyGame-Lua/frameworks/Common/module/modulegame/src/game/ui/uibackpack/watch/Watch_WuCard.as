package game.ui.uibackpack.watch 
{
	import game.ui.uibackpack.wujiang.WuCardBase;
	import modulecommon.GkContext;
	import flash.display.DisplayObjectContainer;
	import game.ui.uibackpack.wujiang.WuRelationPanelBase;
	/**
	 * ...
	 * @author 
	 */
	public class Watch_WuCard extends WuCardBase 
	{		
		public function Watch_WuCard(wurp:WuRelationPanelBase, gk:GkContext, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0) 
		{
			super(wurp,gk,parent,xpos,ypos);
		}
		
		public function cardPanelBecomeGray():void
		{
			m_cardPanel.becomeGray();
		}
		
	}

}