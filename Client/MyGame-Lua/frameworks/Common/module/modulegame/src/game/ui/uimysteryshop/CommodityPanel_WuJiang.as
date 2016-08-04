package game.ui.uimysteryshop
{
	import flash.display.DisplayObjectContainer;
	import modulecommon.GkContext;
	import game.ui.uimysteryshop.CommodityHero;
	import com.bit101.components.PanelContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author 
	 */
	public class CommodityPanel_WuJiang extends CommodityPanel 
	{
		protected var m_commodityDataobject:CommodityHero;
		protected var m_wjPanel:PanelContainer;
		
		public function CommodityPanel_WuJiang(data:DataShop, parent:DisplayObjectContainer=null,gk:GkContext=null, xpos:Number=0, ypos:Number=0) 
		{
			super(data, parent, gk, xpos, ypos);
			m_wjPanel = new PanelContainer(this, 11,18);
			m_wjPanel.setSize(50, 62);
			m_wjPanel.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
			m_wjPanel.addEventListener(MouseEvent.ROLL_OUT, m_gkContext.hideTipOnMouseOut);			
		}
		
		public override function setData(data:Object):void 
		{
			super.setData(data);
			m_commodityDataobject = data as CommodityHero;
			m_wjPanel.setPanelImageSkin(m_gkContext.m_npcBattleBaseMgr.squareHeadResName(m_commodityDataobject.m_heroid));
			upDataBtnandPanel();			
		}
		
		private function onMouseRollOver(event:MouseEvent):void
		{
			if (event.currentTarget != m_wjPanel)
			{
				return;
			}
			
			var pt:Point = m_wjPanel.localToScreen(new Point(m_wjPanel.width, 0));
			m_gkContext.m_uiTip.hintWuBaseInfo(pt, m_commodityDataobject.m_heroid);
		}
		
		//override public function upDataBtnandPanel():void 
		//{
		//	super.upDataBtnandPanel();
		//	if (m_gkContext.m_yizhelibaoMgr.isCommodityBuyed(m_commodityData.curTabLabel.m_id, m_commodityData.m_id))
		//	{
		//		m_wjPanel.becomeGray();
		//	}
		//}
	}
}