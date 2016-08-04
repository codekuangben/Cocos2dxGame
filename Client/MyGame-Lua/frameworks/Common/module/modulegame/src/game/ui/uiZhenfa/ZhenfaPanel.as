package game.ui.uiZhenfa 
{
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import game.ui.uiZhenfa.tips.ZhenweiIconTip;
	//import com.bit101.components.Label;
	import com.pblabs.engine.resource.SWFResource;
	
	import flash.display.DisplayObjectContainer;
	//import flash.display.Sprite;
	//import flash.geom.Point;
	
	import modulecommon.GkContext;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.scene.fight.ZhenfaMgr;
	import modulecommon.scene.wu.WuProperty;
	
	import game.ui.uiZhenfa.event.DragWuEvent;
	/**
	 * ...
	 * @author zouzhiqiang
	 * 代表阵法中的一个格子，负责显示具体内容
	 */
	public class ZhenfaPanel extends Component 
	{
		
		private var m_vecPanel:Vector.<zhenfaGrid>;
		private var m_vecPanelEV:Vector.<ZhenfaGridEV>;
		private var m_gkContext:GkContext;
		private var m_uiZhenfa:UIZhenfa;
		private var m_frontPanel:Panel;		//全军
		private var m_middlePanel:Panel;	//中军
		private var m_backPanel:Panel;		//后军
		private var m_zhenweiIconTip:ZhenweiIconTip;
		
		public function ZhenfaPanel(ui:UIZhenfa, parent:DisplayObjectContainer, gk:GkContext)
		{
			super(parent);
			m_uiZhenfa = ui;
			m_gkContext = gk;
			m_vecPanel = new Vector.<zhenfaGrid>(9);
			
			var iColum:int = 2;
			var iRow:int = 0;
			var left:int = 300;
			var top:int;
			var intervalH:int = 90 + 15;
			var intervalV:int = 90 + 10;
			var k:int = 0;
			var vecPos:Vector.<uint> = new Vector.<uint>(18);
			{
				vecPos[0] = 501;	vecPos[1] = 184;
				vecPos[2] = 438;	vecPos[3] = 248;
				vecPos[4] = 374;	vecPos[5] = 311;
				
				vecPos[6] = 390;	vecPos[7] = 184;				
				vecPos[8] = 328;	vecPos[9] = 248;
				vecPos[10] = 263;	vecPos[11] = 311;
				
				vecPos[12] = 278;	vecPos[13] = 184;
				vecPos[14] = 216;	vecPos[15] = 248;
				vecPos[16] = 151;	vecPos[17] = 311;
			}
			
			for (; iColum >= 0; iColum--)
			{
				top = 100;
				for (iRow = 0; iRow < 3; iRow++)
				{
					m_vecPanel[k] = new zhenfaGrid(m_uiZhenfa, this, vecPos[2*k], vecPos[2*k+1], m_gkContext, 3 - iColum, k);
					m_vecPanel[k].addEventListener(DragWuEvent.DROP_WU, onDropWu);
					k++;
					top += intervalV;
				}
				left -= intervalH;
			}
			
			m_vecPanelEV = new Vector.<ZhenfaGridEV>(9);
			for (k = 0; k < 9 ; k++)
			{
				m_vecPanelEV[k] = new ZhenfaGridEV(m_gkContext, this, m_vecPanel[k].x, m_vecPanel[k].y, m_vecPanel[k]);	
				m_vecPanelEV[k].addEventListener(DragWuEvent.DRAG_WU, onDragWu);
			}
			
			m_frontPanel = new Panel(this, 390, 375);
			m_frontPanel.addEventListener(MouseEvent.ROLL_OVER, onIconMouseRollOver);
			m_frontPanel.addEventListener(MouseEvent.ROLL_OUT, onIconMouseRollOut);
			m_frontPanel.tag = ZhenfaMgr.ZHENWEI_FRONT;
			
			m_middlePanel = new Panel(this, 277, 375);
			m_middlePanel.addEventListener(MouseEvent.ROLL_OVER, onIconMouseRollOver);
			m_middlePanel.addEventListener(MouseEvent.ROLL_OUT, onIconMouseRollOut);
			m_middlePanel.tag = ZhenfaMgr.ZHENWEI_MIDDLE;
			
			m_backPanel = new Panel(this, 164, 375);
			m_backPanel.addEventListener(MouseEvent.ROLL_OVER, onIconMouseRollOver);
			m_backPanel.addEventListener(MouseEvent.ROLL_OUT, onIconMouseRollOut);
			m_backPanel.tag = ZhenfaMgr.ZHENWEI_BACK;		
		}
		
		override public function dispose():void
		{
			var k:int = 0;
			var iColum:int = 2;
			var iRow:int = 0;
			for (; iColum >= 0; iColum--)
			{
				for (iRow = 0; iRow < 3; iRow++)
				{
					if(m_vecPanel[k])
					{
						m_vecPanel[k].removeEventListener(DragWuEvent.DROP_WU, onDropWu);
					}
					k++;
				}
			}
			
			for (k = 0; k < 9 ; k++)
			{
				if(m_vecPanelEV[k])
				{
					m_vecPanelEV[k].removeEventListener(DragWuEvent.DRAG_WU, onDragWu);
				}
			}
			
			if (m_zhenweiIconTip)
			{
				if (m_zhenweiIconTip.parent)
				{
					m_zhenweiIconTip.parent.removeChild(m_zhenweiIconTip);
				}
				
				m_zhenweiIconTip.dispose();
				m_zhenweiIconTip = null;
			}
			
			super.dispose();
		}
		
		public function unAttachTickMgr():void
		{
			for (var i:int; i < m_vecPanel.length; i++)
			{
				m_vecPanel[i].unAttachTickMgr();
			}
		}
		
		public function atachTickMgr():void
		{
			for (var i:int; i < m_vecPanel.length; i++)
			{
				m_vecPanel[i].atachTickMgr();
			}
		}
		
		public function initData():void
		{			
			var gridID:uint = ZhenfaMgr.ZHENFAGRID_NO1;
			var heroID:uint;
			for (; gridID <= ZhenfaMgr.ZHENFAGRID_NO9; gridID++)
			{
				heroID = m_gkContext.m_zhenfaMgr.getGrids(gridID);
				if (heroID)
				{
					setWuPos(heroID, gridID);
				}
			}
		}
		
		public function getZhenfaGrid(gridNO:int):zhenfaGrid
		{
			return m_vecPanel[gridNO];
		}
		
		public function openGrid(gridNo:int):void
		{
			m_vecPanel[gridNo].updateLock();
		}
		
		public function setWuPos(heroID:uint, gridNO:int):void
		{
			m_vecPanel[gridNO].setHero(heroID);
		}
		
		public function clearWuByPos(gridNO:int):void
		{
			m_vecPanel[gridNO].clearHero();
		}
		
		public function onDragWu(e:DragWuEvent):void
		{
			var wu:WuProperty = e.wu;		
			var k:int = 0;
			for (k = 0; k < m_vecPanel.length; k++)
			{
				m_vecPanel[k].onDragWu(wu);
			}
		}
		
		public function onDropWu(e:DragWuEvent):void
		{
			if (m_gkContext.m_newHandMgr.isVisible() 
				&& (SysNewFeatures.NFT_ZHENFA == m_gkContext.m_sysnewfeatures.m_nft || SysNewFeatures.NFT_FHLIMIT4 == m_gkContext.m_sysnewfeatures.m_nft))
			{
				m_gkContext.m_newHandMgr.hide();
				m_vecPanelEV[ZhenfaMgr.ZHENFAGRID_NO2].grid.toHightLight(false);
				m_vecPanelEV[ZhenfaMgr.ZHENFAGRID_NO8].grid.toHightLight(false);
			}
			
			var wu:WuProperty = e.wu;	
			var k:int = 0;
			for (k = 0; k < m_vecPanel.length; k++)
			{
				m_vecPanel[k].onDropWu(wu);
			}
		}
		
		public function createImage(res:SWFResource):void
		{
			var k:int = 0;
			for (k = 0; k < m_vecPanel.length; k++)
			{
				m_vecPanel[k].createImage(res);
			}
			
			m_frontPanel.setPanelImageSkinBySWF(res, "zhenfa.icon_front");
			m_middlePanel.setPanelImageSkinBySWF(res, "zhenfa.icon_middle");
			m_backPanel.setPanelImageSkinBySWF(res, "zhenfa.icon_back");
		}
		
		public function showNewHand():void
		{
			if (m_gkContext.m_newHandMgr.isVisible())
			{
				if (SysNewFeatures.NFT_ZHENFA == m_gkContext.m_sysnewfeatures.m_nft)
				{
					m_gkContext.m_newHandMgr.setFocusFrame(-12, -14, 92, 72, 1);
					m_gkContext.m_newHandMgr.prompt(false, 70, 48, "左键点击放入这里。", m_vecPanelEV[ZhenfaMgr.ZHENFAGRID_NO6]);//中右位置
					m_vecPanelEV[ZhenfaMgr.ZHENFAGRID_NO6].grid.toHightLight(true);
				}
				else if (SysNewFeatures.NFT_FHLIMIT4 == m_gkContext.m_sysnewfeatures.m_nft)
				{
					m_gkContext.m_newHandMgr.setFocusFrame(-12, -14, 92, 72, 1);
					m_gkContext.m_newHandMgr.prompt(false, 70, 48, "左键点击放入这里。", m_vecPanelEV[ZhenfaMgr.ZHENFAGRID_NO8]);//后中位置
					m_vecPanelEV[ZhenfaMgr.ZHENFAGRID_NO8].grid.toHightLight(true);
				}
				else
				{
					m_gkContext.m_newHandMgr.hide();
				}
			}
		}
		
		private function onIconMouseRollOver(event:MouseEvent):void
		{
			var panel:Panel = event.currentTarget as Panel;
			var pt:Point;
			
			for (var i:int = 1; i <= 3; i++)
			{
				m_vecPanelEV[panel.tag * 3 - i].grid.toHightLight(true);
			}
			
			if (null == m_zhenweiIconTip)
			{
				m_zhenweiIconTip = new ZhenweiIconTip(m_gkContext);
			}
			m_zhenweiIconTip.showTip(panel.tag);
			
			pt = panel.localToScreen(new Point(-228, 0));
			m_gkContext.m_uiTip.hintComponent(pt, m_zhenweiIconTip);
		}
		
		private function onIconMouseRollOut(event:MouseEvent):void
		{
			var panel:Panel = event.currentTarget as Panel;
			
			for (var i:int = 1; i <= 3; i++)
			{
				m_vecPanelEV[panel.tag * 3 - i].grid.toHightLight(false);
			}
			
			m_gkContext.m_uiTip.hideTip();
		}
	}

}