package game.ui.uiHero
{
	import com.bit101.components.Ani;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.PushButton;
	import com.bit101.components.progressBar.BarInProgress2;
	import com.dgrigg.image.CommonImageManager;
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.SWFResource;
	import com.util.DebugBox;
	import modulecommon.commonfuntion.SysOptions;
	import modulecommon.scene.hero.AttrBufferMgr;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import modulecommon.appcontrol.DigitComponent;
	import modulecommon.appcontrol.Icon_ValueCtrol;
	import modulecommon.appcontrol.MoneyPanel;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.net.msg.mountscmd.stMountData;
	import modulecommon.net.msg.propertyUserCmd.stReqFreeLingPaiInfoCmd;
	import modulecommon.scene.beings.MountsShareData;
	import modulecommon.scene.beings.MountsSys;
	import modulecommon.scene.prop.BeingProp;
	import modulecommon.scene.prop.relation.KejiItemInfo;
	import modulecommon.scene.prop.relation.KejiLearnedItem;
	import modulecommon.scene.prop.table.TMouseItem;
	import modulecommon.scene.wu.WuMainProperty;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIHero;
	
	import org.ffilmation.engine.helpers.fUtil;
	
	import game.ui.uiHero.bufferIcon.BufferIconPanel;
	import game.ui.uiHero.subForm.UIInput;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class UIHero extends Form implements IUIHero
	{
		private static const VALUE_Yinbi:uint = 0;
		private static const VALUE_Yuanbao:uint = 1;
		private static const VALUE_Lingpai:uint = 2;
		
		private var m_vecItem:Vector.<Icon_ValueCtrol>;
		
		private var m_zhanliImage:Panel;
		private var m_zhanliDC:DigitComponent;
		
		private var m_chargeBtn:Ani;			//充值按钮
		private var m_speakerBtn:PushButton;	//声音开关按钮
		private var m_vipBtn:PushButton;
		private var m_levelLabel:Label;
		private var m_nameLabel:Label;			//玩家姓名
		private var m_vipLabel:Label;			//vip
		private var m_roundheadPanel:Panel;		//圆头像
		private var m_lingpaiPanel:PanelContainer;	//令牌数量进度条
		private var m_lingpaiBar:BarInProgress2;	//令牌数量进度条
		private var m_getLingpaiBtn:PushButton;		//购买令牌按钮
		private var m_buyLingpaiLabel:Label;		//"购买令牌"
		private var m_jianghun:JianghunEff;
		private var m_uiInput:UIInput;
		private var m_corpsIcon:Panel;					//军团Icon
		private var m_mountsIcon:Panel;					//坐骑Icon
		private var m_aniInScreen:AniInScreen;
		private var m_bufferIconPanel:BufferIconPanel;	//药水bufferIcon
		private var m_godlyWeapon:Godlyweapon;			//神兵Icon
		
		public function UIHero():void
		{
		
		}
		
		public static function IMAGESWF():String
		{
			return CommonImageManager.toPathString("module/imageuihero.swf");
		}
		
		override public function onReady():void
		{
			try
			{
			this.setSize(359, 119);
			this.marginLeft = 3;
			this.marginTop = 5;
			this.alignHorizontal = Component.LEFT;
			this.alignVertial = Component.TOP;
			this.adjustPosWithAlign();
			this.draggable = false;
			this.m_gkcontext.m_UIs.hero = this;
			m_gkcontext.m_context.m_resMgr.load(IMAGESWF(), SWFResource, onImageSwfLoaded, onImageSwfFailed);
			
			var left:int = 120;
			var top:int = 36;
			var intervalH:int = 69;
			var intervalV:int = 26;
			var i:int;
			//游戏币(银币) 令牌   绑定人民币(金币)	 人民币(元宝) 
			var arr:Array = [BeingProp.SILVER_COIN, BeingProp.YUAN_BAO, BeingProp.LING_PAI];
			var item:Icon_ValueCtrol;
			m_vecItem = new Vector.<Icon_ValueCtrol>(3);
			var str:String;
			var moneyPanel:MoneyPanel;
			for (i = 0; i < 3; i++)
			{
				item = new Icon_ValueCtrol(this, false);
				item.setPos(left + (i % 2) * intervalH, top + Math.floor(i / 2) * intervalV);
				item.setSize(105, 16);
				item.drawRectBG();
				moneyPanel = new MoneyPanel(m_gkcontext, item);
				moneyPanel.type = arr[i];
				item.m_icon = moneyPanel;
				
				item.m_value.setPos(18, -1);
				item.m_value.setBold(true);
				item.tag = i;
				item.addEventListener(MouseEvent.ROLL_OUT, m_gkcontext.hideTipOnMouseOut);
				item.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
				
				m_vecItem[i] = item;
			}
			
			m_vecItem[2].addEventListener(MouseEvent.CLICK, onClickGetLingpaiBtn);
			m_vecItem[2].buttonMode = true;
			
			m_lingpaiPanel = new PanelContainer(this, 138, 66);
			m_lingpaiPanel.mouseEnabled = false;
			m_lingpaiBar = new BarInProgress2(m_lingpaiPanel, 0, 0);
			m_lingpaiBar.setSize(89, 9);
			m_lingpaiBar.setHorizontalImageSkin("commoncontrol/horstretch/progressLingpai_mirror.png");
			m_lingpaiBar.autoSizeByImage = false;
			m_lingpaiBar.mouseEnabled = false;
			m_lingpaiBar.maximum = 1;
			m_lingpaiBar.initValue = 0;
			
			m_getLingpaiBtn = new PushButton(this, 228, 63, onClickGetLingpaiBtn);
			m_getLingpaiBtn.setSize(15, 15);
			m_getLingpaiBtn.setSkinButton1Image("commoncontrol/panel/plus.png");
			m_getLingpaiBtn.addEventListener(MouseEvent.ROLL_OUT, m_gkcontext.hideTipOnMouseOut);
			m_getLingpaiBtn.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOverBtn);
			m_getLingpaiBtn.tag = 10;
			if (m_gkcontext.m_beingProp.vipLevel >= 1 && (getMoney(BeingProp.LING_PAI) < 20 || m_gkcontext.playerMain.level >= 20))
			{
				m_getLingpaiBtn.visible = true;
			}
			else
			{
				m_getLingpaiBtn.visible = false;
			}
			
			m_buyLingpaiLabel = new Label(m_lingpaiPanel, 33, -5, "购买令牌", UtilColor.WHITE_Yellow);
			m_buyLingpaiLabel.miaobian = false;
			
			if (getMoney(BeingProp.LING_PAI) < 10)
			{
				m_buyLingpaiLabel.visible = true;
			}
			else
			{
				m_buyLingpaiLabel.visible = false;
			}
			
			m_roundheadPanel = new Panel(this, 2, -10);
			m_roundheadPanel.setPanelImageSkin(m_gkcontext.m_context.m_playerResMgr.roundHeadPathName(m_gkcontext.playerMain.job, m_gkcontext.playerMain.gender));
			
			m_nameLabel = new Label(this, 138, 9, "英雄", 0xfbdda2);
			m_nameLabel.setSize(82, 14);
			m_nameLabel.autoSize = false;
			m_nameLabel.align = Component.CENTER;
			m_nameLabel.text = m_gkcontext.playerMain.name;
			
			m_levelLabel = new Label(this, 249, 18);
			m_levelLabel.setSize(24, 24);
			m_levelLabel.autoSize = false;
			m_levelLabel.align = Component.CENTER;
			
			m_jianghun = new JianghunEff(m_gkcontext, this, 266, 39);
			m_jianghun.addEventListener(MouseEvent.CLICK, onClick);
			m_jianghun.buttonMode = true;
			
			m_zhanliDC = new DigitComponent(m_gkcontext.m_context, this, 160, 86);
			
			m_zhanliDC.setParam("commoncontrol/digit/digit01", 10, 18);
			
			m_chargeBtn = new Ani(m_gkcontext.m_context);
			this.addChild(m_chargeBtn);
			m_chargeBtn.centerPlay = true;
			m_chargeBtn.x = 260;
			m_chargeBtn.y = 92;
			m_chargeBtn.setImageAni("ejchongzhixiaoguo.swf");
			m_chargeBtn.duration = 2;
			m_chargeBtn.repeatCount = 0;
			m_chargeBtn.begin();
			m_chargeBtn.buttonMode = true;
			m_chargeBtn.addEventListener(MouseEvent.CLICK, onChargeBtnClick);
			
			m_aniInScreen = new AniInScreen(m_gkcontext, this);
			
			// Form 创建完成后就立马创建
			m_vipBtn = new PushButton(this, 29, 96, onVipBtnClick);
			m_vipBtn.setSize(58, 16);
			m_vipBtn.beginLiuguang();
			//m_vipBtn.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOverBtn);
			//m_vipBtn.addEventListener(MouseEvent.ROLL_OUT, m_gkcontext.hideTipOnMouseOut);
			m_vipBtn.tag = 11;
			
			m_vipLabel = new Label(m_vipBtn, 4, 0, "VIP", 0xfbdda2);
			m_vipLabel.setSize(50, 16);
			m_vipLabel.autoSize = false;
			m_vipLabel.align = Component.CENTER;
			
			super.onReady();
			
			// 坐骑头像
			if((this.m_gkcontext.m_playerManager.hero.horseSys as MountsSys).mountsAttr.baseAttr.ridemount)
			{
				showMountIcon();
			}
			
			if (m_gkcontext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_GODLYWEAPON))
			{
				showGodlyWeapon();
			}
			}
			catch (e:Error)
			{
				var strLog:String = "UIHero::onReady ";
				strLog += fUtil.keyValueToString("m_gkcontext.playerMain", m_gkcontext.playerMain, "m_gkcontext.m_mainPro.level", m_gkcontext.m_mainPro.level, "m_playerManager.hero", m_gkcontext.m_playerManager.hero);
				DebugBox.sendToDataBase(strLog);
			}
		}
		
		override public function onDestroy():void
		{
			m_gkcontext.m_UIs.hero = null;
			
			if (m_uiInput)
			{
				m_gkcontext.m_UIMgr.destroyForm(m_uiInput.id);
				m_uiInput = null;
			}
			
			if (m_mountsIcon)
			{
				m_mountsIcon.removeEventListener(MouseEvent.ROLL_OUT, m_gkcontext.hideTipOnMouseOut);
				m_mountsIcon.removeEventListener(MouseEvent.ROLL_OVER, onMountsIconMouseOver);
			}
		}
		
		override public function onStageReSize():void
		{
			super.onStageReSize();
			m_aniInScreen.onStageReSize();
		}
		
		private function onImageSwfLoaded(event:ResourceEvent):void
		{
			var resource:SWFResource = event.resourceObject as SWFResource;
			createImage(resource);
			m_gkcontext.m_context.m_resMgr.unload(IMAGESWF(), SWFResource);
		
		}
		
		private function getMoney(type:int):uint
		{
			return m_gkcontext.m_beingProp.getMoney(type);
		}
		
		public function updateLevel():void
		{
			try
			{
			var wu:WuMainProperty = this.m_gkcontext.m_wuMgr.getMainWu();
			if (wu)
			{
				m_levelLabel.text = wu.m_uLevel.toString();
				if (wu.m_uLevel >= 20)
				{
					if (m_gkcontext.m_beingProp.vipLevel >= 1)
					{
						m_getLingpaiBtn.visible = true;
					}
				}
			}
			}
			catch (e:Error)
			{
				var strLog:String = "UIHero::updateLevel ";
				strLog += fUtil.keyValueToString("m_gkcontext", m_gkcontext, "m_levelLabel", m_levelLabel, "m_getLingpaiBtn", m_getLingpaiBtn);
				DebugBox.sendToDataBase(strLog);
			}
		}
		
		public function updateGamemoney():void
		{
			var money:uint = getMoney(BeingProp.SILVER_COIN);
			if (money / 100000 > 1)
			{
				m_vecItem[VALUE_Yinbi].m_value.text = Math.floor(money / 10000).toString() + "万";
			}
			else
			{
				m_vecItem[VALUE_Yinbi].m_value.text = money.toString();
			}
		}
		
		public function updateRMB():void
		{
			var money:uint = getMoney(BeingProp.YUAN_BAO);
			if (money / 100000 > 1)
			{
				m_vecItem[VALUE_Yuanbao].m_value.text = Math.floor(money / 10000).toString() + "万";
			}
			else
			{
				m_vecItem[VALUE_Yuanbao].m_value.text = money.toString();
			}
		}
		
		public function updateLingpai():void
		{
			var curlingpai:uint = getMoney(BeingProp.LING_PAI);
			var v:Number = curlingpai / 200;
			m_lingpaiBar.value = v;
			DebugBox.addLog("更新 令牌=" + curlingpai.toString() + "  lingpaiBar.value=" + v.toString());
			
			if (m_gkcontext.m_beingProp.vipLevel >= 1 && (curlingpai < 20 || m_gkcontext.playerMain.level >= 20))
			{
				m_getLingpaiBtn.visible = true;
			}
			else
			{
				m_getLingpaiBtn.visible = false;
			}
			
			if (getMoney(BeingProp.LING_PAI) < 10)
			{
				m_buyLingpaiLabel.visible = true;
			}
			else
			{
				m_buyLingpaiLabel.visible = false;
			}
			
			var form:Form = m_gkcontext.m_UIMgr.getForm(UIFormID.UIFubenSaoDang);
			if (form)
			{
				form.updateData();
			}
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			var item:Icon_ValueCtrol = event.currentTarget as Icon_ValueCtrol;
			if (item == null)
			{
				return;
			}
			var str:String;
			switch (item.tag)
			{
				case 0: 
					str = "银币 " + getMoney(BeingProp.SILVER_COIN).toString();
					break;
				case 1: 
					str = "元宝 " + getMoney(BeingProp.YUAN_BAO).toString();
					break;
				case 2:
					str = "令牌 " + getMoney(BeingProp.LING_PAI) + "   上限200，每10分钟获得1个令牌";
					break;
			}
			var pt:Point = item.localToScreen(new Point(60, 4));
			
			m_gkcontext.m_uiTip.hintCondense(pt, str);
		}
		
		private function createImage(resource:SWFResource):void
		{
			this.setPanelImageSkinBySWF(resource, "uiHero.uiHerobg");
			
			m_zhanliImage = new Panel(this, 110, 80);
			m_zhanliImage.setSize(40, 27);
			m_zhanliImage.setPanelImageSkinBySWF(resource, "uiHero.zhanli");
			
			m_speakerBtn = new PushButton(this, 85, 10, onSpeakerBtnClick);
			m_speakerBtn.recycleSkins = true;
			m_speakerBtn.setSize(24, 24);
			m_speakerBtn.setSkinButton1ImageBySWF(resource, "uiHero.Speaker");
			
			if (m_gkcontext.m_sysOptions.isSet(SysOptions.COMMONSET_CLIENT_LDSSound))
			{
				m_speakerBtn.setSkinButton1Image("commoncontrol/panel/speaker_forbid.png");
			}
			
			m_vipBtn.setSkinButton1ImageBySWF(resource, "uiHero.bluebotton");
			
			m_lingpaiPanel.setPanelImageSkinBySWF(resource, "uiHero.junlingBg");
			
			initData();
		}
		
		public function updateAlldata():void
		{
			updateLevel();
			updateGamemoney();
			updateRMB();
			updateVipLevel();
			updateJianghun();
			updateLingpai();
		}
		
		public function upZongZhanli():void
		{
			var wu:WuMainProperty = this.m_gkcontext.m_wuMgr.getMainWu();
			if (wu == null)
			{
				return;
			}
			
			m_zhanliDC.digit = wu.m_uZongZhanli;
		}
		
		public function updateJianghun():void
		{
			m_jianghun.updateJianghun();
		}
		
		public function updateVipLevel():void
		{
			var level:int = m_gkcontext.m_beingProp.vipLevel;
			if (level)
			{
				m_vipLabel.text = "VIP " + level.toString();
			}
			
			if (level >= 1 && (getMoney(BeingProp.LING_PAI) < 20 || m_gkcontext.playerMain.level >= 20))
			{
				m_getLingpaiBtn.visible = true;
			}
			if (m_gkcontext.m_elitebarrierMgr.m_bInJBoss && m_bufferIconPanel)
			{
				m_bufferIconPanel.updataJbossBuf(AttrBufferMgr.Buffer_Jili);
			}
		}
		
		private function initData():void
		{
			updateAlldata();
			upZongZhanli();
			
			if (m_gkcontext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_JUNTUAN))
			{
				showCorpsIcon();
			}
			
			if (m_gkcontext.m_attrBufferMgr.bufferList.length)
			{
				showBufferIcon();
			}
		}
		
		private function onClick(event:MouseEvent):void
		{
			if (m_gkcontext.m_newHandMgr.isVisible())
			{
				m_gkcontext.m_newHandMgr.promptOver();
			}
			
			this.m_gkcontext.m_jiuguanMgr.loadConfig();
			if (m_gkcontext.m_UIMgr.isFormVisible(UIFormID.UIXingMai) == true)
			{
				m_gkcontext.m_UIMgr.exitForm(UIFormID.UIXingMai);
			}
			else
			{
				m_gkcontext.m_UIMgr.showFormWidthProgress(UIFormID.UIXingMai);
			}
		}
		
		private function onSpeakerBtnClick(event:MouseEvent):void
		{
			//开关声音
			if (m_gkcontext.m_sysOptions.isSet(SysOptions.COMMONSET_CLIENT_LDSSound))
			{
				m_gkcontext.m_sysOptions.clearAndSend(SysOptions.COMMONSET_CLIENT_LDSSound);
				
				if (m_gkcontext.m_mapInfo.m_sceneMusic.length)
				{
					this.m_gkcontext.m_context.m_soundMgr.play(m_gkcontext.m_mapInfo.m_sceneMusic, EntityCValue.FXDft, 0.0, int.MAX_VALUE);
				}
				m_speakerBtn.setSkinButton1Image("uiHero.Speaker");
			}
			else
			{
				m_gkcontext.m_sysOptions.setAndSend(SysOptions.COMMONSET_CLIENT_LDSSound);
				
				this.m_gkcontext.m_context.m_soundMgr.stopAll();
				m_speakerBtn.setSkinButton1Image("commoncontrol/panel/speaker_forbid.png");
			}
		}
		
		private function onChargeBtnClick(event:MouseEvent):void
		{
			m_gkcontext.m_context.m_platformMgr.openRechargeWeb();
		}
		
		//显示充值小界面:临时添加
		public function showRecharge():void
		{
			if (m_uiInput == null)
			{
				m_uiInput = new UIInput(m_gkcontext);
				m_gkcontext.m_UIMgr.addForm(m_uiInput);
			}
			m_uiInput.show();
		}
		
		public function updateHeroName():void
		{
			if (m_gkcontext.playerMain)
			{
				m_nameLabel.text = m_gkcontext.playerMain.name;
			}
		}
		
		public function getButtonPosInScreen(type:uint):Point
		{
			var ret:Point;
			
			if (SysNewFeatures.NFT_XINGMAI == type)
			{
				ret = m_jianghun.localToScreen();
			}
			else if (SysNewFeatures.NFT_GODLYWEAPON == type && m_godlyWeapon)
			{
				ret = m_godlyWeapon.localToScreen(new Point(30, -20));
			}
			
			return ret;
		}
		
		//显示新手引导
		public function showNewHand():void
		{
			if (m_gkcontext.m_newHandMgr.isVisible())
			{
				if (SysNewFeatures.NFT_XINGMAI == m_gkcontext.m_sysnewfeatures.m_nft)
				{
					m_gkcontext.m_newHandMgr.setFocusFrame(-12, -12, 60, 60, 1);
					m_gkcontext.m_newHandMgr.prompt(false, 40, 40, "点击打开觉醒界面。", m_jianghun);
				}
				else if (SysNewFeatures.NFT_GODLYWEAPON == m_gkcontext.m_sysnewfeatures.m_nft)
				{
					m_gkcontext.m_newHandMgr.setFocusFrame(-5, -5, 141, 40, 1);
					m_gkcontext.m_newHandMgr.prompt(false, 130, 40, "点击打开神兵界面。", m_godlyWeapon);
				}
			}
		}
		
		public function showTaskAni():void
		{
			m_aniInScreen.showTaskSubmitAni();
		}
		
		public function toggleAutoWay(bshow:Boolean):void
		{
			m_aniInScreen.toggleAutoWay(bshow);
		}
		
		private function onMouseRollOverBtn(event:MouseEvent):void
		{
			var btn:PushButton = event.currentTarget as PushButton;
			var pt:Point = btn.localToScreen(new Point(btn.width, 0));
			var str:String;
			switch (btn.tag)
			{
				case 10: 
					str = "令牌领取、购买，Vip3免费领取20令牌";
					break;
				case 11: 
					str = "Vip积分 " + m_gkcontext.m_beingProp.m_vipscore;
					break;
				default: 
					str = "";
			}
			
			m_gkcontext.m_uiTip.hintCondense(pt, str);
		}
		
		private function onClickGetLingpaiBtn(event:MouseEvent):void
		{
			buyLingpai();
		}
		
		//购买令牌
		public function buyLingpai():void
		{
			var cmd:stReqFreeLingPaiInfoCmd = new stReqFreeLingPaiInfoCmd();
			m_gkcontext.sendMsg(cmd);
		}
		
		//显示“军团”Icon
		public function showCorpsIcon():void
		{
			if (m_corpsIcon == null)
			{
				m_corpsIcon = new Panel(this, 28, 125);
				m_corpsIcon.setPanelImageSkin("commoncontrol/panel/herobottom/corpsicon.png");
				m_corpsIcon.addEventListener(MouseEvent.ROLL_OUT, m_gkcontext.hideTipOnMouseOut);
				m_corpsIcon.addEventListener(MouseEvent.ROLL_OVER, onCorpsIconMouseOver);
			}
			
			updateIconPos();
		}
		
		private function onCorpsIconMouseOver(e:MouseEvent):void
		{
			var str:String;
			UtilHtml.beginCompose();
			str = UtilHtml.formatBold("军团科技");
			UtilHtml.add(str, UtilColor.BLUE, 14);
			UtilHtml.breakline();
			
			var kejiList:Array = m_gkcontext.m_corpsMgr.m_kejiLearnd;
			var w:int;
			if (kejiList && kejiList.length)
			{
				UtilHtml.add("加成效果：", UtilColor.WHITE_Yellow, 12);
				
				var item:KejiLearnedItem;
				var kejiInfo:KejiItemInfo;
				for each (item in kejiList)
				{
					kejiInfo = m_gkcontext.m_corpsMgr.getKejiInfoByType(item.m_type);
					if (kejiInfo)
					{
						UtilHtml.breakline();
						UtilHtml.add(kejiInfo.m_name, 0xD78E03, 12);
						UtilHtml.add("  +" + item.m_value, 0x23C911, 12);						
					}
				}
				w = 170;
				
			}
			else
			{
				if (m_gkcontext.m_corpsMgr.hasCorps == false)
				{
					//无团
					str = "加入军团后才能学习军团科技， 军团科技大大增强部队属性";
				}
				else
				{
					str = "尚未学习军团科技。可通过【军团】界面中的【研究中心】学习";
				}
				UtilHtml.add(str, UtilColor.WHITE_Yellow, 12);
				w = 242;
			}
			
			var pt:Point = m_corpsIcon.localToScreen(new Point(28, 0));
			m_gkcontext.m_uiTip.hintHtiml(pt.x, pt.y, UtilHtml.getComposedContent(), w);
		
		}
		
		//显示“坐骑”Icon
		public function showMountIcon():void
		{
			if (m_mountsIcon == null)
			{
				m_mountsIcon = new Panel(this, 62, 125);
				m_mountsIcon.setPanelImageSkin("commoncontrol/panel/herobottom/mountsicon.png");
				m_mountsIcon.addEventListener(MouseEvent.ROLL_OUT, m_gkcontext.hideTipOnMouseOut);
				m_mountsIcon.addEventListener(MouseEvent.ROLL_OVER, onMountsIconMouseOver);
			}
			else
			{
				if(!this.contains(m_mountsIcon))
				{
					this.addChild(m_mountsIcon);
				}
			}
			
			updateIconPos();
		}
		
		// 隐藏坐骑图标
		public function hideMountIcon():void
		{
			if (m_mountsIcon && this.contains(m_mountsIcon))
			{
				this.removeChild(m_mountsIcon);
			}
		}
		
		private function onMountsIconMouseOver(e:MouseEvent):void
		{
			// 坐骑基本属性有才显示提示
			if((m_gkcontext.playerMain.horseSys as MountsSys).mountsAttr.baseAttr)
			{
				var pt:Point = m_mountsIcon.localToScreen(new Point(28, 0));
				(m_gkcontext.m_mountsShareData as MountsShareData).m_mountsTipData.reset();
				(m_gkcontext.m_mountsShareData as MountsShareData).m_mountsTipData.m_tipsType = 1;
				(m_gkcontext.m_mountsShareData as MountsShareData).m_mountsTipData.m_mountsDataSys = m_gkcontext.playerMain.horseSys as MountsSys;
				
				m_gkcontext.m_uiTip.hintMountsInfo(pt, (m_gkcontext.m_mountsShareData as MountsShareData).m_mountsTipData);
			}
		}
		
		//显示“神兵”Icon
		public function showGodlyWeapon():void
		{
			m_gkcontext.m_godlyWeaponMgr.parseXml();
			
			if (null == m_godlyWeapon)
			{
				m_godlyWeapon = new Godlyweapon(m_gkcontext, this, 100, 125);
			}
			
			updateIconPos();
		}
		
		//军团、坐骑、神兵Icon，显示位置调整
		private function updateIconPos():void
		{
			var left:int = 25;
			var top:int = 125;
			var interval:int = 35;
			
			if (m_corpsIcon)
			{
				m_corpsIcon.setPos(left, top);
				left += interval;
			}
			
			if (m_mountsIcon)
			{
				m_mountsIcon.setPos(left, top);
				left += interval;
			}
			
			if (m_godlyWeapon)
			{
				m_godlyWeapon.setPos(left, top);
				left += interval;
				if (false == m_godlyWeapon.bSmallIcon)
				{
					left += 100;
				}
			}
			
			if (m_bufferIconPanel)
			{
				m_bufferIconPanel.setPos(left, top + 2);
				left += interval;
			}
		}
		
		//打开Vip特权界面
		private function onVipBtnClick(event:MouseEvent):void
		{
			if (m_gkcontext.m_UIMgr.isFormVisible(UIFormID.UIVipPrivilege))
			{
				m_gkcontext.m_UIMgr.exitForm(UIFormID.UIVipPrivilege);
			}
			else
			{
				m_gkcontext.m_vipPrivilegeMgr.showVipPrivilegeForm();
			}
		}
		
		//显示Buffer图标
		public function showBufferIcon():void
		{
			if (m_bufferIconPanel == null)
			{
				m_bufferIconPanel = new BufferIconPanel(m_gkcontext, this, 30, 164);
				updateIconPos();
			}
			
			m_bufferIconPanel.initData();
		}
		
		//显示Buffer图标
		public function addBufferIcon(type:int, bufferid:uint):void
		{
			if (m_bufferIconPanel == null)
			{
				m_bufferIconPanel = new BufferIconPanel(m_gkcontext, this, 30, 164);
				updateIconPos();
			}
			
			m_bufferIconPanel.addBufferIcon(type, bufferid);
		}
		
		//隐藏buffer图标
		public function removeBufferIcon(bufferid:uint):void
		{
			if (m_bufferIconPanel)
			{
				m_bufferIconPanel.removeBufferIcon(bufferid);
			}
		}
		
		//更新buffer图标
		public function updateBufferIcon(type:int, bufferid:uint):void
		{
			if (m_bufferIconPanel)
			{
				m_bufferIconPanel.updateBufferIcon(type, bufferid);
			}
		}
		
		public function updateBufferEnabled(type:int, bEnabled:Boolean):void
		{
			if (m_bufferIconPanel)
			{
				m_bufferIconPanel.updateBufferEnabled(type, bEnabled);
			}
		}
		
		public function updateLeftTimes(bufferid:uint, value:uint):void
		{
			if (m_bufferIconPanel)
			{
				m_bufferIconPanel.updateLeftTimes(bufferid, value);
			}
		}
		
		//更新神兵Icon
		public function updateGodlyWeapon(id:uint, type:uint):void
		{
			if (m_godlyWeapon)
			{
				m_godlyWeapon.updateGodlyWeapon(id, type);
			}
		}
		
		//神兵Icon闪烁提示更新
		public function updateGodlyIconFlashing(bflash:Boolean):void
		{
			if (m_godlyWeapon)
			{
				m_godlyWeapon.updateGodlyIconFlashing(bflash);
			}
		}
	}
}