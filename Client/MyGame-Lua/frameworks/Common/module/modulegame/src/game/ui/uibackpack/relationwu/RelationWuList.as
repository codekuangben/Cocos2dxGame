package game.ui.uibackpack.relationwu 
{
	import com.bit101.components.Ani;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.dgrigg.image.Image;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.appcontrol.PanelDisposeEx;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.GkContext;
	import modulecommon.net.msg.sceneHeroCmd.ActiveHero;
	import modulecommon.res.ResGrid9;
	import modulecommon.scene.prop.table.TNpcBattleItem;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import game.ui.uibackpack.UIBackPack;
	/**
	 * ...
	 * @author ...
	 * 关系武将列表
	 */
	public class RelationWuList extends Component
	{
		private var m_gkContext:GkContext;
		private var m_ui:UIBackPack;
		private var m_relationWuPanel:RelationWuPanel;
		private var m_parent:DisplayObjectContainer;
		private var m_vecWuCard:Vector.<RelationWuCard>;
		private var m_mainHeroID:uint;
		private var m_nameLabel:Label;
		private var m_zhuanBtn:PushButton;
		private var m_ani:Ani;
		private var m_arrowPanel:Panel;
		private var m_selectPanel:PanelDisposeEx;
		private var m_selectRelationHeroID:uint;			//选中关系武将id
		private var m_nextRelationWuList:RelationWuList;	//某武将低一加数级关系武将列表
		private var m_bCanZhuanSheng:Boolean;
		private var m_newHandCard:RelationWuCard;			//新手引导过程中指向"马云禄"的card
		
		public function RelationWuList(gk:GkContext, ui:UIBackPack, relationwupanel:RelationWuPanel, parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			m_ui = ui;
			m_relationWuPanel = relationwupanel;
			m_parent = parent;
			
			this.setSize(140, 497);
			this.setSkinForm("form9.swf");
			
			var panel:Panel;
			panel = new Panel(this, 20, 10);
			panel.setSize(100, 450);
			panel.autoSizeByImage = false;
			panel.setPanelImageSkinMirror("commoncontrol/panel/glodflightsmall.png", Image.MirrorMode_LR);
			
			panel = new Panel(this, 35, 32);
			panel.setPanelImageSkin("commoncontrol/panel/backpack/relationWu.png");
			
			m_nameLabel = new Label(this, 70, 12);
			m_nameLabel.setFontSize(14);
			m_nameLabel.setBold(true);
			m_nameLabel.align = Component.CENTER;
			
			m_vecWuCard = new Vector.<RelationWuCard>();
		}
		
		public function setData(heroid:uint):void
		{
			m_mainHeroID = heroid;
			
			var i:int;
			var npcBase:TNpcBattleItem = m_gkContext.m_npcBattleBaseMgr.getTNpcBattleItem(m_mainHeroID / 10);
			m_nameLabel.setFontColor(WuHeroProperty.s_colorValue(npcBase.m_uColor));
			m_nameLabel.text = WuHeroProperty.s_fullName(heroid % 10, npcBase.m_name);
			
			for (i = 0; i < m_vecWuCard.length; i++)
			{
				m_vecWuCard[i].dispose();
			}
			m_vecWuCard.length = 0;
			
			var wucard:RelationWuCard;
			var vecActWuHeroid:Vector.<uint> = m_relationWuPanel.getActiveWuHeroID(m_mainHeroID);
			for (i = 0; i < vecActWuHeroid.length; i++)
			{
				wucard = new RelationWuCard(m_gkContext, this, 40, 60 + 90 * i);
				wucard.setData(m_mainHeroID, vecActWuHeroid[i]);
				m_vecWuCard.push(wucard);
			}
			
			update();
		}
		
		public function update():void
		{
			if (m_nextRelationWuList)
			{
				m_nextRelationWuList.update();
			}
			
			m_bCanZhuanSheng = true;
			
			for each(var wucard:RelationWuCard in m_vecWuCard)
			{
				wucard.update();
				
				if (wucard.activeWuTableID == 102)//马云禄
				{
					m_newHandCard = wucard;
				}
				
				if (false == wucard.bOwned)
				{
					m_bCanZhuanSheng = false;
				}
			}
			
			if ((m_mainHeroID % 10) >= WuHeroProperty.MaxZhuanshengLevel)
			{
				if (m_zhuanBtn)
				{
					m_zhuanBtn.visible = false;
					if (m_ani && this.contains(m_ani))
					{
						this.removeChild(m_ani);
						m_ani.stop();
					}
				}
				
				m_bCanZhuanSheng = false;
			}
			else
			{
				if (null == m_zhuanBtn)
				{
					m_zhuanBtn = new PushButton(this, 15, 435, onZhuanBtnClick);
					m_zhuanBtn.setSize(111, 45);
					m_zhuanBtn.setSkinButton1Image("commoncontrol/button/zhuanshengBtn.png");
				}
				
				if (m_bCanZhuanSheng)
				{
					if (null == m_ani)
					{
						m_ani = new Ani(m_gkContext.m_context);
						m_ani.duration = 2;
						m_ani.repeatCount = 0;
						m_ani.setImageAni("ejjianjiaosejianru.swf");
						m_ani.centerPlay = true;
						m_ani.mouseEnabled = false;
						m_ani.setAutoStopWhenHide();
						m_ani.x = 70;
						m_ani.y = 453;
						m_ani.scaleX = 0.48;
						m_ani.scaleY = 0.56;
					}
					this.addChild(m_ani);
					m_ani.begin();
				}
				else
				{
					if (m_ani)
					{
						if (this.contains(m_ani))
						{
							this.removeChild(m_ani);
						}
						m_ani.stop();
					}
				}
				
				m_zhuanBtn.visible = true;
			}
		}
		
		//点击“转生”按钮
		private function onZhuanBtnClick(event:MouseEvent):void
		{
			if (m_gkContext.m_newHandMgr.isVisible())
			{
				m_gkContext.m_newHandMgr.hide();
			}
			
			if (event.target is PushButton)
			{
				if (false == m_bCanZhuanSheng)
				{
					var wu:WuHeroProperty = m_gkContext.m_wuMgr.getWuByHeroID(m_mainHeroID) as WuHeroProperty;
					m_ui.m_fastZhuangMgr.zhuansheng(wu);
					return;
				}
				
				var info:Object = new Object();
				info["heroid"] = m_mainHeroID;
				m_gkContext.m_contentBuffer.addContent("uiwuzhuansheng_info", info);
				
				var form:Form = m_gkContext.m_UIMgr.getForm(UIFormID.UIWuZhuansheng);
				if (form)
				{
					form.updateData(info);
				}
				else
				{
					m_gkContext.m_UIMgr.showFormEx(UIFormID.UIWuZhuansheng);
				}
			}
		}
		
		public function hideNextList():void
		{
			if (m_arrowPanel && this.contains(m_arrowPanel))
			{
				this.removeChild(m_arrowPanel);
				m_arrowPanel.dispose();
				m_arrowPanel = null;
			}
			
			if (m_nextRelationWuList)
			{
				m_nextRelationWuList.hideNextList();
				this.removeChild(m_nextRelationWuList);
				m_nextRelationWuList.dispose();
				m_nextRelationWuList = null;
			}
		}
		
		//隐藏下一关系武将列表（即关系武将显示第2列(含)以后）
		public function hideNextRelationWuListByHeroID(heroid:uint):void
		{
			if (m_nextRelationWuList)
			{
				m_nextRelationWuList.hideNextRelationWuListByHeroID(heroid);
				if (m_nextRelationWuList.heroID == heroid)
				{
					hideNextList();
				}
			}
		}
		
		override public function dispose():void
		{
			if (m_ani && !m_ani.parent)
			{
				m_ani.dispose();
			}
			
			super.dispose();
		}
		
		public function get heroID():uint
		{
			return m_mainHeroID;
		}
		
		//***显示关系武将下一加数的关系武将列表**********************************/
		public function showNextRelationWuList(nextheroid:uint):void
		{
			if (null == m_nextRelationWuList)
			{
				m_nextRelationWuList = new RelationWuList(m_gkContext, m_ui, m_relationWuPanel, this, 140, 0);
			}
			m_nextRelationWuList.hideNextList();
			m_nextRelationWuList.setData(nextheroid);
			
			if (m_arrowPanel)
			{
				m_arrowPanel.visible = false;
			}
			
			if (null == m_arrowPanel)
			{
				m_arrowPanel = new Panel(this, 120, 65);
				m_arrowPanel.setPanelImageSkin("commoncontrol/panel/backpack/arrow.png");
				m_arrowPanel.visible = false;
				m_arrowPanel.mouseChildren = false;
				m_arrowPanel.mouseEnabled = false;
				
				m_selectPanel = new PanelDisposeEx();
				m_selectPanel.setSize(78, 90);
				m_selectPanel.setSkinGrid9Image9(ResGrid9.StypeCardSelect);
				m_selectPanel.setPos(-90, -14);
				m_selectPanel.show(m_arrowPanel);
			}
			
			for (var i:int = 0; i < m_vecWuCard.length; i++)
			{
				if (selectRelationHeroID == m_vecWuCard[i].activeHeroID)
				{
					m_arrowPanel.y = 65 + i * 90;
					m_arrowPanel.visible = true;
					break;
				}
			}
		}
		
		public function get selectRelationHeroID():uint
		{
			return m_selectRelationHeroID;
		}
		
		public function set selectRelationHeroID(heroid:uint):void
		{
			m_selectRelationHeroID = heroid;
		}
		
		public function newHnadMoveToCard():void
		{
			if (m_gkContext.m_newHandMgr.isVisible() && m_gkContext.m_newHandMgr.m_bMoveToNext)
			{
				m_gkContext.m_newHandMgr.m_bMoveToNext = false;
				if (m_gkContext.m_sysnewfeatures.m_nft == SysNewFeatures.NFT_HEROREBIRTH)
				{
					m_gkContext.m_newHandMgr.setFocusFrame(5, -8, 100, 54, 1);
					m_gkContext.m_newHandMgr.prompt(true, 20, 50, "左键点击转生，武将属性大幅提升。", m_zhuanBtn);
				}
				else if (m_newHandCard && (m_gkContext.m_sysnewfeatures.m_nft == SysNewFeatures.NFT_WUJIANGJIHUO))
				{
					m_gkContext.m_newHandMgr.setFocusFrame(-10, -10, 78, 92, 1);
					m_gkContext.m_newHandMgr.prompt(true, 0, 72, "马云禄已招募，马腾属性强化。", m_newHandCard);
					m_newHandCard.showTip();
				}
			}
		}
		
		public function newHandMoveToOtherCards():void
		{
			if (m_gkContext.m_sysnewfeatures.m_nft == SysNewFeatures.NFT_WUJIANGJIHUO)
			{
				m_gkContext.m_newHandMgr.setFocusFrame(-10, -10, 78, 92, 1);
				m_gkContext.m_newHandMgr.prompt(true, 0, 72, "激活其它关系武将，属性将得到更多提升。", m_vecWuCard[1]);
				m_vecWuCard[1].showTip();
			}
		}
		
	}

}