package game.ui.uimysteryshop
{
	import flash.display.DisplayObjectContainer;
	import modulecommon.GkContext;	
	import game.ui.uimysteryshop.CommodityObject;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.prop.object.ObjectPanel;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author 
	 */
	public class CommodityPanel_Object extends CommodityPanel 
	{
		protected var m_commodityDataobject:CommodityObject;
		protected var m_objPanel:ObjectPanel;
		protected var objZ:ZObject;
		
		public function CommodityPanel_Object(data:DataShop, parent:DisplayObjectContainer=null,gk:GkContext=null, xpos:Number=0, ypos:Number=0) 
		{
			super(data, parent, gk, xpos, ypos);
			m_objPanel = new ObjectPanel(m_gkContext, this, 18, 18);
			m_objPanel.setPanelImageSkin(ZObject.IconBg);
			m_objPanel.showObjectTip = true;	
		}
		
		override public function setData(data:Object):void 
		{
			m_commodityDataobject = data as CommodityObject;
			objZ = ZObject.createClientObject(m_commodityDataobject.m_objid, m_commodityDataobject.m_num, m_commodityDataobject.m_namecolor);
			if (m_commodityDataobject.m_num == 1)
			{
				m_objPanel.objectIcon.showNum = false;
			}
			m_objPanel.objectIcon.setZObject(objZ);
			super.setData(data);
			upDataBtnandPanel();
		}

		//override public function upDataBtnandPanel():void 
		//{
			//super.upDataBtnandPanel();
			//if (m_gkContext.m_yizhelibaoMgr.isCommodityBuyed(m_commodityData.curTabLabel.m_id, m_commodityData.m_id))
			//{
			//	m_objPanel.becomeGray();
			//}
		//}
	}
}