package game.ui.uiXingMai.subcom 
{
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.dgrigg.image.Image;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import modulecommon.appcontrol.PanelDisposeEx;
	import modulecommon.GkContext;
	import modulecommon.net.msg.xingMaiCmd.stLevelUpXMSkillXMCmd;
	import modulecommon.res.ResGrid9;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.wu.WuProperty;
	import modulecommon.scene.xingmai.ItemSkill;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import game.ui.uiXingMai.tip.TipWucard;
	import game.ui.uiXingMai.UIXingMai;
	/**
	 * ...
	 * @author ...
	 * 觉醒技能激活武将
	 */
	public class ActWuPanel extends Component
	{
		private var m_gkContext:GkContext;
		private var m_uiXingMai:UIXingMai;
		private var m_vecActWuCard:Vector.<ActWuCard>;
		private var m_wuTip:TipWucard;
		private var m_skillBaseID:uint;
		private var m_itemSkill:ItemSkill;
		private var m_willActHeroID:uint;		//将要激活武将id
		//private var m_nextRelationWuList:RelationWuList;	//某武将低一加数级关系武将列表
		private var m_relationWuList:XMrelationWuList;
		private var m_curHeroID:uint;
		private var m_arrowPanel:Panel;
		private var m_selectPanel:PanelDisposeEx;
		public function ActWuPanel(gk:GkContext, ui:UIXingMai, parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			m_uiXingMai = ui;
			
			this.setSize(130, 540);
			this.setSkinForm("form9.swf");
			
			var panel:Panel;
			panel = new Panel(this, 15, 15);
			panel.autoSizeByImage = false;
			panel.setSize(100, 505);
			panel.setPanelImageSkinMirror( "commoncontrol/panel/xingmai/smallback.png", Image.MirrorMode_LR);
			
			panel = new Panel(this, 28, 24);
			panel.setPanelImageSkin("commoncontrol/panel/xingmai/wujiangword.png");
			m_vecActWuCard = new Vector.<ActWuCard>();
		}
		
		public function setData(id:uint):void
		{
			m_skillBaseID = id;
			m_itemSkill = m_gkContext.m_xingmaiMgr.getItemSkill(m_skillBaseID);
			
			deleteActWuCardList();
			
			var i:int;
			var wucard:ActWuCard;
			
			for (i = 0; i < m_itemSkill.m_vecActWus.length; i++)
			{
				wucard = new ActWuCard(m_gkContext, m_uiXingMai, this, 22, 42 + 95 * i);
				wucard.setData(m_itemSkill.m_vecActWus[i]);
				
				m_vecActWuCard.push(wucard);
			}			
		}
		
		//更新激活武将状态显示
		public function updateActWuState(heroid:uint):void
		{
			var i:int;
			var wuid:uint = heroid / 10;
			for (i = 0; i < m_vecActWuCard.length; i++)
			{
				if (wuid == m_vecActWuCard[i].wuTableID)
				{
					m_vecActWuCard[i].updateData();
					break;
				}
			}
			if (m_relationWuList)
			{
				m_relationWuList.update();
			}
		}
		
		public function showActWuTips(pt:Point, heroid:uint, bAct:Boolean):void
		{
			if (null == m_wuTip)
			{
				m_wuTip = new TipWucard(m_gkContext);
			}
			
			m_wuTip.showTip(heroid, bAct, m_itemSkill.m_name, m_itemSkill.m_desc);
			
			m_gkContext.m_uiTip.hintComponent(pt, m_wuTip, 72);
		}
		
		public function get skillBaseID():uint
		{
			return m_skillBaseID;
		}
		
		//激活武将 显示确认提示框
		public function showConfirmPrompt(heroid:uint):void
		{
			m_willActHeroID = heroid;
			var wu:WuHeroProperty = m_gkContext.m_wuMgr.getWuByHeroID(heroid) as WuHeroProperty
			var str:String;
			if (wu)
			{
				UtilHtml.beginCompose();
				UtilHtml.addStringNoFormat("您确定要消耗");
				UtilHtml.add(wu.fullName, wu.colorValue, 14);
				UtilHtml.addStringNoFormat("来让");
				UtilHtml.add("【" + m_itemSkill.m_name + "】", UtilColor.GOLD, 14);
				UtilHtml.addStringNoFormat("等级+1么？");
				
				if ((wu.color == WuProperty.COLOR_PURPLE) || wu.add > 0)
				{
					m_gkContext.m_confirmDlgMgr.showModeInputYes(m_uiXingMai.id, "提示", UtilHtml.getComposedContent(), confirmBtn, "确认", "取消");
				}
				else
				{
					m_gkContext.m_confirmDlgMgr.showMode1(m_uiXingMai.id, UtilHtml.getComposedContent(), confirmBtn, null, "确定", "取消");
				}
			}
		}
		
		private function confirmBtn():Boolean
		{
			sendMsgSkillPromotCmd(m_willActHeroID);
			m_willActHeroID = 0;
			return true;
		}
		public function showRelationWusByHeroID(heroid:uint):void
		{
			if (null == m_relationWuList)
			{
				m_relationWuList = new XMrelationWuList(m_gkContext, m_uiXingMai, /*this,*/ this, 130, 0);
			}
			m_curHeroID = heroid;
			m_relationWuList.hideNextList();
			m_relationWuList.setData(m_curHeroID);
			if (m_arrowPanel)
			{
				m_arrowPanel.visible = false;
			}
			
			if (null == m_arrowPanel)
			{
				m_arrowPanel = new Panel(this, 100, 65);
				m_arrowPanel.setPanelImageSkin("commoncontrol/panel/backpack/arrow.png");
				m_arrowPanel.visible = false;
				m_arrowPanel.mouseChildren = false;
				m_arrowPanel.mouseEnabled = false;
				
				m_selectPanel = new PanelDisposeEx();
				m_selectPanel.setSize(78, 90);
				m_selectPanel.setSkinGrid9Image9(ResGrid9.StypeCardSelect);
				m_selectPanel.setPos(-74, -18);
				m_selectPanel.show(m_arrowPanel);
			}
			for (var i:int = 0; i < m_vecActWuCard.length; i++)
			{
				if (Math.floor(heroid / 10) == m_vecActWuCard[i].wuTableID)
				{
					m_arrowPanel.y = 65 + i * 95;
					m_arrowPanel.visible = true;
					break;
				}
			}
			//m_relationWuList.newHnadMoveToCard();
		}
		//请求激活武将
		private function sendMsgSkillPromotCmd(heroid:uint):void
		{
			var cmd:stLevelUpXMSkillXMCmd = new stLevelUpXMSkillXMCmd();
			cmd.m_skillid = skillBaseID;
			cmd.m_heroid = heroid;
			
			m_gkContext.sendMsg(cmd);
		}
		
		//删除激活武将信息
		private function deleteActWuCardList():void
		{
			var i:int;
			var wucard:ActWuCard;
			
			for (i = 0; i < m_vecActWuCard.length; i++)
			{
				wucard = m_vecActWuCard[i];
				if (wucard && wucard.parent)
				{
					wucard.parent.removeChild(wucard);
				}
				wucard.dispose();
				wucard = null;
			}
			m_vecActWuCard.length = 0;
			if (m_relationWuList)
			{
				m_relationWuList.hideNextList();
				this.removeChild(m_relationWuList);
				m_relationWuList.dispose();
				m_relationWuList = null;
			}
			if (m_arrowPanel)
			{
				this.removeChild(m_arrowPanel);
				m_arrowPanel.dispose();
				m_arrowPanel = null;
			}
			if (m_selectPanel)
			{
				m_selectPanel.disposeEx();
				m_selectPanel = null;
			}
		}
		public function hideNextRelationWuListByHeroID(heroid:uint):void
		{
			if (m_relationWuList)
			{
				m_relationWuList.hideNextRelationWuListByHeroID(heroid);
				if (m_relationWuList.heroID == heroid)
				{
					if (m_arrowPanel && this.contains(m_arrowPanel))
					{
						this.removeChild(m_arrowPanel);
						m_arrowPanel.dispose();
						m_arrowPanel = null;
					}
					if (m_selectPanel)
					{
						m_selectPanel.disposeEx();
						m_selectPanel = null;
					}
					m_relationWuList.hideNextList();
					this.removeChild(m_relationWuList);
					m_relationWuList.dispose();
					m_relationWuList = null;
				}
			}
		}
		override public function dispose():void
		{
			if (m_wuTip)
			{
				m_wuTip.dispose();
			}
			deleteActWuCardList();
			
			super.dispose();
		}
	}

}