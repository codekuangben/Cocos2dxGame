package app.login.uiheroselect
{	
	import com.ani.AniPropertys;
	import com.bit101.components.Ani;
	import com.bit101.components.ButtonImageText;
	import com.bit101.components.ButtonRadio;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.dgrigg.image.CommonImageManager;
	import com.gskinner.motion.easing.Linear;
	import com.pblabs.engine.resource.SWFResource;
	import ui.FormSimple;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	/*
	import art.uiheroselectnew.bg;
	import art.uiheroselectnew.bgtop;
	import art.uiheroselectnew.btn;
	import art.uiheroselectnew.btnbg;
	import art.uiheroselectnew.csfm;
	import art.uiheroselectnew.csjs;
	import art.uiheroselectnew.cslbl;
	import art.uiheroselectnew.csm;
	import art.uiheroselectnew.gsfm;
	import art.uiheroselectnew.gsjs;
	import art.uiheroselectnew.gslbl;
	import art.uiheroselectnew.gsm;
	import art.uiheroselectnew.mjfm;
	import art.uiheroselectnew.mjjs;
	import art.uiheroselectnew.mjlbl;
	import art.uiheroselectnew.mjm;
	import art.uiheroselectnew.touxiangkuang;
	import art.uiheroselectnew.wodesanguo;
	*/
	import common.event.UIEvent;
	
	
	import ui.player.PlayerResMgr;	
	import ui.IImageSWFHost;
	import ui.ImageSWFLoader;
	/**
	 * ...
	 * @author
	 * @brief 角色选择新的界面
	 */
	public class UIHeroSelectNew extends FormSimple implements IImageSWFHost
	{
		/*
		art.uiheroselectnew.btnbg;
		art.uiheroselectnew.btn;
		art.uiheroselectnew.cslbl;
		art.uiheroselectnew.csm;
		art.uiheroselectnew.csfm;
		art.uiheroselectnew.csjs;
		art.uiheroselectnew.gslbl;
		art.uiheroselectnew.gsm;
		art.uiheroselectnew.gsfm;
		art.uiheroselectnew.gsjs;
		art.uiheroselectnew.mjlbl;
		art.uiheroselectnew.mjm;
		art.uiheroselectnew.mjfm;
		art.uiheroselectnew.mjjs;
		art.uiheroselectnew.bg;
		art.uiheroselectnew.bgtop;
		art.uiheroselectnew.wodesanguo;
		art.uiheroselectnew.touxiangkuang;
		*/
		private var m_swfLoader:ImageSWFLoader;
		protected var m_pnlBg:Panel;
		protected var m_pnlBgTop:Panel;
		protected var m_pnlBgTopParent:Panel;
		protected var m_pnlBgTopF:Panel;
		protected var m_pnlBgTopS:Panel;
		protected var m_pnlMask:Panel;
		
		protected var m_cont:Component;	// 除了底图,所有控件的容器
		protected var m_pnlLeft:Component;	// 左边面板
		
		protected var m_lblM:Panel;		// 猛将
		protected var m_lblG:Panel;		// 弓手
		protected var m_lblC:Panel;		// 策士
		
		protected var m_pnlm:Panel;		// 男
		protected var m_pnlw:Panel;		// 女

		protected var m_pnlmm:Panel;		// 男猛将
		protected var m_pnlwm:Panel;		// 女猛将
		protected var m_btnmm:ButtonImageText;	// 男猛将按钮
		protected var m_btnwm:ButtonImageText;	// 女猛将按钮
		
		protected var m_pnlmg:Panel;		// 男弓手
		protected var m_pnlwg:Panel;		// 女弓手
		protected var m_btnmg:ButtonImageText;	// 男弓手按钮
		protected var m_btnwg:ButtonImageText;	// 女弓手按钮
		
		protected var m_pnlmc:Panel;		// 男策士
		protected var m_pnlwc:Panel;		// 女策士
		protected var m_btnmc:ButtonImageText;	// 男策士按钮
		protected var m_btnwc:ButtonImageText;	// 女策士按钮
		
		protected var m_pnlImage:Panel;	// 人物全身像
		
		protected var m_btnPnl:Panel;
		protected var m_btn:PushButton; 	// 进入游戏
		
		protected var m_pnlLsg:Panel;		// 乱三国
		protected var m_pnlJS:Panel;		// 介绍 
		
		protected var m_aniProp:AniPropertys;
		
		protected var m_career:uint;
		protected var m_sex:uint;
		protected var m_minor:uint;
		
		protected var m_texAni:AniPropertys;		// 纹理动画
		//protected var m_maskAni:Bitmap;			// 动画 mask
		protected var m_animalAniVec:Vector.<AniPropertys>;	// 动物移动
		protected var m_animalEffVec:Vector.<Ani>;				// 动物动画
		
		protected var m_timeID:uint;				// 定时器 ID
		protected var m_aniBtn:Ani;				// 按钮动画
		protected var m_aniHead:Ani;				//头像点击按下动画
		
		protected var m_timeList:Vector.<uint>;		// 定时器
		protected var m_ontick:uint;					// 时钟定时器
		protected var m_lblDesc:Label;					// 游戏描述
		
		// 18岁以上和18岁以下选项，默认选中18岁以上
		protected var m_radioBtnF:ButtonRadio;		// 第一个单选按钮
		protected var m_lblNameF:Label;			// 名字1
		protected var m_radioBtnS:ButtonRadio;		// 第二个单选按钮
		protected var m_lblNameS:Label;			// 名字2
		
		

		public function UIHeroSelectNew()
		{
			
			
		}
		
		override public function onReady():void
		{
			super.onReady();
			this.setSize(1388, 657);
			
			m_swfLoader = new ImageSWFLoader(m_context, this);
			m_swfLoader.setParam(false);
			m_swfLoader.load("module/uiheroselectnew.swf");			
		}
		
		public function createImage(swfRes:SWFResource):void		
		{
			
			//setFade();
			
			m_pnlBgTop = new Panel(this);
			//m_maskAni = new Bitmap();
			//m_pnlBgTop.addChild(m_maskAni);
			//m_maskAni.bitmapData = new bgtop();
			//m_pnlBgTop.mask = m_maskAni;
			//m_pnlBgTop.cacheAsBitmap = true;
			
			m_pnlBgTopParent = new Panel(m_pnlBgTop);
			m_pnlBgTopF = new Panel(m_pnlBgTopParent);
			m_pnlBgTopF.addEventListener(UIEvent.IMAGELOADED, onPnlLoadedSky);
			m_pnlBgTopF.setPanelImageSkinBySWF(swfRes, "uiheroselectnew.bgtop");
			//m_pnlBgTopF.setPanelImageSkin("commoncontrol/panel/sky.png");
			m_pnlBgTopS = new Panel(m_pnlBgTopParent, 1400);
			m_pnlBgTopS.setPanelImageSkinBySWF(swfRes, "uiheroselectnew.bgtop");
			//m_pnlBgTopS.setPanelImageSkin("commoncontrol/panel/sky.png");
			
			// 纹理动画
			m_texAni = new AniPropertys();
			m_texAni.sprite = m_pnlBgTopParent;
			m_texAni.duration = 50;
			m_texAni.ease = Linear.easeNone;
			m_texAni.resetValues({x:-1400});
			m_texAni.onEnd = onAniEnd;
			m_texAni.begin();
			
			m_pnlBg = new Panel(this, 0, 80);
			m_pnlBg.setPanelImageSkinBySWF(swfRes, "uiheroselectnew.bg");
			
			m_animalAniVec = new Vector.<AniPropertys>(2, true);
			m_animalEffVec = new Vector.<Ani>(2, true); 
			var idx:uint = 0;
			var animalEff:Ani;
			var animalAni:AniPropertys;
			while(idx < 2)
			{
				// 动画
				animalEff = new Ani(m_context);
				m_animalEffVec[idx] = animalEff;
				animalEff.duration = 1;
				animalEff.repeatCount = uint.MAX_VALUE;
				animalEff.setImageAni("ejxianhe.swf");
				animalEff.x = 20;
				if(0 == idx)	
				{
					animalEff.y = 70;
				}
				else
				{
					animalEff.y = 120;
					animalEff.visible = false;
				}
				animalEff.centerPlay = true;
				animalEff.mouseEnabled = false;
				animalEff.begin();
				this.addChild(animalEff);
				
				// 动物动画
				animalAni = new AniPropertys();
				m_animalAniVec[idx] = animalAni;
				
				animalAni.sprite = m_animalEffVec[idx];
				animalAni.duration = 30;
				animalAni.ease = Linear.easeNone;
				animalAni.resetValues({x:1380});
				if(0 == idx)
				{
					animalAni.onEnd = onAnimalAniEnd;
					animalAni.begin();
				}
				else
				{
					animalAni.end();
					animalAni.onEnd = onAnimalAniEndS;
					m_timeID = setInterval(startAniS, 7 * 1000);					
				}
				
				++idx;
			}
			
			// 两个定时器
			m_timeList = new Vector.<uint>(2, true);
			
			m_cont = new Component(this);
			m_pnlLeft = new Component(m_cont, 152, 198);
			
			// 3 个标签
			m_lblM = new Panel(m_pnlLeft, 0, 14);
			m_lblM.setPanelImageSkinBySWF(swfRes, "uiheroselectnew.mjlbl");
			
			m_lblG = new Panel(m_pnlLeft, 0, 137);
			m_lblG.setPanelImageSkinBySWF(swfRes, "uiheroselectnew.gslbl");
			
			m_lblC = new Panel(m_pnlLeft, 0, 264);
			m_lblC.setPanelImageSkinBySWF(swfRes, "uiheroselectnew.cslbl");
			
			// 第一行按钮
			m_pnlmm = new Panel(m_pnlLeft, 67, 0);
			m_pnlmm.setPanelImageSkinBySWF(swfRes, "uiheroselectnew.touxiangkuang");
			
			m_btnmm = new ButtonImageText(m_pnlLeft, 67, -13, onBtnClkmm);
			m_btnmm.setSize(100, 44);
			m_btnmm.setSkinButton1Image(m_context.m_playerResMgr.roundHeadPathName(PlayerResMgr.JOB_MENGJIANG, PlayerResMgr.GENDER_male));
			
			m_pnlwm = new Panel(m_pnlLeft, 184, 0);
			m_pnlwm.setPanelImageSkinBySWF(swfRes, "uiheroselectnew.touxiangkuang");
			
			m_btnwm = new ButtonImageText(m_pnlLeft, 184, -13, onBtnClkwm);
			m_btnwm.setSize(100, 44);
			m_btnwm.setSkinButton1Image(m_context.m_playerResMgr.roundHeadPathName(PlayerResMgr.JOB_MENGJIANG, PlayerResMgr.GENDER_female));
			
			// 第二行按钮
			m_pnlmg = new Panel(m_pnlLeft, 67, 126);
			m_pnlmg.setPanelImageSkinBySWF(swfRes, "uiheroselectnew.touxiangkuang");
			
			m_btnmg = new ButtonImageText(m_pnlLeft, 67, 113, onBtnClkmg);
			m_btnmg.setSize(100, 44);
			m_btnmg.setSkinButton1Image(m_context.m_playerResMgr.roundHeadPathName(PlayerResMgr.JOB_GONGJIANG, PlayerResMgr.GENDER_male));
			
			m_pnlwg = new Panel(m_pnlLeft, 184, 126);
			m_pnlwg.setPanelImageSkinBySWF(swfRes, "uiheroselectnew.touxiangkuang");
			
			m_btnwg = new ButtonImageText(m_pnlLeft, 184, 113, onBtnClkwg);
			m_btnwg.setSize(100, 44);
			m_btnwg.setSkinButton1Image(m_context.m_playerResMgr.roundHeadPathName(PlayerResMgr.JOB_GONGJIANG, PlayerResMgr.GENDER_female));
			
			// 第三行按钮
			m_pnlmc = new Panel(m_pnlLeft, 67, 252);
			m_pnlmc.setPanelImageSkinBySWF(swfRes, "uiheroselectnew.touxiangkuang");
			
			m_btnmc = new ButtonImageText(m_pnlLeft, 67, 239, onBtnClkmc);
			m_btnmc.setSize(100, 44);
			m_btnmc.setSkinButton1Image(m_context.m_playerResMgr.roundHeadPathName(PlayerResMgr.JOB_JUNSHI, PlayerResMgr.GENDER_male));
			
			m_pnlwc = new Panel(m_pnlLeft, 184, 252);
			m_pnlwc.setPanelImageSkinBySWF(swfRes, "uiheroselectnew.touxiangkuang");
			
			m_btnwc = new ButtonImageText(m_pnlLeft, 184, 239, onBtnClkwc);
			m_btnwc.setSize(100, 44);
			m_btnwc.setSkinButton1Image(m_context.m_playerResMgr.roundHeadPathName(PlayerResMgr.JOB_JUNSHI, PlayerResMgr.GENDER_female));
			
			// 全身像
			m_pnlImage = new Panel(m_cont, 807, 0);
			m_pnlImage.setPos(500, 0);
			
			// 我的三国
			m_pnlLsg = new Panel(m_cont, 210, 40);
			m_pnlLsg.setPanelImageSkinBySWF(swfRes, "uiheroselectnew.wodesanguo");
			
			// 直接介绍
			m_pnlJS = new Panel(m_cont, 621, 82);
			
			// 进入游戏按钮
			m_btnPnl = new Panel(m_cont, 574, 584);
			m_btnPnl.setPanelImageSkinBySWF(swfRes, "uiheroselectnew.btnbg");
			m_btn = new PushButton(m_cont, 574, 584, onBtnClk);
			m_btn.setSkinButton1ImageBySWF(swfRes, "uiheroselectnew.btn");
			
			// 动画
			m_aniProp = new AniPropertys();
			m_aniProp.sprite = m_pnlImage;
			m_aniProp.duration = 0.2;
			m_aniProp.ease = Linear.easeNone;
			m_aniProp.resetValues({alpha:1});
			//showOnAllImageLoaded();
			
			// 按钮动画
			m_aniBtn = new Ani(m_context);
			m_aniBtn.duration = 2;
			m_aniBtn.repeatCount = uint.MAX_VALUE;	// 无限循环播放
			
			m_aniBtn.setImageAni("ejjianjiaosejianru.swf");
			m_aniBtn.centerPlay = true;
			m_aniBtn.mouseEnabled = false;
			
			m_aniBtn.x = 688;
			m_aniBtn.y = 613;
			
			m_cont.addChild(m_aniBtn);
			m_aniBtn.begin();
			
			// 点击动画
			m_aniHead = new Ani(m_context);
			m_aniHead.duration = 2;
			m_aniHead.repeatCount = uint.MAX_VALUE;	// 无限循环播放
			
			m_aniHead.setImageAni("ejjianjiaosexuanzhong.swf");
			m_aniHead.centerPlay = true;
			m_aniHead.mouseEnabled = false;
			
			m_aniHead.x = 0;
			m_aniHead.y = 0;
			
			m_ontick = setInterval(onTick, 20);
			
			//m_cont.addChild(m_aniHead);
			//m_aniHead.begin();
			
			// 默认选择一个,这一行一定要放在最后面,防止有某些变量没有初始化
			onBtnClkwm(null);
			
			m_radioBtnF = new ButtonRadio(m_cont, 220, 580, onBtnClkF);
			m_radioBtnF.setPanelImageSkin("commoncontrol/button/bb_buttonradio.swf");
			m_radioBtnF.selected = true;
			m_lblNameF = new Label(m_cont, 240, 580, "18岁以上");
			m_radioBtnS = new ButtonRadio(m_cont, 220, 610, onBtnClkS);
			m_radioBtnS.setPanelImageSkin("commoncontrol/button/bb_buttonradio.swf");
			m_lblNameS = new Label(m_cont, 240, 610, "18岁以下");
			
			m_lblDesc = new Label(m_cont, 50, 650, "抵制不良游戏，拒绝盗版游戏。注意自我保护，谨防受骗上当。适度游戏益脑，沉迷游戏伤身。合理安排时间，享受健康生活。");
			
			var send:stLoadSelectCharacterUIOverCmd = new stLoadSelectCharacterUIOverCmd();
			m_context.sendMsg(send);
			//m_context.m_UIMgr.loadForm(UIFormID.UICGIntro);
			if (m_context.m_preLoad.loadNone)
			{
				m_context.m_preLoad.load();
			}
		}

		override public function onShow():void
		{
			onStageReSize();
		}
	
		override public function dispose():void 
		{	
			// 释放动画
			if(m_texAni)
			{
				m_texAni.end();
				m_texAni = null;
			}
			
			// 释放 mask
			//m_maskAni.bitmapData.dispose();
			
			var idx:uint = 0;
			while(idx < 2)
			{
				if(m_animalAniVec[idx])
				{
					m_animalAniVec[idx].end();
					m_animalAniVec[idx] = null;
				}
				
				++idx;
			}
			
			if(m_timeID)
			{
				clearInterval(m_timeID);
				m_timeID = 0;
			}
			
			if(m_timeList[0])
			{
				clearInterval(m_timeList[0]);
			}
			
			if(m_timeList[1])
			{
				clearInterval(m_timeList[1]);
			}
			
			if(m_ontick)
			{
				clearInterval(m_ontick);
			}
			
			// 推出角色选择界面
			m_context.m_binHeroSel = false;
			m_swfLoader.dispose();
			super.dispose();
				
		}
		
		override public function onStageReSize():void
		{
			// 窗口居中
			this.setPos((this.m_context.m_config.m_curWidth - this.width)/2, (this.m_context.m_config.m_curHeight - this.height)/2);
			// 至少能看到最下面的按钮
			if(this.m_context.m_config.m_curHeight < this.height)
			{
				this.setPos((this.m_context.m_config.m_curWidth - this.width)/2, this.m_context.m_config.m_curHeight - this.height);
			}
			else
			{
				this.setPos((this.m_context.m_config.m_curWidth - this.width)/2, (this.m_context.m_config.m_curHeight - this.height)/2);
			}
		}
		
		private function onBtnClk(event:MouseEvent):void
		{
			// 立刻显示加载框
			m_context.progLoading.reset();
			m_context.progLoading.show();
			// 退出
			if(m_context.m_fCreateHero != null)
			{
				m_context.m_fCreateHero(m_career, m_sex, m_minor);
				exit();
			}
			trace("---------------m_minor=" + m_minor);
		}
		
		public function onBtnClkmm(e:MouseEvent):void
		{
			//m_pnlImage.setPanelImageSkinBySWF(m_swfLoader.resource, "uiheroselectnew.mjm");
			m_pnlImage.setPanelImageSkin("module/heroselect/mjm.png");
			m_pnlJS.setPanelImageSkinBySWF(m_swfLoader.resource, "uiheroselectnew.mjjs");
			m_pnlImage.setPos(833, 32);
			
			m_career = PlayerResMgr.JOB_MENGJIANG;
			m_sex = PlayerResMgr.GENDER_male;
			
			m_pnlImage.alpha = 0;
			m_aniProp.begin();
			
			// 设置选中角色
			if(!m_pnlLeft.contains(m_aniHead))
			{
				m_pnlLeft.addChild(m_aniHead);
				m_aniHead.begin();
			}
			
			m_aniHead.x = 67 + 60;
			m_aniHead.y = -13 + 65;
			
			// 流光
			m_pnlImage.setLiuguangParam(3, 10, -2, 2, -200, 1500);
			m_pnlImage.beginLiuguang();
			
			// 介绍文字动画
			m_pnlJS.setScrollRectAniParam(0, m_pnlJS._height, 100);
			m_pnlJS.beginScrollRectAni();
			
			m_context.m_playerResID = "uiheroselectnew.mjm";
		}
		
		public function onBtnClkwm(e:MouseEvent):void
		{
			//m_pnlImage.setPanelImageSkinBySWF(m_swfLoader.resource, "uiheroselectnew.mjfm");
			m_pnlImage.setPanelImageSkin("module/heroselect/mjfm.png");
			m_pnlJS.setPanelImageSkinBySWF(m_swfLoader.resource, "uiheroselectnew.mjjs");
			m_pnlImage.setPos(896, 164);
			
			m_career = PlayerResMgr.JOB_MENGJIANG;
			m_sex = PlayerResMgr.GENDER_female;
			
			m_pnlImage.alpha = 0;
			m_aniProp.begin();
			
			// 设置选中角色
			if(!m_pnlLeft.contains(m_aniHead))
			{
				m_pnlLeft.addChild(m_aniHead);
				m_aniHead.begin();
			}
			
			m_aniHead.x = 184 + 60;
			m_aniHead.y = -13 + 65;
			
			// 流光
			m_pnlImage.setLiuguangParam(3, 10, -2, 2, 0, 1000);
			m_pnlImage.beginLiuguang();
			
			// 介绍文字动画
			m_pnlJS.setScrollRectAniParam(0, m_pnlJS._height, 100);
			m_pnlJS.beginScrollRectAni();
			
			m_context.m_playerResID = "uiheroselectnew.mjfm";
		}
		
		public function onBtnClkmg(e:MouseEvent):void
		{
			//m_pnlImage.setPanelImageSkinBySWF(m_swfLoader.resource, "uiheroselectnew.gsm");
			m_pnlImage.setPanelImageSkin("module/heroselect/gsm.png");
			m_pnlJS.setPanelImageSkinBySWF(m_swfLoader.resource, "uiheroselectnew.gsjs");
			m_pnlImage.setPos(824, 31);
			
			m_career = PlayerResMgr.JOB_GONGJIANG;
			m_sex = PlayerResMgr.GENDER_male;
			
			m_pnlImage.alpha = 0;
			m_aniProp.begin();
			
			// 设置选中角色
			if(!m_pnlLeft.contains(m_aniHead))
			{
				m_pnlLeft.addChild(m_aniHead);
				m_aniHead.begin();
			}
			
			m_aniHead.x = 67 + 60;
			m_aniHead.y = 113 + 65;
			
			// 流光
			m_pnlImage.setLiuguangParam(3, 10, -2, 2, 0, 1150);
			m_pnlImage.beginLiuguang();
			
			// 介绍文字动画
			m_pnlJS.setScrollRectAniParam(0, m_pnlJS._height, 100);
			m_pnlJS.beginScrollRectAni();
			
			m_context.m_playerResID = "uiheroselectnew.gsm";
		}
		
		public function onBtnClkwg(e:MouseEvent):void
		{
			//m_pnlImage.setPanelImageSkinBySWF(m_swfLoader.resource, "uiheroselectnew.gsfm");
			m_pnlImage.setPanelImageSkin("module/heroselect/gsfm.png");
			m_pnlJS.setPanelImageSkinBySWF(m_swfLoader.resource, "uiheroselectnew.gsjs");
			m_pnlImage.setPos(826, 26);
			
			m_career = PlayerResMgr.JOB_GONGJIANG;
			m_sex = PlayerResMgr.GENDER_female;
			
			m_pnlImage.alpha = 0;
			m_aniProp.begin();
			
			// 设置选中角色
			if(!m_pnlLeft.contains(m_aniHead))
			{
				m_pnlLeft.addChild(m_aniHead);
				m_aniHead.begin();
			}
			
			m_aniHead.x = 184 + 60;
			m_aniHead.y = 113 + 65;
			
			// 流光
			m_pnlImage.setLiuguangParam(3, 10, -2, 2, 0, 1100);
			m_pnlImage.beginLiuguang();
			
			// 介绍文字动画
			m_pnlJS.setScrollRectAniParam(0, m_pnlJS._height, 100);
			m_pnlJS.beginScrollRectAni();
			
			m_context.m_playerResID = "uiheroselectnew.gsfm";
		}
		
		public function onBtnClkmc(e:MouseEvent):void
		{
			//m_pnlImage.setPanelImageSkinBySWF(m_swfLoader.resource, "uiheroselectnew.csm");
			m_pnlImage.setPanelImageSkin("module/heroselect/csm.png");
			m_pnlJS.setPanelImageSkinBySWF(m_swfLoader.resource, "uiheroselectnew.csjs");
			m_pnlImage.setPos(857, -30);
			
			m_career = PlayerResMgr.JOB_JUNSHI;
			m_sex = PlayerResMgr.GENDER_male;
			
			m_pnlImage.alpha = 0;
			m_aniProp.begin();
			
			// 设置选中角色
			if(!m_pnlLeft.contains(m_aniHead))
			{
				m_pnlLeft.addChild(m_aniHead);
				m_aniHead.begin();
			}
			
			m_aniHead.x = 67 + 60;
			m_aniHead.y = 239 + 65;
			
			// 流光
			m_pnlImage.setLiuguangParam(3, 10, -2, 2, 0, 1200);
			m_pnlImage.beginLiuguang();
			
			// 介绍文字动画
			m_pnlJS.setScrollRectAniParam(0, m_pnlJS._height, 100);
			m_pnlJS.beginScrollRectAni();
			
			m_context.m_playerResID = "uiheroselectnew.csm";
		}
		
		public function onBtnClkwc(e:MouseEvent):void
		{
			//m_pnlImage.setPanelImageSkinBySWF(m_swfLoader.resource, "uiheroselectnew.csfm");
			m_pnlImage.setPanelImageSkin("module/heroselect/csfm.png");
			m_pnlJS.setPanelImageSkinBySWF(m_swfLoader.resource, "uiheroselectnew.csjs");
			m_pnlImage.setPos(827, 33);
			
			m_career = PlayerResMgr.JOB_JUNSHI;
			m_sex = PlayerResMgr.GENDER_female;
			
			m_pnlImage.alpha = 0;
			m_aniProp.begin();
			
			// 设置选中角色
			if(!m_pnlLeft.contains(m_aniHead))
			{
				m_pnlLeft.addChild(m_aniHead);
				m_aniHead.begin();
			}
			
			m_aniHead.x = 184 + 60;
			m_aniHead.y = 239 + 65;
			
			// 流光
			m_pnlImage.setLiuguangParam(3, 10, -2, 2, -100, 1280);
			m_pnlImage.beginLiuguang();
			
			// 介绍文字动画
			m_pnlJS.setScrollRectAniParam(0, m_pnlJS._height, 100);
			m_pnlJS.beginScrollRectAni();
			
			m_context.m_playerResID = "uiheroselectnew.csfm";
		}
		
		private function onAniEnd():void
		{
			// 结束后循环播放动画
			m_pnlBgTopParent.setPos(0, 0);
			m_texAni.begin();
		}
		
		// 动画结束,从头再来
		private function onAnimalAniEnd():void
		{
			// 延迟 5 秒再运行
			//m_animalEffVec[0].x = 20;
			//m_animalAniVec[0].begin();
			
			m_animalEffVec[0].visible = false;
			m_timeList[0] = setInterval(timeEnd, 5 * 1000);
		}
		
		// 动画结束,从头再来,第二个仙鹤
		private function onAnimalAniEndS():void
		{
			// 延迟 5 秒再运行
			//m_animalEffVec[1].x = 20;
			//m_animalAniVec[1].begin();
			
			m_animalEffVec[1].visible = false;
			m_timeList[1] = setInterval(timeEndS, 5 * 1000);
		}
		
		// 启动第二个动画
		protected function startAniS():void
		{
			m_animalEffVec[1].visible = true;
			m_animalAniVec[1].begin();
			clearInterval(m_timeID);
			m_timeID = 0;			
		}
		
		private function timeEnd():void
		{
			clearInterval(m_timeList[0]);
			m_animalEffVec[0].visible = true;
			m_animalEffVec[0].x = 20;
			m_animalAniVec[0].begin();
		}
		
		private function timeEndS():void
		{
			clearInterval(m_timeList[1]);
			m_animalEffVec[1].visible = true;
			m_animalEffVec[1].x = 20;
			m_animalAniVec[1].begin();
		}
		
		private function onTick():void
		{
			var dety:Number;
			var a:uint = 30;
			var b:Number = 0.3;
			var rad:Number = (((m_animalEffVec[0].x /180) * Math.PI) * b) % (2 * Math.PI);
			// 70
			if(m_animalEffVec[0].visible)
			{
				dety = a * Math.sin(rad);
				m_animalEffVec[0].y = 70 + dety;
			}
			
			rad = (((m_animalEffVec[1].x /180) * Math.PI) * b) % (2 * Math.PI);
			// 120
			if(m_animalEffVec[1].visible)
			{
				dety = a * Math.sin(rad);
				m_animalEffVec[1].y = 120 + dety;
			}
			
			// 自动重复调用
			//m_ontick = setInterval(onTick, 200);
		}
		
		private function onBtnClkF(event:MouseEvent):void
		{
			if (m_radioBtnF.selected)
			{
				m_minor = 0;
			}
		}
		
		private function onBtnClkS(event:MouseEvent):void
		{
			if (m_radioBtnS.selected)
			{
				m_minor = 1;
			}
		}
		
		public function onPnlLoadedSky(event:UIEvent):void
		{
			m_pnlMask = new Panel(m_pnlBgTop);
			//m_pnlMask.setPanelImageSkin("commoncontrol/panel/sky.png");
			m_pnlMask.setPanelImageSkinBySWF(m_swfLoader.resource, "uiheroselectnew.bgtop");
			m_pnlBgTop.mask = m_pnlMask;
			m_pnlBgTop.cacheAsBitmap = true;
		}
	}
}