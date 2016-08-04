package game.ui.uibackpack.relationwu.RelationMainWu 
{
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import game.ui.uibackpack.UIBackPack;
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
	 * @author ...
	 * 武将Icon
	 */
	public class WuIconItem extends Component
	{
		private var m_gkContext:GkContext;
		private var m_ui:UIBackPack;
		private var m_attrActWus:AttrActWus;
		private var m_cardPanel:WuIcon;
		private var m_wuID:uint;
		private var m_heroID:uint;
		private var m_bHaved:Boolean;		//是否拥有该武将
		private var m_btn:PushButton;
		private var m_wuState:int;			//关系武将状态 2需转生 3需招募
		
		public function WuIconItem(gk:GkContext, ui:UIBackPack, parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			m_ui = ui;
			m_attrActWus = parent as AttrActWus;
			
			m_cardPanel = new WuIcon(m_gkContext, this);
			m_cardPanel.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
			m_cardPanel.addEventListener(MouseEvent.ROLL_OUT, m_gkContext.hideTipOnMouseOut);
		}
		
		public function setData(wuid:uint):void
		{
			m_wuID = wuid;
		}
		
		public function updateData(heroid:uint):void
		{
			m_heroID = heroid;
			m_cardPanel.setIconNameByHeroID(m_heroID);
			
			updateWuState();
		}
		
		public function updateWuState():void
		{
			if (m_gkContext.m_wuMgr.getWuByHeroID(m_heroID))
			{
				m_bHaved = true;
				
				m_cardPanel.becomeUnGray();
			}
			else
			{
				m_bHaved = false;
				m_cardPanel.becomeGray();
			}
			
			if (bHaved || !m_gkContext.m_jiuguanMgr.hasWu(m_wuID))
			{
				if (m_btn)
				{
					m_btn.visible = false;
				}
			}
			else
			{
				if (m_attrActWus.actLevel < RelationMainWuPanel.ActLevel_Max)
				{
					if (null == m_btn)
					{
						m_btn = new PushButton(this, 2, 45, onBtnClick);
					}
					
					var resStr:String;
					if (m_gkContext.m_wuMgr.getRelativeHighestWuByTableID(m_wuID, (m_heroID % 10)))
					{
						resStr = "commoncontrol/button/buttonzhuan.swf";
						m_wuState = WuHeroProperty.ActiveWuState_needZhuansheng;
					}
					else
					{
						resStr = "commoncontrol/button/buttonzhao.swf";
						m_wuState = WuHeroProperty.ActiveWuState_needZhaomu;
					}
					
					if (m_btn)
					{
						m_btn.setPanelImageSkin(resStr);
						m_btn.visible = true;
					}
				}
				else
				{
					if (m_btn)
					{
						m_btn.visible = false;
					}
				}
			}
		}
		
		private function onMouseRollOver(event:MouseEvent):void
		{
			var pt:Point = m_cardPanel.localToScreen(new Point(m_cardPanel.width, 0));
			
			m_gkContext.m_uiTip.hintWuBaseInfo2(pt, m_heroID);
		}
		
		//点击"招","转"按钮
		private function onBtnClick(event:MouseEvent):void
		{
			if (WuHeroProperty.ActiveWuState_needZhaomu == m_wuState)
			{
				var wuBase:TNpcBattleItem = m_gkContext.m_npcBattleBaseMgr.getTNpcBattleItem(m_wuID);
				if (WuProperty.COLOR_PURPLE == wuBase.m_uColor)
				{
					var item:ItemPurpleWu = m_gkContext.m_jiuguanMgr.getBaoWuPurpleWu(m_wuID);
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
						ui.setData(m_wuID);
					}
					else
					{
						m_gkContext.m_contentBuffer.addContent("uiRecruit_wuID", m_wuID);
						m_gkContext.m_UIMgr.loadForm(UIFormID.UIRecruit);
					}
				}
			}
			else if (WuHeroProperty.ActiveWuState_needZhuansheng == m_wuState)
			{
				var wu:WuHeroProperty = m_gkContext.m_wuMgr.getRelativeHighestWuByTableID(m_wuID, m_heroID % 10);
				if (wu)
				{
					m_ui.m_fastZhuangMgr.zhuansheng(wu);
				}
			}
		}
		
		public function get wuID():uint
		{
			return m_wuID;
		}
		
		public function get heroID():uint
		{
			return m_heroID;
		}
		
		public function get bHaved():Boolean
		{
			return m_bHaved;
		}
	}

}