package game.ui.uimysteryshop
{
	import flash.display.DisplayObjectContainer;
	import modulecommon.GkContext;
	import game.ui.uimysteryshop.CommodityWuxue;
	import modulecommon.scene.zhanxing.WuXueIcon;
	import modulecommon.scene.zhanxing.ZStar;
	
	/**
	 * ...
	 * @author 
	 */
	public class CommodityPanel_Wuxue extends CommodityPanel 
	{
		protected var m_commodityDatawuxue:CommodityWuxue;
		protected var m_wuxuePanel:WuXueIcon;
		
		public function CommodityPanel_Wuxue(data:DataShop, parent:DisplayObjectContainer=null,gk:GkContext=null, xpos:Number=0, ypos:Number=0) 
		{
			super(data, parent, gk, xpos, ypos);
			m_wuxuePanel = new WuXueIcon(m_gkContext, this, 6, 9);			
		}
		
		public override function setData(data:Object):void 
		{
			m_commodityDatawuxue = data as CommodityWuxue;
			super.setData(data);
			var wuxue:ZStar = ZStar.createClientStar(m_commodityDatawuxue.m_wxid);
			m_wuxuePanel.setZStar(wuxue);
			upDataBtnandPanel();
		}
		
		//override public function upDataBtnandPanel():void 
		//{
		//	super.upDataBtnandPanel();
		//	if (m_gkContext.m_yizhelibaoMgr.isCommodityBuyed(m_commodityData.curTabLabel.m_id, m_commodityData.m_id))
		//	{
		//		m_wuxuePanel.becomeGray();
		//	}
		//}
	}
}