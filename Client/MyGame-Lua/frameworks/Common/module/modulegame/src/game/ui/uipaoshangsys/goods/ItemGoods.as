package game.ui.uipaoshangsys.goods
{
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import game.ui.uipaoshangsys.DataPaoShang;
	import modulecommon.scene.prop.object.ObjectPanel;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.uiinterface.IUIPaoShangSys;
	/**
	 * @brief 一项货物
	 */
	public class ItemGoods extends Component
	{
		public var m_DataPaoShang:DataPaoShang;
		protected var m_idx:uint;
		
		public var m_pnlBg:Panel;
		public var m_pnlicon:ObjectPanel;	// 装备图标
		public var m_pnlTop:Panel;
		
		public function ItemGoods(data:DataPaoShang, idx:uint, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			m_DataPaoShang = data;
			super(parent, xpos, ypos);
			m_idx = idx;
			
			m_pnlBg = new Panel(this, -16, -16);
			//m_pnlBg.setPanelImageSkin("module/benefithall/jlzhaohui/yanbaozhaohui.png");
			
			// 设置物品面板
			m_pnlicon = new ObjectPanel(m_DataPaoShang.m_gkcontext, this);
			m_pnlicon.setPos(0, 0);
			m_pnlicon.setSize(ZObject.IconBgSize, ZObject.IconBgSize);
			m_pnlicon.autoSizeByImage = false;
			m_pnlicon.setPanelImageSkin(ZObject.IconBg);
			
			m_pnlicon.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			m_pnlicon.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			
			m_pnlTop = new Panel(this, 24, -18);
			//m_pnlTop.setPanelImageSkin("module/benefithall/jlzhaohui/yanbaozhaohui.png");
		}

		override public function dispose():void
		{
			if (m_pnlicon)
			{
				m_pnlicon.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
				m_pnlicon.removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			}
			
			super.dispose();
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			m_DataPaoShang.m_gkcontext.m_uiTip.hideTip();
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			var pt:Point;
			if (event.currentTarget is ObjectPanel)
			{
				var panel:ObjectPanel = event.currentTarget as ObjectPanel;
				pt = panel.localToScreen();
				
				var obj:ZObject = panel.objectIcon.zObject;
				if (obj != null)
				{
					m_DataPaoShang.m_gkcontext.m_uiTip.hintObjectInfo(pt, obj);
				}
			}
		}
		
		public function updateRes():void
		{
			if (m_DataPaoShang.m_basicInfo && m_DataPaoShang.m_basicInfo.m_goodsLst && m_DataPaoShang.m_basicInfo.m_goodsLst[m_idx])
			{
				if ((m_DataPaoShang.m_form as IUIPaoShangSys).isResReady())
				{
					if (m_DataPaoShang.m_basicInfo.m_goodsLst[m_idx].m_bgType == 1)
					{
						m_pnlBg.visible = true;
						m_pnlBg.setPanelImageSkinBySWF(m_DataPaoShang.m_form.swfRes, "uipaoshang.jinenggezihongse");
					}
					else if (m_DataPaoShang.m_basicInfo.m_goodsLst[m_idx].m_bgType == 2)
					{
						m_pnlBg.visible = true;
						m_pnlBg.setPanelImageSkinBySWF(m_DataPaoShang.m_form.swfRes, "uipaoshang.jinenggeziguang");
					}
					else
					{
						m_pnlBg.visible = false;
					}
					
					var obj:ZObject;
					var objid:uint;
					obj = ZObject.createClientObject(m_DataPaoShang.m_basicInfo.m_goodsLst[m_idx].m_goodsID);
					m_pnlicon.objectIcon.setZObject(obj);
					m_pnlicon.objectIcon.showNum = false;
					
					if (m_DataPaoShang.m_basicInfo.m_goodsLst[m_idx].m_bBest)
					{
						m_pnlTop.visible = true;
						m_pnlTop.setPanelImageSkinBySWF(m_DataPaoShang.m_form.swfRes, "uipaoshang.dingji");
					}
					else
					{
						m_pnlTop.visible = false;
					}
				}
			}
		}
	}
}