package game.ui.uiXingMai.subcom 
{
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.dgrigg.image.Image;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import game.ui.uibackpack.relationwu.RelationWuCard;
	import modulecommon.appcontrol.WuIcon;
	import modulecommon.GkContext;
	import modulecommon.scene.jiuguan.ItemPurpleWu;
	import modulecommon.scene.prop.table.TNpcBattleItem;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.wu.WuProperty;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIRecruit;
	
	/**
	 * ...
	 * @author 
	 */
	public class XMrelationWuCard extends Component 
	{
		private var m_gkContext:GkContext;
		private var m_relationWuList:XMrelationWuList;
		private var m_btn:PushButton;
		private var m_cardBg:Panel;
		private var m_cardPanel:WuIcon;
		private var m_mainHeroID:uint;			//武将id
		private var m_activeHeroID:uint;		//关系武将ID
		private var m_stateActiveWu:int;		//关系武将状态 1下野 2需转生 3需招募
		private var m_bOwned:Boolean;			//是否拥有该武将
		public function XMrelationWuCard(gk:GkContext,parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			m_relationWuList = parent as XMrelationWuList;
			this.setSize(WuProperty.SQUAREHEAD_WIDHT, WuProperty.SQUAREHEAD_HEIGHT);
			m_cardBg = new Panel(this, -14, -14);
			m_cardBg.setPanelImageSkinMirror("commoncontrol/panel/xingmai/wucardform.png", Image.MirrorMode_LR);
			
			m_cardPanel = new  WuIcon(m_gkContext, this);
			addEventListener(MouseEvent.ROLL_OUT, onWuIconRollOut);
			addEventListener(MouseEvent.ROLL_OVER, onWuIconRollOver);
		}
		
		public function setData(heroid:uint, activeheroid:uint):void
		{
			m_mainHeroID = heroid;
			m_activeHeroID = activeheroid;
			m_cardPanel.setIconNameByTableID(activeWuTableID);
			
			update();
		}
		
		public function get activeHeroID():uint
		{
			return m_activeHeroID;
		}
		
		public function get activeWuTableID():uint
		{
			return m_activeHeroID / 10;
		}
		
		public function get bOwned():Boolean
		{
			return m_bOwned;
		}
		
		public function update():void
		{
			//这个函数更新2方面的状态: 1.卡片本身是否是灰色, 2. 卡片上按钮的状态
			var actWu:WuHeroProperty = m_gkContext.m_wuMgr.getWuByHeroID(m_activeHeroID) as WuHeroProperty;
			var lowWu:WuHeroProperty = null;
			var resStr:String = null;
			m_stateActiveWu = 0;
			
			//1.卡片本身是否是灰色
			if (actWu && actWu.xiaye == false)
			{
				m_cardPanel.becomeUnGray();
			}
			else
			{
				m_cardPanel.becomeGray();
			}
			
			//2. 卡片上按钮的状态
			if (actWu)
			{
				if (actWu.xiaye)
				{
					m_stateActiveWu = WuHeroProperty.ActiveWuState_xiaye;
					resStr = RelationWuCard.BTNRES_Xiaye;
				}
				else
				{
					m_stateActiveWu = WuHeroProperty.ActiveWuState_zaiye;
				}
				
				m_bOwned = true;
			}
			else
			{
				lowWu = m_gkContext.m_wuMgr.getLowestWuByTableID(activeWuTableID);
				if (lowWu && lowWu.add < m_mainHeroID % 10)
				{
					m_stateActiveWu = WuHeroProperty.ActiveWuState_needZhuansheng;
					resStr = RelationWuCard.BTNRES_Zhuan;
				}
				else
				{
					m_stateActiveWu = WuHeroProperty.ActiveWuState_needZhaomu;
					resStr = RelationWuCard.BTNRES_Zhao;
				}
				
				m_bOwned = false;
			}
			
			if (null == resStr || !m_gkContext.m_jiuguanMgr.hasWu(activeWuTableID))
			{
				if (m_btn)
				{
					m_btn.visible = false;
				}
			}
			else
			{
				if (null == m_btn)
				{
					m_btn = new PushButton(this, 0, 45, onBtnClick);
				}
				m_btn.setPanelImageSkin(resStr);
				
				m_btn.visible = true;
			}
		}
		private function onBtnClick(event:MouseEvent):void
		{
			if (WuHeroProperty.ActiveWuState_needZhaomu == m_stateActiveWu)
			{
				var wuBase:TNpcBattleItem = m_gkContext.m_npcBattleBaseMgr.getTNpcBattleItem(activeWuTableID);
				if (WuProperty.COLOR_PURPLE == wuBase.m_uColor)
				{
					var item:ItemPurpleWu = m_gkContext.m_jiuguanMgr.getBaoWuPurpleWu(activeWuTableID);
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
						ui.setData(activeWuTableID);
					}
					else
					{
						m_gkContext.m_contentBuffer.addContent("uiRecruit_wuID", activeWuTableID);
						m_gkContext.m_UIMgr.loadForm(UIFormID.UIRecruit);
					}
				}
			}
			else if (WuHeroProperty.ActiveWuState_needZhuansheng == m_stateActiveWu)
			{
				var wu:WuHeroProperty = m_gkContext.m_wuMgr.getRelativeHighestWuByTableID(activeWuTableID, m_mainHeroID % 10);
				m_relationWuList.selectRelationHeroID = m_activeHeroID;
				m_relationWuList.showNextRelationWuList(wu.m_uHeroID);
			}
			else if (WuHeroProperty.ActiveWuState_xiaye == m_stateActiveWu)
			{
				m_gkContext.m_UIMgr.showFormEx(UIFormID.UIWuXiaye);
			}
			
		}
		private function onWuIconRollOut(event:MouseEvent):void
		{
			m_gkContext.m_uiTip.hideTip();
		}
		
		private function onWuIconRollOver(event:MouseEvent):void
		{
			var pt:Point = this.localToScreen(new Point(this.width + 7, -7));
			m_gkContext.m_uiTip.hintActiveWu(pt, m_mainHeroID, activeWuTableID, 72);
		}
		
	}

}