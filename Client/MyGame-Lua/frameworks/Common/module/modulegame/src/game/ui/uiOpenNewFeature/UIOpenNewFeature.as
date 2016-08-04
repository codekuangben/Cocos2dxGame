package game.ui.uiOpenNewFeature 
{
	import com.bit101.components.ButtonAni;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelDraw;
	import com.dgrigg.image.Image;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import com.ani.AniPosition;
	import modulecommon.commonfuntion.LocalDataMgr;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.scene.radar.RadarMgr;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import com.util.UtilColor;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIArenaSalary;
	import modulecommon.uiinterface.IUIScreenBtn;
	import modulecommon.uiinterface.IUiSysBtn;
	
	/**
	 * ...
	 * @author 
	 * 开启新功能
	 */
	public class UIOpenNewFeature extends Form
	{
		private var m_bgPart:PanelDraw;
		private var m_btn:ButtonAni;
		private var m_descLabel:Label;
		private var m_type:uint = SysNewFeatures.NFT_NONE;			//新功能编号
		private var m_flyBtnAni:AniPosition;
		private var m_destP:Point = null;
		
		public function UIOpenNewFeature() 
		{
			
		}
		
		override public function onReady():void
		{
			super.onReady();
			this.setSize(384, 254);
			
			m_bgPart = new PanelDraw(this);
			m_bgPart.setSize(this.width, this.height);
			//m_bgPart.addContainer();
			
			var panel:Panel;
			panel = new Panel(null, 58, 0);
			panel.setSize(267, 67);
			m_bgPart.addDrawCom(panel);
			panel.setPanelImageSkin("commoncontrol/panel/opennewfeature/featurename.png");
			
			panel = new Panel(null, 0, 67);
			panel.setSize(384, 187);
			m_bgPart.addDrawCom(panel);
			panel.setPanelImageSkinMirror("commoncontrol/panel/opennewfeature/bottomback.png", Image.MirrorMode_LR);
			
			panel = new Panel(null, 138, 81);
			panel.setSize(108, 108);
			m_bgPart.addDrawCom(panel);
			panel.setPanelImageSkin("commoncontrol/panel/opennewfeature/featureiconback.png");
			
			m_bgPart.drawPanel();
			
			m_btn = new ButtonAni(this, 140, 90);
			
			//m_descLabel = new Label(this, 42, 200, "新功能说明", 0x30ff20);
			m_descLabel = new Label(this, 42, 200, "新功能说明", UtilColor.tuple3Touint(53,40,30));
			m_descLabel.setSize(300, 24);
			m_descLabel.miaobian = false;
			m_descLabel.autoSize = false;
			m_descLabel.align = Component.CENTER;
			
			this.addEventListener(MouseEvent.CLICK, onClick);
			this.adjustPosWithAlign();
			this.darkOthers();
			//this._darkBG.mouseEnabled = false;
			
			m_flyBtnAni = new AniPosition();
		}
		
		override public function onStageReSize():void 
		{
			super.onStageReSize();
			this.darkOthers();
		}
		
		override public function updateData(param:Object = null):void
		{
			var type:uint = param as uint;
			
			if ((SysNewFeatures.NFT_NONE < type) && (type < SysNewFeatures.NFT_MAX))
			{
				m_type = type;
			}
			else
			{
				//收到type未在SysNewFeatures定义范围内，不显示开启新功能界面，结束新手引导
				m_gkcontext.m_newHandMgr.hide();
				return;
			}
			
			if (m_gkcontext.m_taskpromptMgr.isShowUITaskPrompt())
			{
				if (false == m_gkcontext.m_taskpromptMgr.m_bLoadConfig)
				{
					m_gkcontext.m_taskpromptMgr.initData();
				}
				
				if (m_gkcontext.m_UIMgr.hasForm(UIFormID.UITaskPrompt) == false)
				{
					m_gkcontext.m_UIMgr.loadForm(UIFormID.UITaskPrompt);
				}
			}
			
			if (m_gkcontext.m_UIs.hero)
			{
				if (SysNewFeatures.NFT_JUNTUAN == m_type)
				{//军团开启后，屏幕左上角，军团按钮图标显示
					m_gkcontext.m_UIs.hero.showCorpsIcon();
				}
				else if (SysNewFeatures.NFT_GODLYWEAPON == m_type)
				{//神兵
					m_gkcontext.m_UIs.hero.showGodlyWeapon();
				}
			}
			
			if (m_gkcontext.m_UIs.radar)
			{
				m_gkcontext.m_UIs.radar.addNewFeatureBtn(m_type);
			}
			
			setFeaturePicNameAndDisc(m_type);
			this.show();
		}
		
		override public function onShow():void 
		{
			super.onShow();
			
			m_gkcontext.m_localMgr.setShieldKeyEvent(LocalDataMgr.ShieldKeyEvent_UIOpenNewFeature);
			if (!m_gkcontext.m_newHandMgr.isVisible())
			{
				m_gkcontext.m_newHandMgr.setFocusFrame( -5, -5, m_btn._width + 10, m_btn.height + 10);
				m_gkcontext.m_newHandMgr.prompt(true, 10, 100, "请点击“开启新功能”界面，获得新功能", m_btn);
			}
			
			var formList:Array = [UIFormID.UIBackPack, UIFormID.UIEquipSys, UIFormID.UIZhenfa, UIFormID.UIXingMai, UIFormID.UIJiuGuan];
			var formid:uint;
			var i:int;
			
			for (i = 0; i < formList.length; i++)
			{
				formid = formList[i] as uint;
				
				if (m_gkcontext.m_UIMgr.isFormVisible(formid))
				{
					m_gkcontext.m_UIMgr.exitForm(formid);
				}
			}
		}
		
		override public function onHide():void 
		{
			m_gkcontext.m_localMgr.clearShieldKeyEvent(LocalDataMgr.ShieldKeyEvent_UIOpenNewFeature);
			super.onHide();
		}
		
		private function onClick(e:MouseEvent):void
		{
			if (e.target == this._darkBG)
			{
				return;
			}
			this.removeEventListener(MouseEvent.CLICK, onClick);
			if (m_gkcontext.m_newHandMgr.isVisible())
			{
				m_gkcontext.m_newHandMgr.promptOver();
			}
			
			var btn:ButtonAni;
			if (m_type == 3 || m_type == 5 || m_type == 6 || m_type == 7 || m_type == 8 || m_type == 9 || m_type == 18
				|| m_type == 25 || m_type == 28 || m_type == 29 || m_type == 31 || m_type == 32 || m_type == 34 || m_type == 35
				|| m_type == 40 || m_type == 41 || m_type == 45 || m_type == 46 || m_type == 47 || m_type == 50 || m_type == 51)
			{//酒馆、竞技场、藏宝库、战役挑战、过关斩将、悬赏任务、财神降临、组队副本、每日必做、三国战场、首冲礼包、一折大礼包、世界BOSS、王城争霸战、寻宝、福利大厅、三国群英会、神秘商店、跑商、vip体验、军团夺宝
				buttonToUiScreenBtn()
			}
			else if (m_type == 2 || m_type == 4 || m_type == 19 || m_type == 22 || m_type == 27 || m_type == 30 || m_type == 36 || m_type == 37)
			{//阵法、打造、打坐、武将库、军团、占星、铜雀台、坐骑
				buttonToUiSysBtn();
			}
			else if ((SysNewFeatures.NFT_XINGMAI == m_type)
				|| (SysNewFeatures.NFT_GODLYWEAPON == m_type)
				|| (SysNewFeatures.NFT_WUJIANGJIHUO <= m_type && m_type <= SysNewFeatures.NFT_EQUIPCOMPOSE) 
				|| (SysNewFeatures.NFT_EQUIPADVANCE == m_type)
				|| (SysNewFeatures.NFT_EQUIPLEVELUP == m_type)
				|| (SysNewFeatures.NFT_FHLIMIT4 == m_type) 
				|| (SysNewFeatures.NFT_FHLIMIT5 == m_type)
				|| (SysNewFeatures.NFT_HEROTRAIN == m_type)
				|| (SysNewFeatures.NFT_BAOWUROB == m_type)
				|| (SysNewFeatures.NFT_FRIENDSYS == m_type)
				|| (SysNewFeatures.NFT_USERACTRELAIONS == m_type))
			{
				iconMoveToDest();
			}
			else if (SysNewFeatures.NFT_QIANYAN == m_type)
			{
				if (m_gkcontext.m_UIs.taskTrace)
				{
					m_gkcontext.m_UIs.taskTrace.showNewHand(0, "请点击任务项，开始任务追踪，自动跑到目的地。");
				}
				exit();
			}
			else if (SysNewFeatures.NFT_GETGUANZHI == m_type)
			{
				var iuiarenasalary:IUIArenaSalary = m_gkcontext.m_UIMgr.getForm(UIFormID.UIArenaSalary) as IUIArenaSalary;
				if (iuiarenasalary && iuiarenasalary.isVisible())
				{
					iuiarenasalary.showNewHand();
				}
				exit();
			}
			else
			{
				exit();
			}
			
			if (m_gkcontext.m_UIs.taskPrompt)
			{
				m_gkcontext.m_UIs.taskPrompt.updatePrompt();
			}
			
		}
		
		private function buttonToUiScreenBtn():void
		{
			var pt:Point = this.localToScreen();
			if (m_gkcontext.m_UIs.screenBtn)
			{
				m_gkcontext.m_UIs.screenBtn.setNewButtonPos(ScreenBtnMgr.getBtnId(m_type));
				m_destP = m_gkcontext.m_UIs.screenBtn.getButtonPosInScreen(ScreenBtnMgr.getBtnId(m_type));
			}
			
			if (m_destP)
			{
				m_flyBtnAni.sprite = m_btn;
				m_flyBtnAni.setBeginPos(m_btn.x, m_btn.y);
				m_flyBtnAni.setEndPos(m_destP.x - pt.x, m_destP.y - pt.y);
				m_flyBtnAni.onEnd = onFlyToUiScreenBtnEnd;
				m_flyBtnAni.duration = 1;
				m_flyBtnAni.begin();
				m_gkcontext.m_UIs.screenBtn.vacateRoomForButton(m_type);
			}
			else
			{
				exit();
			}
		}
		
		private function onFlyToUiScreenBtnEnd():void
		{
			var btn:ButtonAni;
			if (m_gkcontext.m_UIs.screenBtn)
			{
				m_gkcontext.m_UIs.screenBtn.addNewFeature(m_type, m_btn);
				btn = m_gkcontext.m_UIs.screenBtn.getButton(ScreenBtnMgr.getBtnId(m_type));
			}
			
			if (btn && (SysNewFeatures.NFT_CANBAOKU == m_type || SysNewFeatures.NFT_JINGJICHANG == m_type || SysNewFeatures.NFT_TRIALTOWER == m_type
				|| SysNewFeatures.NFT_JIUGUAN == m_type))
			{
				m_gkcontext.m_newHandMgr.setFocusFrame( -10, -5, 96, 90, 1);
				m_gkcontext.m_newHandMgr.prompt(true, 25, 90, "请点击新开启功能按钮，探索新功能", btn);
			}
			else if (btn && (SysNewFeatures.NFT_CAISHENDAO == m_type))
			{
				m_gkcontext.m_newHandMgr.hide();
				m_gkcontext.m_sysnewfeatures.openOneFuncForm(m_type);
			}
			else
			{
				m_gkcontext.m_newHandMgr.hide();
			}
			
			exit();
		}
		
		private function buttonToUiSysBtn():void
		{
			var pt:Point = this.localToScreen();
			if (m_gkcontext.m_UIs.sysBtn)
			{
				m_destP = m_gkcontext.m_UIs.sysBtn.getButtonPosInScreen(m_type);
			}
			
			if (m_destP)
			{
				m_flyBtnAni.sprite = m_btn;
				m_flyBtnAni.setBeginPos(m_btn.x, m_btn.y);
				m_flyBtnAni.setEndPos(m_destP.x - pt.x, m_destP.y - pt.y);
				m_flyBtnAni.onEnd = onFlyToUiSysBtnEnd;
				m_flyBtnAni.duration = 1;
				m_flyBtnAni.begin();
				m_gkcontext.m_UIs.sysBtn.vacateRoomForButton(m_type);
			}
			else
			{
				exit();
			}
		}
		
		private function onFlyToUiSysBtnEnd():void
		{
			var btn:ButtonAni;
			if (m_gkcontext.m_UIs.sysBtn)
			{
				m_gkcontext.m_UIs.sysBtn.addNewFeature(m_type, m_btn);
				btn = m_gkcontext.m_UIs.sysBtn.getButton(m_type);
			}
			
			if (btn && (SysNewFeatures.NFT_ZHENFA == m_type || SysNewFeatures.NFT_DAZAO == m_type || SysNewFeatures.NFT_DAZUO == m_type
				|| SysNewFeatures.NFT_MOUNT == m_type || SysNewFeatures.NFT_TONGQUETAI == m_type))
			{
				m_gkcontext.m_newHandMgr.setFocusFrame(-7, 0, 70, 90, 1);
				m_gkcontext.m_newHandMgr.prompt(true, 2, 20, "请点击新开启功能按钮，探索新功能", btn);
			}
			else if (btn && (SysNewFeatures.NFT_HEROXIAYE == m_type || SysNewFeatures.NFT_JUNTUAN == m_type || SysNewFeatures.NFT_ZHANXING == m_type))
			{
				m_gkcontext.m_newHandMgr.hide();
				m_gkcontext.m_sysnewfeatures.openOneFuncForm(m_type);
			}
			else
			{
				m_gkcontext.m_newHandMgr.hide();
			}
			
			exit();
		}
		
		private function iconMoveToDest():void
		{
			var pt:Point = this.localToScreen();
			if (SysNewFeatures.NFT_XINGMAI == m_type || SysNewFeatures.NFT_GODLYWEAPON == m_type)
			{
				if (m_gkcontext.m_UIs.hero)
				{
					m_destP = m_gkcontext.m_UIs.hero.getButtonPosInScreen(m_type);
				}
			}
			else if (SysNewFeatures.NFT_FRIENDSYS == m_type)
			{
				if (m_gkcontext.m_UIs.radar)
				{
					m_destP = m_gkcontext.m_UIs.radar.getBtnPosInRadarByIdx(RadarMgr.getBtnId(m_type));
					if (m_destP)
					{
						m_destP.y += 32;
					}
				}
			}
			else if ((SysNewFeatures.NFT_WUJIANGJIHUO <= m_type && SysNewFeatures.NFT_EQUIPCOMPOSE >= m_type) 
				|| (SysNewFeatures.NFT_EQUIPADVANCE == m_type)
				|| (SysNewFeatures.NFT_EQUIPLEVELUP == m_type)
				|| (SysNewFeatures.NFT_FHLIMIT4 == m_type) 
				|| (SysNewFeatures.NFT_FHLIMIT5 == m_type)
				|| (SysNewFeatures.NFT_HEROTRAIN == m_type)
				|| (SysNewFeatures.NFT_USERACTRELAIONS == m_type))
			{
				if (m_gkcontext.m_UIs.sysBtn)
				{
					m_destP = m_gkcontext.m_UIs.sysBtn.getButtonPosInScreen(m_type);
				}
			}
			else if (SysNewFeatures.NFT_BAOWUROB == m_type)
			{
				if (m_gkcontext.m_UIs.screenBtn)
				{
					m_destP = m_gkcontext.m_UIs.screenBtn.getButtonPosInScreen(ScreenBtnMgr.getBtnId(m_type));
				}
			}
			
			if (m_destP)
			{
				m_flyBtnAni.sprite = m_btn;
				m_flyBtnAni.setBeginPos(m_btn.x, m_btn.y);
				m_flyBtnAni.setEndPos(m_destP.x - pt.x, m_destP.y - pt.y);
				m_flyBtnAni.onEnd = onFlytoDestEnd;
				m_flyBtnAni.duration = 1.4;
				m_flyBtnAni.begin();
			}
			else
			{
				exit();
				m_gkcontext.m_newHandMgr.hide();
			}
		}
		
		private function onFlytoDestEnd():void
		{
			var btn:ButtonAni;
			if (SysNewFeatures.NFT_XINGMAI == m_type || SysNewFeatures.NFT_GODLYWEAPON == m_type)
			{//“星脉”、“神兵”
				//if (m_gkcontext.m_UIs.hero)
				//{
				//	m_gkcontext.m_UIs.hero.showNewHand();
				//}
				m_gkcontext.m_newHandMgr.hide();
				m_gkcontext.m_sysnewfeatures.openOneFuncForm(m_type);
			}
			else if (SysNewFeatures.NFT_FRIENDSYS == m_type)
			{//"好友"
				//if (m_gkcontext.m_UIs.radar)
				//{
				//	m_gkcontext.m_UIs.radar.showNewHand();
				//}
				m_gkcontext.m_newHandMgr.hide();
				m_gkcontext.m_sysnewfeatures.openOneFuncForm(m_type);
			}
			else if (SysNewFeatures.NFT_JINNANG == m_type)
			{//“阵法”
				if (m_gkcontext.m_UIs.sysBtn)
				{
					btn = m_gkcontext.m_UIs.sysBtn.getButton(SysNewFeatures.NFT_ZHENFA);
				}
				if (btn)
				{
					m_gkcontext.m_newHandMgr.setFocusFrame(-7, 0, 70, 90, 1);
					m_gkcontext.m_newHandMgr.prompt(true, 2, 20, "点击打开“阵法”界面。", btn);
				}
			}
			else if (14 == m_type || 15 == m_type || 16 == m_type || 17 == m_type || 26 == m_type || 38 == m_type)
			{//“锻造”
				m_gkcontext.m_sysnewfeatures.openOneFuncForm(m_type);
				/*
				if (m_gkcontext.m_UIs.sysBtn)
				{
					btn = m_gkcontext.m_UIs.sysBtn.getButton(SysNewFeatures.NFT_DAZAO);
				}
				if (btn)
				{
					m_gkcontext.m_newHandMgr.setFocusFrame(-7, 0, 70, 90, 1);
					m_gkcontext.m_newHandMgr.prompt(true, 2, 20, "点击打开“锻造”功能界面。", btn);
				}
				*/
			}
			else if (SysNewFeatures.NFT_WUJIANGJIHUO == m_type || SysNewFeatures.NFT_HEROREBIRTH == m_type || SysNewFeatures.NFT_HEROTRAIN == m_type || SysNewFeatures.NFT_USERACTRELAIONS == m_type)
			{//“人物”
				if (SysNewFeatures.NFT_WUJIANGJIHUO == m_type)
				{
					m_gkcontext.m_newHandMgr.hide();
				}
				m_gkcontext.m_sysnewfeatures.openOneFuncForm(m_type);
				/*
				if (m_gkcontext.m_UIs.sysBtn)
				{
					btn = m_gkcontext.m_UIs.sysBtn.getButton(m_type);
				}
				if (btn)
				{
					m_gkcontext.m_newHandMgr.setFocusFrame(-7, 0, 70, 90, 1);
					m_gkcontext.m_newHandMgr.prompt(true, 2, 20, "点击打开“人物”界面。", btn);
				}
				*/
			}
			else if (SysNewFeatures.NFT_BAOWUROB == m_type)
			{//“酒馆”
				if (m_gkcontext.m_UIs.screenBtn)
				{
					btn = m_gkcontext.m_UIs.screenBtn.getButton(ScreenBtnMgr.getBtnId(m_type));
				}
				if (btn)
				{
					m_gkcontext.m_newHandMgr.setFocusFrame( -10, -5, 96, 90, 1);
					m_gkcontext.m_newHandMgr.prompt(true, 25, 90, "点击打开“酒馆”界面。", btn);
				}
			}
			else if (SysNewFeatures.NFT_FHLIMIT4 == m_type)
			{//"阵法"
				if (m_gkcontext.m_UIs.sysBtn)
				{
					btn = m_gkcontext.m_UIs.sysBtn.getButton(m_type);
				}
				if (btn)
				{
					m_gkcontext.m_newHandMgr.setFocusFrame(-7, 0, 70, 90, 1);
					m_gkcontext.m_newHandMgr.prompt(true, 2, 20, "点击打开“阵法”界面。", btn);
				}
			}
			else if (SysNewFeatures.NFT_FHLIMIT5 == m_type)	//出战武将人数上限增加
			{
				if (m_gkcontext.m_newHandMgr.isVisible())
				{
					m_gkcontext.m_newHandMgr.hide();
					m_gkcontext.m_sysnewfeatures.openOneFuncForm(m_type);
				}
			}
			
			exit();
		}
		
		//设置新功能的 功能图标、功能描述
		private function setFeaturePicNameAndDisc(type:uint):void
		{
			var picname:String;
			var desc:String;
			var posy:int = 0;
			var bScreenBtn:Boolean = true;
			var bSysBtn:Boolean = false;
			
			switch(type)
			{
				case SysNewFeatures.NFT_XINGMAI:
					picname = "xingmai";
					bScreenBtn = false;
					desc = "激活觉醒，能够大大增加您的属性！";
					m_btn.setSize(82, 74);
					break;
				case SysNewFeatures.NFT_GODLYWEAPON:
					picname = "shenbing";
					bScreenBtn = false;
					desc = "神兵在手，数倍属性加成，瞬间强大！";
					m_btn.setSize(76, 76);
					posy = -7;
					break;
				case SysNewFeatures.NFT_ZHENFA:
					picname = "zhenxingbtn";
					bScreenBtn = false;
					bSysBtn = true;
					desc = "通过阵法可让您收服的武将出战。";
					posy = -5;
					break;
				case SysNewFeatures.NFT_JIUGUAN:
					picname = "screenbtn/jiuguan.png";
					desc = "您可以在酒馆中招募已经结识的名将们哦！";
					posy = -7;
					break;
				case SysNewFeatures.NFT_DAZAO:
					picname = "duanzaobtn";
					bScreenBtn = false;
					bSysBtn = true;
					desc = "强化装备能让你变得更加强大。";
					posy = -5;
					break;
				case SysNewFeatures.NFT_JINGJICHANG:
					picname = "screenbtn/wujuleitai.png";
					desc = "通过竞技场可以赢得大量奖励和各种官职。";
					posy = -7;
					break;
				case SysNewFeatures.NFT_CANBAOKU:
					picname = "screenbtn/cangbaoku.png";
					desc = "战胜藏宝窟内的守卫能让您一夜暴富！";
					posy = -7;
					break;
				case SysNewFeatures.NFT_ZHANYITIAOZHAN:
					picname = "screenbtn/zhanyitiaozhan.png";
					desc = "战役中各种宝物可帮助你不断提升能力。";
					posy = -7;
					break;
				case SysNewFeatures.NFT_TRIALTOWER:
					picname = "screenbtn/guoguanzhanjiang.png";
					desc = "每过一层都能获得大量的道具。";
					posy = -7;
					break;
				case SysNewFeatures.NFT_XUANSHANG:
					picname = "screenbtn/xuanshangrenwu.png";
					desc = "各色悬赏任务能大大提升您练级速度。";
					posy = -7;
					break;
				case SysNewFeatures.NFT_CAISHENDAO:
					picname = "screenbtn/ingotbefall.png";
					desc = "财神降临，奉送海量银币。";
					posy = -7;
					break;
				case SysNewFeatures.NFT_TEAMCOPY:
					picname = "screenbtn/teamfb.png";
					desc = "组队副本，携好友一起征战沙场。";
					posy = -7;
					break;
				case SysNewFeatures.NFT_MEIRIBIZUO:
					picname = "screenbtn/dailyactivites.png";
					desc = "每日必做，拥有一颗坚持的心，笑傲江湖，舍我其谁。";
					posy = -7;
					break;
				case SysNewFeatures.NFT_SANGUOZHANCHANG:
					picname = "screenbtn/sanguozhanchang.png";
					desc = "三国战场，江湖英雄，唯我独尊。";
					posy = -7;
					break;
				case SysNewFeatures.NFT_QIANYAN:
					picname = "qianyan";
					bScreenBtn = false;
					desc = "帮助您看清楚地上遗落的金钱。";
					m_btn.setSize(74, 65);
					break;
				case SysNewFeatures.NFT_WUJIANGJIHUO:
					picname = "vip/guanxijihuo.png";
					desc = "被激活的武将能够大大增加他的能力。";
					posy = -7;
					break;
				case SysNewFeatures.NFT_JINNANG:
					picname = "jinnang";
					bScreenBtn = false;
					desc = "合理利用锦囊可以让你战无不胜！";
					m_btn.setSize(76, 76);
					posy = -7;
					break;
				case SysNewFeatures.NFT_HEROREBIRTH:
					picname = "vip/zhuansheng.png";
					desc = "武将转生，属性大幅提升。";
					posy = -7;
					break;
				case SysNewFeatures.NFT_GEMEMBED:
					picname = "vip/baoshi.png";
					desc = "镶嵌各种宝石能让你的装备变得更加强大。";
					posy = -7;
					break;
				case SysNewFeatures.NFT_EQUIPXILIAN:
					picname = "vip/xilian.png";
					desc = "洗炼可以使装备获得各种属性。";
					posy = -7;
					break;
				case SysNewFeatures.NFT_EQUIPDECOMPOSE:
					picname = "vip/fenjie.png";
					desc = "将不用的装备分解，以获得洗炼装备的必需品洗炼石。";
					posy = -7;
					break;
				case SysNewFeatures.NFT_EQUIPCOMPOSE:
					picname = "vip/hecheng.png";
					desc = "合成可以将现有武器锻造成诸神之兵器。";
					posy = -7;
					break;
				case SysNewFeatures.NFT_EQUIPADVANCE:
					picname = "vip/jinjie.png";
					desc = "装备进阶，升级装备品质，增加更多属性。";
					posy = -7;
					break;
				case SysNewFeatures.NFT_EQUIPLEVELUP:
					picname = "vip/zhuangbeishengji.png";
					desc = "装备升级，收集材料，升级装备，再也不用担心没装备穿了。";
					posy = -7;
					break;
				case SysNewFeatures.NFT_DAZUO:
					picname = "dazuobtn";
					bScreenBtn = false;
					bSysBtn = true;
					desc = "通过打坐修炼获得无数经验，助你快速升级，并有机会收获元宝。";
					posy = -5;
					break;
				case SysNewFeatures.NFT_FHLIMIT4:
					picname = "zhenxingbtn";
					bScreenBtn = false;
					bSysBtn = true;
					desc = "出战武将人数上限增加到 4人。";
					posy = -5;
					break;
				case SysNewFeatures.NFT_FHLIMIT5:
					picname = "zhenxingbtn";
					bScreenBtn = false;
					bSysBtn = true;
					desc = "出战武将人数上限增加到 5人。";
					posy = -5;
					break;
				case SysNewFeatures.NFT_HEROXIAYE:
					picname = "wujiangbtn";
					bScreenBtn = false;
					bSysBtn = true;
					desc = "武将下野，在已拥有武将中随意挑选得意战将，征战四方。";
					posy = -5;
					break;
				case SysNewFeatures.NFT_FRIENDSYS:
					picname = "haoyou";
					bScreenBtn = false;
					desc = "好友，分享快乐，健康游戏。";
					m_btn.setSize(32, 32);
					break;
				case SysNewFeatures.NFT_HEROTRAIN:
					picname = "wujiangbtn";
					bScreenBtn = false;
					bSysBtn = true;
					desc = "武将培养，开发武将潜能，提升无限属性。";
					posy = -5;
					break;
				case SysNewFeatures.NFT_USERACTRELAIONS:
					picname = "wujiangbtn";
					bScreenBtn = false;
					bSysBtn = true;
					desc = "我的三国关系，主角不在是“刘阿斗”了。";
					posy = -5;
					break;
				case SysNewFeatures.NFT_JUNTUAN:
					picname = "juntuanbtn";
					bScreenBtn = false;
					bSysBtn = true;
					desc = "三国乱世，人走江湖，军团，就是你的港湾。";
					posy = -5;
					break;
				case SysNewFeatures.NFT_ZHANXING:
					picname = "wuxuebtn";
					bScreenBtn = false;
					bSysBtn = true;
					desc = "武学，想知道这是什么吗，那就快快来吧。";
					posy = -5;
					break;
				case SysNewFeatures.NFT_TONGQUETAI:
					picname = "tongquetaibtn";
					bScreenBtn = false;
					bSysBtn = true;
					desc = "铜雀台，美女簇拥，日日歌声艳舞，好不享受。";
					posy = -5;
					break;
				case SysNewFeatures.NFT_MOUNT:
					picname = "mountsbtn";
					bScreenBtn = false;
					bSysBtn = true;
					desc = "坐骑，征战沙场好伴侣，各种属性，各种帅气。";
					posy = -5;
					break;
				case SysNewFeatures.NFT_FIRSTCHARGEGIFTBOX:
					picname = "screenbtn/shouchongdali.png";
					desc = "首充大礼包，不需9999，也不需999，更不需99，只要9.999。";
					posy = -7;
					break;
				case SysNewFeatures.NFT_TENPERCENTGIFTBOX:
					picname = "screenbtn/yizhelibao.png";
					desc = "一折大礼包，各种奇珍异宝，等你来。";
					posy = -7;
					break;
				case SysNewFeatures.NFT_WORLDBOSS:
					picname = "screenbtn/shijieboss.png";
					desc = "世界Boss，你觉得自己，天下无敌、战无不胜？那就来吧。";
					posy = -7;
					break;
				case SysNewFeatures.NFT_BAOWUROB:
					picname = "baowurob";
					bScreenBtn = false;
					desc = "宝物不是天上掉下来的，别人仓库里多的是。";
					m_btn.setSize(76, 76);
					posy = -7;
					break;
				case SysNewFeatures.NFT_CITYBATTLE:
					picname = "screenbtn/corpscitysys.png";
					desc = "王城争霸，我们军团实力最强，不服来战。";
					posy = -7;
					break;
				case SysNewFeatures.NFT_TREASUREHUNTING:
					picname = "screenbtn/xunbao.png";
					desc = "寻宝，各种稀奇古怪的玩意儿。";
					posy = -7;
					break;
				case SysNewFeatures.NFT_WELFAREHALL:
					picname = "screenbtn/fulidating.png";
					desc = "福利大厅，各种惊喜，各种优惠。";
					posy = -7;
					break;
				case SysNewFeatures.NFT_SGQUNYINGHUI:
					picname = "screenbtn/yingxionghui.png";
					desc = "三国群英会，各路英雄豪杰，霸者何在，竞相角逐。";
					posy = -7;
					break;
				case SysNewFeatures.NFT_GETGUANZHI:
					picname = "lingqufenglu";
					bScreenBtn = false;
					desc = "官职俸禄，每日争得官职，为人民服务，怎能白费辛苦。";
					m_btn.setSize(76, 76);
					posy = -7;
					break;
				case SysNewFeatures.NFT_SECRETSTORE:
					picname = "screenbtn/mysteryshop.png";
					desc = "神秘商店，银子？元宝？珠宝？绝世神兵...";
					posy = -7;
					break;
				case SysNewFeatures.NFT_PAOSHANG:
					picname = "screenbtn/paoshang.png";
					desc = "跑商，这是什么，赶快去瞧瞧！";
					posy = -7;
					break;
				case SysNewFeatures.NFT_VIPPRACTICE:
					picname = "screenbtn/viptiyan.png";
					desc = "vip体验，一次充值长期获利。";
					posy = -7;
					break;
				case SysNewFeatures.NFT_CORPSTREASURE:
					picname = "screenbtn/corpstreasure.png";
					desc = "军团夺宝，我们团是最厉害的，宝藏属于我们。";
					posy = -7;
					break;
				deafult:
					return;
			}
			
			if (bScreenBtn)
			{
				m_btn.setSkinButton1Image(picname);
				m_btn.setSize(76, 76);
			}
			else if (bSysBtn)
			{
				m_btn.setSkinButton1Image("commoncontrol/panel/sysbtn/" + picname + ".png");
				m_btn.setSize(56, 81);
			}
			else
			{
				m_btn.setSkinButton1Image("commoncontrol/panel/opennewfeature/featureicon/" + picname + ".png");
			}
			m_btn.x = 138 + (108 - m_btn.width) / 2;
			m_btn.y = posy + 81 + (108 - m_btn.height) / 2;
			m_descLabel.text = desc;
		}
		
		override public function dispose():void
		{
			if (m_flyBtnAni)
			{
				m_flyBtnAni.dispose();
			}
			
			super.dispose();
		}
		
	}

}