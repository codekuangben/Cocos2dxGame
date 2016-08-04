 package game.ui.uibackpack.watch 
{
	import com.bit101.components.ButtonTabText;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.PushButton;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import game.ui.uibackpack.tips.WatchTipMgr;
	import modulecommon.res.ResGrid9;
	import modulecommon.scene.wu.WuProperty;
	import modulecommon.ui.Form;
	import modulecommon.ui.FormStyleNine;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIMountsSys;
	import game.ui.uibackpack.wujiang.EquipBgShare;
	
	/**
	 * ...
	 * @author 
	 */
	public class UIWatchPlayer extends FormStyleNine 
	{
		
		
		private var m_uiWatchSelf:UIWatchSelfAttr;
		private var m_btnList:Watch_BtnList;
		private var m_dicPanel:Dictionary;
		private var m_wuEquipBG:Panel;
		private var m_attrUI:Watch_AttrUI;
		private var m_equipBgShare:EquipBgShare;
		private var m_mountsBtn:PushButton;			//坐骑
		private var m_wuxuePanel:Panel;				//武学
		private var m_corpsPanel:Panel;				//军团科技
		private var m_godlyweaponPanel:Panel;		//神兵
		private var m_watchTipMgr:WatchTipMgr;		//tips
		
		public function UIWatchPlayer() 
		{
			this.id = UIFormID.UIWatchPlayer;
			this.exitMode = EXITMODE_HIDE;
			timeForTimingClose = 20;
		}
		
		override public function onReady():void 
		{
			super.onReady();
			
			var panelContainer:PanelContainer;
			
			beginPanelDrawBg(607, 533);
			//m_bgPart.addContainer();
			
			panelContainer = new PanelContainer(null, 155, 38);
			panelContainer.setSize(269, 477);
			panelContainer.setSkinGrid9Image9(ResGrid9.StypeTwo);
			m_bgPart.addDrawCom(panelContainer, true);
			
			endPanelDraw();
			
			setTitleDraw(282, "commoncontrol/panel/backpack/word_watch.png", null, 64);
			
			m_btnList = new Watch_BtnList(this, this, m_gkcontext);
			m_btnList.x = 22;
			m_btnList.y = 35;
			
			m_dicPanel = new Dictionary();
			
			m_wuEquipBG = new Panel(this, 160, 65);
			m_wuEquipBG.setPanelImageSkin("commoncontrol/panel/backpack/wuEquipBG.png");
			
			var btn:ButtonTabText = new ButtonTabText(this, 175, 44, "装备");
			btn.setParam(12, true);			
			btn.setSize(52, 23);
			btn.setPanelImageSkin("commoncontrol/button/buttonTab2.swf");
			btn.selected = true;
			
			m_equipBgShare = new EquipBgShare();
			m_attrUI = new Watch_AttrUI(this, 427, 39);
			this.swapChildren(m_exitBtn, m_attrUI);
			
			m_mountsBtn = new PushButton(this, 360, 460, onMouseMountsClk);
			m_mountsBtn.setSize(42, 42);
			m_mountsBtn.setSkinButton1Image("commoncontrol/panel/backpack/mounts.png");
			m_mountsBtn.addEventListener(MouseEvent.ROLL_OVER, onMouseMountsRollOver);
			m_mountsBtn.addEventListener(MouseEvent.ROLL_OUT, m_gkcontext.hideTipOnMouseOut);
			m_mountsBtn.addEventListener(MouseEvent.CLICK, onMouseMountsClk);
			
			m_wuxuePanel = new Panel(this, 310, 460);
			m_wuxuePanel.setSize(42, 42);
			m_wuxuePanel.setPanelImageSkin("commoncontrol/panel/backpack/wuxue.png");
			m_wuxuePanel.addEventListener(MouseEvent.ROLL_OVER, onMouseWuxueRollOver);
			m_wuxuePanel.addEventListener(MouseEvent.ROLL_OUT, m_gkcontext.hideTipOnMouseOut);
			
			m_corpsPanel = new Panel(this, 260, 460);
			m_corpsPanel.setSize(42, 42);
			m_corpsPanel.setPanelImageSkin("commoncontrol/panel/backpack/corpys.png");
			m_corpsPanel.addEventListener(MouseEvent.ROLL_OVER, onMouseCorpsRollOver);
			m_corpsPanel.addEventListener(MouseEvent.ROLL_OUT, m_gkcontext.hideTipOnMouseOut);
			
			m_godlyweaponPanel = new Panel(this, 220, 470);
			m_godlyweaponPanel.setSize(25, 27);
			m_godlyweaponPanel.setPanelImageSkin("commoncontrol/panel/herobottom/shenbingicon.png");
			m_godlyweaponPanel.addEventListener(MouseEvent.ROLL_OVER, onMouseGodlyweaponRollOver);
			m_godlyweaponPanel.addEventListener(MouseEvent.ROLL_OUT, m_gkcontext.hideTipOnMouseOut);
			
			m_watchTipMgr = new WatchTipMgr(m_gkcontext);
		}
		
		public function addPanel(heroID:uint):void
		{
			if (m_dicPanel[heroID] == undefined)
			{
				var wu:WuProperty = m_gkcontext.m_watchMgr.getWuByHeroID(heroID);
				var panel:Watch_UIEquip = new Watch_UIEquip(this, m_wuEquipBG, m_gkcontext, wu);
				
				
				m_dicPanel[heroID] = panel;
			}
		}
		
		override public function updateData(param:Object = null):void		
		{			
			var item: Watch_UIEquip;
			for each(item in m_dicPanel)
			{
				item.dispose();
				if (item.parent)
				{
					item.parent.removeChild(item);					
				}
			}
			m_dicPanel = new Dictionary();
			m_btnList.initData();
			showPanel(WuProperty.MAINHERO_ID);			
		}
		
		public function showPanel(heroID:uint):void
		{
			var panel:Watch_UIEquip;
			//m_curHeroID =  heroID;
			
			if (m_dicPanel[heroID] == undefined)
			{
				addPanel(heroID);
			}
			
			for each(var item:* in m_dicPanel)
			{
				panel = item as Watch_UIEquip;
				if (panel.heroID == heroID)
				{					
					panel.show();					
					panel.onShowThisWu();
				}
				else
				{
					panel.hide();				
				}
			}
			var wu:WuProperty = m_gkcontext.m_watchMgr.getWuByHeroID(heroID);
			m_attrUI.switchToWu(wu);
		}
		
		override public function dispose():void 
		{
			m_equipBgShare.disposAll();
			
			if (m_uiWatchSelf)
			{
				m_gkcontext.m_UIMgr.destroyForm(m_uiWatchSelf.id);
				m_uiWatchSelf = null;
			}
			
			var item: Watch_UIEquip;
			for each(item in m_dicPanel)
			{
				item.disposeWhenParentEqualNull();
			}
			
			m_watchTipMgr.dispose();
			
			super.dispose();
		}
		
		public function showUIWatchSelf():UIWatchSelfAttr
		{
			if (m_uiWatchSelf == null)
			{
				m_uiWatchSelf = new UIWatchSelfAttr(this);
				m_gkcontext.m_UIMgr.addForm(m_uiWatchSelf);
			}
			return m_uiWatchSelf;
		}
		
		public function get uiWatchSelf():UIWatchSelfAttr
		{
			return m_uiWatchSelf;
		}
		
		public function get equipBgShare():EquipBgShare
		{
			return m_equipBgShare;
		}
		
		//武学tips
		private function onMouseWuxueRollOver(event:MouseEvent):void
		{
			var panel:Panel = event.currentTarget as Panel;
			var pt:Point = panel.localToScreen();
			
			if (m_gkcontext.m_zhanxingMgr.m_vecStarOtherPlayer)
			{
				m_watchTipMgr.showWuxueTip(pt);
			}
			else
			{
				pt.x += panel.width / 2;
				m_gkcontext.m_uiTip.hintCondense(pt, "武学");
			}
		}
		
		//坐骑tips
		private function onMouseMountsRollOver(event:MouseEvent):void
		{
			var btn:PushButton = event.currentTarget as PushButton;
			var pt:Point = btn.localToScreen();
			
			if(m_gkcontext.m_mountsSysLogic.hasOtherMountsData())
			{//对方已开启“坐骑”功能
				pt.x += 10;
				pt.y += 10;
				
				m_watchTipMgr.showMountsTip(pt);
			}
			else
			{
				pt.x += btn.width / 2;
				m_gkcontext.m_uiTip.hintCondense(pt, "坐骑");
			}
		}
		
		private function onMouseMountsClk(event:MouseEvent):void
		{
			var mountssys:IUIMountsSys = m_gkcontext.m_UIMgr.getForm(UIFormID.UIMountsSys) as IUIMountsSys;
			var uishouhunother:Form;
			
			if (!mountssys)
			{
				//if (m_gkcontext.m_contentBuffer.getContent("stViewOtherUserMountCmd", false))
				if(m_gkcontext.m_mountsSysLogic.hasOtherMountsData())
				{
					m_gkcontext.m_mountsSysLogic.otherLoadModuleMode = true;
					m_gkcontext.m_UIMgr.loadForm(UIFormID.UIMountsSys);
				}
			}
			else if(mountssys && mountssys.isResReady())
			{
				//if (m_gkcontext.m_contentBuffer.getContent("stViewOtherUserMountCmd", false))
				if(m_gkcontext.m_mountsSysLogic.hasOtherMountsData())
				{
					uishouhunother = m_gkcontext.m_UIMgr.getForm(UIFormID.UIShouHunOtherPlayer);
					if (!uishouhunother)
					{
						mountssys.psstViewOtherUserMountCmd(m_gkcontext.m_contentBuffer.getContent("stViewOtherUserMountCmd", false) as ByteArray);
					}
				}
			}
		}
		
		//军团科技Tips
		private function onMouseCorpsRollOver(event:MouseEvent):void
		{
			var panel:Panel = event.currentTarget as Panel;
			var pt:Point = panel.localToScreen();
			
			var kejiList:Array = m_gkcontext.m_corpsMgr.m_otherKejiLearnd;
			
			if (kejiList && kejiList.length)
			{
				m_watchTipMgr.showCorpsTip(pt, kejiList);
			}
			else
			{
				pt.x += panel.width / 2;
				m_gkcontext.m_uiTip.hintCondense(pt, "军团科技");
			}
		}
		
		//神兵
		private function onMouseGodlyweaponRollOver(event:MouseEvent):void
		{
			var panel:Panel = event.currentTarget as Panel;
			var pt:Point = panel.localToScreen(new Point(-10, -10));
			
			if (m_gkcontext.m_watchMgr.m_weargwid > 0)
			{
				m_watchTipMgr.showGodlyweaponTip(pt);
			}
			else
			{
				pt.x += panel.width / 2 + 10;
				m_gkcontext.m_uiTip.hintCondense(pt, "神兵");
			}
		}
		
		override public function exit():void
		{
			m_gkcontext.m_zhanxingMgr.m_vecStarOtherPlayer = null;
			m_gkcontext.m_corpsMgr.m_otherKejiLearnd = null;
			
			var uishouhunother:Form = m_gkcontext.m_UIMgr.getForm(UIFormID.UIShouHunOtherPlayer);
			if (uishouhunother)
			{
				uishouhunother.exit();
			}
			
			if (m_uiWatchSelf)
			{
				m_uiWatchSelf.exit();
			}
			
			super.exit();
		}
	}
}