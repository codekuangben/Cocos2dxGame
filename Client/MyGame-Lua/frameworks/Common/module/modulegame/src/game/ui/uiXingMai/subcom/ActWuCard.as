package game.ui.uiXingMai.subcom 
{
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.dgrigg.image.Image;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.appcontrol.WuIcon;
	import modulecommon.GkContext;
	import modulecommon.scene.jiuguan.ItemPurpleWu;
	import modulecommon.scene.prop.table.TNpcBattleItem;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.wu.WuProperty;
	import modulecommon.scene.xingmai.XingmaiMgr;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIRecruit;
	import game.ui.uiXingMai.UIXingMai;
	/**
	 * ...
	 * @author ...
	 */
	public class ActWuCard extends Component
	{
		public static const BTNRES_Zhao:String = "commoncontrol/button/buttonzhao.swf";
		
		private var m_gkContext:GkContext;
		private var m_uiXingMai:UIXingMai;
		private var m_actWuPanel:ActWuPanel;
		private var m_recruitBtn:PushButton;//"招募"按钮
		private var m_actBtn:PushButton;	//武将激活按钮
		private var m_cardBg:Panel;			//方头像背景
		private var m_cardPanel:WuIcon;		//方头像
		private var m_wuID:uint;
		private var m_heroid:uint;			//当前已激活武将id
		private var m_bAct:Boolean;			//是否激活过
		
		public function ActWuCard(gk:GkContext, ui:UIXingMai, parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			m_uiXingMai = ui;
			m_actWuPanel = parent as ActWuPanel;
			
			m_cardBg = new Panel(this, 0, 0);
			m_cardBg.setPanelImageSkinMirror("commoncontrol/panel/xingmai/wucardform.png", Image.MirrorMode_LR);
			m_cardBg.mouseEnabled = false;
			
			m_cardPanel = new WuIcon(m_gkContext, this, 14, 14);
			m_cardPanel.setSize(58, 72);
			m_cardPanel.showFrame = false;
			
			m_recruitBtn = new PushButton(this, 13, 59, onRecruitBtnClick);
			m_recruitBtn.setPanelImageSkin("commoncontrol/button/buttonzhao.swf");
			m_recruitBtn.visible = false;
			
			m_actBtn = new PushButton(this, 45, 58, onActBtnClick);
			m_actBtn.setPanelImageSkin("commoncontrol/button/buttonchi.swf");
			m_actBtn.visible = false;
			
			this.setSize(86, 100);
			this.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOut);
			this.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
		}
		
		public function setData(wuid:uint):void
		{
			m_wuID = wuid;
			
			updateData();
		}
		
		public function updateData():void
		{
			m_heroid = m_gkContext.m_xingmaiMgr.getHasActHeroId(m_wuID, m_actWuPanel.skillBaseID);
			
			if (0 == m_heroid)
			{
				m_bAct = false;
				m_heroid = m_wuID * 10;
			}
			else
			{
				m_bAct = true;
			}
			
			var wu:WuHeroProperty;
			if (false == m_bAct)
			{
				wu = m_gkContext.m_wuMgr.getWuByHeroID(m_heroid) as WuHeroProperty;
				if (wu)
				{
					m_cardPanel.becomeUnGray();
					m_actBtn.tag = XingmaiMgr.XM_ACTSTATE_ACTION;
					m_actBtn.visible = true;
					m_recruitBtn.visible = false;
				}
				else
				{
					m_cardPanel.becomeGray();
					m_actBtn.visible = false;
					if (m_gkContext.m_jiuguanMgr.hasWu(m_wuID))
					{
						m_recruitBtn.visible = true;
					}
					else
					{
						m_recruitBtn.visible = false;
					}
					m_recruitBtn.tag = XingmaiMgr.XM_ACTSTATE_RECRUIT;
					m_recruitBtn.setPanelImageSkin("commoncontrol/button/buttonzhao.swf");
				}
			}
			else
			{
				var heroAdd:uint = m_heroid % 10;
				if (heroAdd < WuHeroProperty.Add_Shen)
				{
					m_heroid = m_heroid + 1;
					wu = m_gkContext.m_wuMgr.getWuByHeroID(m_heroid) as WuHeroProperty;
					if (wu)
					{
						m_cardPanel.becomeUnGray();
						m_actBtn.tag = XingmaiMgr.XM_ACTSTATE_ACTION;
						m_actBtn.visible = true;
						m_recruitBtn.visible = false;
					}
					else
					{
						m_cardPanel.becomeGray();
						wu = m_gkContext.m_wuMgr.getRelativeHighestWuByTableID(m_heroid / 10, m_heroid % 10);
						if (wu)
						{
							m_recruitBtn.tag = XingmaiMgr.XM_ACTSTATE_REBIRTH;
							m_recruitBtn.setPanelImageSkin("commoncontrol/button/buttonzhuan.swf");
						}
						else
						{
							m_recruitBtn.tag = XingmaiMgr.XM_ACTSTATE_RECRUIT;
							m_recruitBtn.setPanelImageSkin("commoncontrol/button/buttonzhao.swf");
						}
						
						m_actBtn.visible = false;
						m_recruitBtn.visible = true;
					}
				}
				else
				{
					m_actBtn.visible = false;
					m_recruitBtn.visible = false;
					m_cardPanel.becomeUnGray();
				}
			}
			
			m_cardPanel.setIconNameByHeroID(m_heroid);
		}
		
		private function onMouseRollOver(event:MouseEvent):void
		{
			var pt:Point = this.localToScreen(new Point(this.width - 6, 5));
			
			m_actWuPanel.showActWuTips(pt, m_heroid, m_bAct);
			m_gkContext.m_wuMgr.showWuMouseOverPanel(m_cardPanel);
		}
		
		private function onMouseRollOut(event:MouseEvent):void
		{
			m_gkContext.m_uiTip.hideTip();
			m_gkContext.m_wuMgr.hideWuMouseOverPanel(m_cardPanel);
		}
		
		//武将激活
		private function onActBtnClick(event:MouseEvent):void
		{
			var btn:PushButton = event.currentTarget as PushButton;
			
			if (XingmaiMgr.XM_ACTSTATE_ACTION == btn.tag)//激活
			{
				m_actWuPanel.showConfirmPrompt(m_heroid);
			}
		}
		
		//武将招募
		private function onRecruitBtnClick(event:MouseEvent):void
		{
			var btn:PushButton = event.currentTarget as PushButton;
			var wuBase:TNpcBattleItem = m_gkContext.m_npcBattleBaseMgr.getTNpcBattleItem(m_wuID);
			
			if (XingmaiMgr.XM_ACTSTATE_RECRUIT == btn.tag)
			{
				if (wuBase && (WuProperty.COLOR_PURPLE == wuBase.m_uColor))
				{
					var item:ItemPurpleWu = m_gkContext.m_jiuguanMgr.getBaoWuPurpleWu(m_wuID);
					if (item)
					{
						m_gkContext.m_contentBuffer.addContent("uirecruitpurplewu_info", item);
						if (!m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIRecruitPurpleWu))
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
						ui.setData(m_wuID);
					}
					else
					{
						m_gkContext.m_contentBuffer.addContent("uiRecruit_wuID", m_wuID);
						m_gkContext.m_UIMgr.loadForm(UIFormID.UIRecruit);
					}
				}
			}
			else if (XingmaiMgr.XM_ACTSTATE_REBIRTH == btn.tag)
			{
				//快速转生
				var wu:WuHeroProperty = m_gkContext.m_wuMgr.getRelativeHighestWuByTableID(m_heroid / 10, m_heroid % 10);
				if (wu)
				{
					m_actWuPanel.showRelationWusByHeroID(wu.m_uHeroID);
				}
			}
		}
		
		public function get wuTableID():uint
		{
			return m_wuID;
		}
	}

}