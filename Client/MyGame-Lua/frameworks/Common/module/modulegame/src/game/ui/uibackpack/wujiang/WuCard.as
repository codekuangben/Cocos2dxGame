package game.ui.uibackpack.wujiang
{
	import com.bit101.components.PushButton;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.GkContext;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.net.msg.sceneHeroCmd.ActiveHero;
	import modulecommon.scene.jiuguan.ItemPurpleWu;
	import modulecommon.scene.prop.table.TNpcBattleItem;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.wu.WuProperty;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIRecruit;
	import game.ui.uibackpack.UIBackPack;
	
	/**
	 * ...
	 * @author
	 */
	public class WuCard extends WuCardBase
	{
		public static const BTNRES_Zhao:String = "commoncontrol/button/buttonzhao.swf";
		public static const BTNRES_Zhuan:String = "commoncontrol/button/buttonzhuan.swf";
		public static const BTNRES_Xiaye:String = "commoncontrol/button/buttonye.swf";
		protected var m_btnZhao:PushButton;
		
		public function WuCard(wurp:WuRelationPanelBase, gk:GkContext, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(wurp, gk, parent, xpos, ypos);
			addEventListener(MouseEvent.CLICK, onActiveHeroMouseClick);
		}
		
		override public function setIDs(wu:WuHeroProperty, activeHero:ActiveHero):void
		{
			super.setIDs(wu, activeHero);
			update();
		}
		
		public function update():void
		{
			//这个函数更新2方面的状态: 1.卡片本身是否是灰色, 2. 卡片上按钮的状态
			var needZhaoBtn:Boolean = false;
			var needZhuanBtn:Boolean = false;
			var wu:WuHeroProperty = m_gkContext.m_wuMgr.getWuByHeroID(m_activeHero.id) as WuHeroProperty;
			
			//1.卡片本身是否是灰色
			if (wu && wu.xiaye == false)
			{
				m_cardPanel.becomeUnGray();
			}
			else
			{
				m_cardPanel.becomeGray();
			}
			
			//2. 卡片上按钮的状态
			var activeWuState:uint = m_wuMain.computeActiveWuState(m_activeHero.tableID);
			if (activeWuState == WuHeroProperty.ActiveWuState_zaiye)
			{
				if (m_btnZhao)
				{
					m_btnZhao.visible = false;
				}
			}
			else
			{
				if (m_btnZhao == null)
				{
					m_btnZhao = new PushButton(this, 2, 45, onZhaoBtnClick);
				}
				m_btnZhao.visible = true;
				var strRes:String = BTNRES_Zhao;
				switch (activeWuState)
				{
					case WuHeroProperty.ActiveWuState_xiaye: 
						strRes = BTNRES_Xiaye;
						break;
					case WuHeroProperty.ActiveWuState_needZhuansheng: 
						strRes = BTNRES_Zhuan;
						break;
					case WuHeroProperty.ActiveWuState_needZhaomu: 
						strRes = BTNRES_Zhao;
						break;
				
				}
				m_btnZhao.setPanelImageSkin(strRes);
			}
			
			if (m_btnZhao && (activeWuState == WuHeroProperty.ActiveWuState_needZhaomu) && !m_gkContext.m_jiuguanMgr.hasWu(m_activeHero.tableID))
			{
				m_btnZhao.visible = false;
			}
		}
		
		public function onZhaoBtnClick(event:MouseEvent):void
		{
			var activeWuState:uint = m_wuMain.computeActiveWuState(m_activeHero.tableID);
			if (activeWuState == WuHeroProperty.ActiveWuState_needZhaomu)
			{
				var wuBase:TNpcBattleItem = m_gkContext.m_npcBattleBaseMgr.getTNpcBattleItem(wutableIDCard);
				if (WuProperty.COLOR_PURPLE == wuBase.m_uColor)
				{
					var item:ItemPurpleWu = m_gkContext.m_jiuguanMgr.getBaoWuPurpleWu(m_activeHero.tableID);
					if (item)
					{
						m_gkContext.m_contentBuffer.addContent("uirecruitpurplewu_info", item);
						if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIRecruitPurpleWu) == false)
						{
							m_gkContext.m_UIMgr.loadForm(UIFormID.UIRecruitPurpleWu);
						}
					}
				}
				else
				{
					var ui:IUIRecruit = m_gkContext.m_UIMgr.getForm(UIFormID.UIRecruit) as IUIRecruit;
					if (ui)
					{
						ui.setData(m_activeHero.tableID);
					}
					else
					{
						m_gkContext.m_contentBuffer.addContent("uiRecruit_wuID", m_activeHero.tableID);
						m_gkContext.m_UIMgr.loadForm(UIFormID.UIRecruit);
					}
				}
			}
			else if (activeWuState == WuHeroProperty.ActiveWuState_needZhuansheng)
			{
				var wu:WuHeroProperty = m_gkContext.m_wuMgr.getRelativeHighestWuByTableID(m_activeHero.tableID, m_wuMain.add);
				(m_gkContext.m_UIs.backPack as UIBackPack).m_fastZhuangMgr.zhuansheng(wu);
			}
			else if (activeWuState == WuHeroProperty.ActiveWuState_xiaye)
			{
				m_gkContext.m_UIMgr.showFormEx(UIFormID.UIWuXiaye);
			}
		}
		
		protected function onActiveHeroMouseClick(event:MouseEvent):void
		{
			
			if (m_gkContext.m_newHandMgr.isVisible())
			{
				m_gkContext.m_newHandMgr.promptOver();
				m_gkContext.m_uiTip.hideTip();
				if (m_activeHero.tableID == 102) //102马云禄
				{
					wuRelationPanel.newHandMoveToOtherCards();
					m_gkContext.m_context.m_mainStage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownStage, true);
				}
				else
				{
					m_gkContext.m_newHandMgr.hide();
				}
			}
		}
		
		public function showTip():void
		{
			var pt:Point = this.localToScreen(new Point(58, 0));
			m_gkContext.m_uiTip.hintActiveWu(pt, m_wuMain.m_uHeroID, m_activeHero.tableID);
		}
		
		//点击屏幕，结束新手引导
		private function onMouseDownStage(event:MouseEvent):void
		{
			if (event.target is DisplayObjectContainer)
			{
				m_gkContext.m_newHandMgr.hide();
				m_gkContext.m_uiTip.hideTip();
				m_gkContext.m_context.m_mainStage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownStage, true);
			}
		}
		
		public function get wuRelationPanel():WuRelationPanel
		{
			return m_wuRP as WuRelationPanel;
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