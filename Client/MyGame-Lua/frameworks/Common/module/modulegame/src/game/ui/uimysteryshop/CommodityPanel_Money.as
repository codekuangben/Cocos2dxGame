package game.ui.uimysteryshop
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.object.ObjectPanel;
	import game.ui.uimysteryshop.CommodityMoney;
	import modulecommon.scene.prop.object.ZObject;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	
	/**
	 * ...
	 * @author 
	 */
	public class CommodityPanel_Money extends CommodityPanel 
	{
		protected var m_commodityDatamoney:CommodityMoney;
		protected var m_objPanel:ObjectPanel;
		
		public function CommodityPanel_Money(data:DataShop, parent:DisplayObjectContainer=null,gk:GkContext=null, xpos:Number=0, ypos:Number=0) 
		{
			super(data, parent, gk, xpos, ypos);
			
			m_objPanel = new ObjectPanel(m_gkContext, this, 18, 18);
			m_objPanel.setPanelImageSkin(ZObject.IconBg);
			//m_objPanel.showObjectTip = true;			
			m_objPanel.objectIcon.showNum = false;
			
			var objZ:ZObject = ZObject.createClientObject(2003);
			m_objPanel.objectIcon.setZObject(objZ);
			
			m_objPanel.addEventListener(MouseEvent.ROLL_OVER, onMouseObjPanelEnter);
			m_objPanel.addEventListener(MouseEvent.ROLL_OUT, onMouseObjPanelLeave);
		}
		
		public override function setData(data:Object):void 
		{
			super.setData(data);
			m_commodityDatamoney = data as CommodityMoney;	
			upDataBtnandPanel();
		}
		
		private function onMouseObjPanelEnter(e:MouseEvent):void
		{
			var pt:Point = this.localToScreen();
			UtilHtml.beginCompose();
			var str:String = UtilHtml.formatBold("直接获得 " + m_commodityDatamoney.m_num + " 银币");
			UtilHtml.add(str, UtilColor.GRAY);
			m_gkContext.m_uiTip.hintHtiml(pt.x,pt.y, UtilHtml.getComposedContent(),266, true);			
		}
		
		private function onMouseObjPanelLeave(e:MouseEvent):void
		{
			m_gkContext.m_uiTip.hideTip();
		}
		
		//override public function upDataBtnandPanel():void 
		//{
		//	super.upDataBtnandPanel();
		//	if (m_gkContext.m_yizhelibaoMgr.isCommodityBuyed(m_commodityData.curTabLabel.m_id, m_commodityData.m_id))
		//	{
		//		m_objPanel.becomeGray();
		//	}
		//}
	}
}