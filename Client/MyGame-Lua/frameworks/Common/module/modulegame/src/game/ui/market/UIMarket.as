package game.ui.market 
{
	import com.bit101.components.ButtonTabText;
	import com.bit101.components.pageturn.PageTurn;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.PushButton;
	import com.dgrigg.image.Image;
	import flash.geom.Point;
	import game.ui.market.module.common.YuanBaoPart;
	import game.ui.market.module.rongyu.RongyuPart;
	import game.ui.market.module.timeLimt.TimeLimitPart;
	import modulecommon.appcontrol.MonkeyAndValue;
	import modulecommon.scene.prop.BeingProp;
	import modulecommon.scene.prop.object.ZObjectDef;
	import modulecommon.scene.sysbtn.SysbtnMgr;
	import modulecommon.uiinterface.IUIMarket;

	import com.dgrigg.image.PanelImage;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import game.ui.market.module.common.CommonPart;
	import modulecommon.scene.market.stMarket;
	import modulecommon.ui.Form;
	import modulecommon.ui.FormStyleNine;
	import com.pblabs.engine.resource.SWFResource;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.dgrigg.image.CommonImageManager;
	/**
	 * ...
	 * @author ...
	 */
	public class UIMarket extends FormStyleNine implements IUIMarket
	{
		private var m_dicTabBtn:Dictionary;
		private var m_dicPage:Dictionary;
		private var m_timeLimitPart:TimeLimitPart;
		private var m_preloadImags:Vector.<Image>;
		
		private var m_turnPageBtn:PageTurn;
		private var m_curPage:int;
		private var m_yuabo:MonkeyAndValue;
		private var m_rongyu:MonkeyAndValue;
		private var m_chongzhiBtn:PushButton;
		
		private var m_blackBG:Panel;
		private var m_bluestrip:Panel;
		public function UIMarket() 
		{
			super();
			hideOnCreate = true;
			exitMode = EXITMODE_HIDE;
			_bShowAfterAllImageLoaded = false;
			setAniForm();
		}
		public static function IMAGESWF():String
		{
			return CommonImageManager.toPathString("module/market.swf");
		}
		
		override public function onReady():void
		{			
			m_gkcontext.m_context.m_resMgr.load(IMAGESWF(), SWFResource, onImageSwfLoaded, onImageSwfFailed);			
		}
		override public function onDestroy():void 
		{
			super.onDestroy();
			clearPreCreateImage();
			m_gkcontext.m_marketMgr.m_uiMarketForm = null;
		}
		override public function dispose():void 
		{
			var part:CommonPart;
			for each(part in m_dicPage)
			{			
				part.disposeWhenParentEqualNull();						
			}
			m_timeLimitPart.disposeWhenParentEqualNull();
			super.dispose();
		}
		
		private function onImageSwfLoaded(event:ResourceEvent):void
		{
			var resource:SWFResource = event.resourceObject as SWFResource;
			createImage(resource);
			m_gkcontext.m_context.m_resMgr.unload(IMAGESWF(), SWFResource);			
		}
		private function createImage(res:SWFResource):void
		{
			var panel:Panel;
			var panelContainer:PanelContainer;
			beginPanelDrawBg(724, 550);			
			endPanelDraw();
			
			/*panel = new Panel();
			panel.setSize(454, 397);
			panel.setPos(20, 71);
			panel.setSkinGrid9Image9BySWF(res, "market.blackbg");
			m_bgPart.addDrawCom(panel);*/
			
			/*panel = new Panel();			
			panel.setPos(30, 428);
			panel.setPanelImageSkinBySWF(res, "market.bluestrip");
			m_bgPart.addDrawCom(panel);*/
			
			
			setTitleDraw(282, "market.word_shangcheng", res, 59);
			
			m_blackBG = new Panel(this, 20, 71);
			m_blackBG.setSize(454, 397);
			m_blackBG.setSkinGrid9Image9BySWF(res, "market.blackbg");
			
			m_bluestrip = new Panel(this, 30, 428);
			m_bluestrip.autoSizeByImage = false;
			//m_bluestrip.setSize(454, 397);
			m_bluestrip.setPanelImageSkinBySWF(res, "market.bluestrip");
			
			panel = new Panel(this, -287, 10);
			panel.setPanelImageSkinBySWF(res, "market.women");
			
			panel = new Panel(this, 19, 465);
			panel.setPanelImageSkinMirrorBySWF(res, "market.decorationbottom", Image.MirrorMode_LR);
			
			preCreateImage(res);
			createControls(res);
			m_bInitiated = true;
			m_gkcontext.m_marketMgr.m_uiMarketForm = this;
			timeForTimingClose = 10;			
			this.show();
		}
		
		private function preCreateImage(res:SWFResource):void
		{
			m_preloadImags = new Vector.<Image>();
			m_preloadImags.push(m_gkcontext.m_context.m_commonImageMgr.addImage(res, "market.re", PanelImage));
			m_preloadImags.push(m_gkcontext.m_context.m_commonImageMgr.addImage(res, "market.commoditybg", PanelImage));
			m_preloadImags.push(m_gkcontext.m_context.m_commonImageMgr.addImage(res, "market.commoditybg_", PanelImage, Image.MirrorMode_LR));
			m_preloadImags.push(m_gkcontext.m_context.m_commonImageMgr.addImage(res, "market.yellowbuybtn", PanelImage));
			m_preloadImags.push(m_gkcontext.m_context.m_commonImageMgr.addImage(res, "market.bluebuybtn", PanelImage));
		}
		
		private function clearPreCreateImage():void
		{
			var image:Image;
			for each(image in m_preloadImags)
			{
				m_gkcontext.m_context.m_commonImageMgr.unLoad(image.name);
			}
			m_preloadImags = null;
		}
		
		override public function onShow():void 
		{			
			super.onShow();
			openPage(m_gkcontext.m_marketMgr.openPageID);
			m_timeLimitPart.onUIMarketShow();
			
			
			var page:CommonPart = m_dicPage[m_curPage] as CommonPart;
			if (page)
			{
				page.onUIMarketShow();
			}
			
			updateYuanbao();
			updateRongyu();
			updateNumOfbuy();
		}
		override public function onHide():void 
		{
			super.onHide();
			m_timeLimitPart.onUIMarketHide();
			var page:CommonPart = m_dicPage[m_curPage] as CommonPart;
			if (page)
			{
				page.onUIMarketHide();
			}
		}
		private function createControls(res:SWFResource):void
		{
			m_dicTabBtn = new Dictionary();
			var names:Array = ["热卖", "宝石", "道具","荣誉商场"];
			var btnTab:ButtonTabText;
			var i:int;
			var left:int=21;
			var top:int=43;
			for (i = stMarket.TYPE_remai; i <= stMarket.TYPE_Rongyu; i++)
			{
				btnTab = new ButtonTabText(this, left, top, names[i - 1], onPageBtnClick);
				btnTab.setPanelImageSkin("commoncontrol/button/buttonTab8.swf");
				btnTab.tag = i;
				m_dicTabBtn[i] = btnTab;
				
				if (i == stMarket.TYPE_Rongyu)
				{
					btnTab.setLetterSpacing(1);
				}
				left += 64;
			}
			
			m_turnPageBtn = new PageTurn(this, 193, 439);			
			m_turnPageBtn.setBtnNameHorizontal_Mirror("leftArrow2.swf");
			m_turnPageBtn.setBtnPos(0, 0, 75, 0, 0, 18);
				
			
			var marketData:stMarket = m_gkcontext.m_marketMgr.getMarket(stMarket.TYPE_timelimit);			
			m_timeLimitPart = new TimeLimitPart(m_gkcontext, marketData, this, 473, 38);
			m_timeLimitPart.show();
			m_timeLimitPart.setPanelImageSkinBySWF(res, "market.xianshiqu");
			
			m_dicPage = new Dictionary();
			
			
			m_yuabo = new MonkeyAndValue(m_gkcontext, this, BeingProp.YUAN_BAO, 40, 491);
			m_yuabo.m_moneyPanel.showTip = true;
			m_yuabo.m_value.setFontSize(14);
			
			m_rongyu = new MonkeyAndValue(m_gkcontext, this, BeingProp.RONGYU_PAI, 160, 488);
			m_rongyu.m_moneyPanel.showTip = true;
			m_rongyu.m_value.setFontSize(14);
			m_rongyu.m_value.setPos(29,3);
			m_chongzhiBtn = new PushButton(this, 512, 474, onChongZhiBtnClick);
			m_chongzhiBtn.setSkinButton1Image("commoncontrol/button/rechargeBtn.png");
			
			//openPage(stMarket.TYPE_remai);
		}
		public function onPageBtnClick(e:MouseEvent):void
		{
			var tag:int = (e.target as ButtonTabText).tag;
			showPage(tag);
		}
		
		public function updateYuanbao():void
		{
			m_yuabo.value = m_gkcontext.m_beingProp.getMoney(BeingProp.YUAN_BAO);
		}
		//更新荣誉牌子数量
		public function updateRongyu():void
		{
			m_rongyu.value=m_gkcontext.m_objMgr.computeObjNumInCommonPackage(ZObjectDef.OBJID_rongyu);
			
		}
		public function updateNumOfbuy():void
		{
			if (m_timeLimitPart)
			{
				m_timeLimitPart.update();
			}
			
			var part:CommonPart;
			for each(part in m_dicPage)
			{
				part.update();
			}
		}
		public function openPage(iPage:int):void
		{
			(m_dicTabBtn[iPage] as ButtonTabText).selected = true;
			showPage(iPage);
		}
		
		private	function showPage(iPage:int):void
		{		
			m_curPage = iPage;
			var pageShow:CommonPart = m_dicPage[iPage];
			if (pageShow == null)
			{
				var marketData:stMarket = m_gkcontext.m_marketMgr.getMarket(iPage);
				if (marketData == null)
				{
					return;
				}
				if (iPage == stMarket.TYPE_Rongyu)
				{
					pageShow = new RongyuPart(m_turnPageBtn, m_gkcontext, marketData,this, 26, 84);
				}
				else
				{
					pageShow = new YuanBaoPart(m_turnPageBtn, m_gkcontext, marketData, this, 26, 84);
				}
				m_dicPage[iPage] = pageShow;
			}
			
			if (pageShow.isVisible())
			{
				return;
			}
			pageShow.show();			
			var page:CommonPart;
			for each(page in m_dicPage)
			{
				if (page != pageShow)
				{
					page.hide();
				}
			}
			
			if (iPage == stMarket.TYPE_Rongyu)
			{
				showBgBig();
			}
			else
			{
				showBgSmall();
			}
		}
		
		override public function getDestPosForHide():Point 
		{
			if (m_gkcontext.m_UIs.sysBtn)
			{
				var pt:Point = m_gkcontext.m_UIs.sysBtn.getBtnPosInScreenByIdx(SysbtnMgr.SYSBTN_Marekt);
				if (pt)
				{
					pt.x -= 13;
					pt.y -= 17;
					return pt;
				}
			}
			return null;
		}
		
		public function onChongZhiBtnClick(e:MouseEvent):void
		{
			m_gkcontext.m_context.m_platformMgr.openRechargeWeb();
		}		
		
		private function showBgBig():void
		{
			m_blackBG.setSize(684, 397);			
			m_bluestrip.setSize(680, 39);
			m_timeLimitPart.hide();
		}
		private function showBgSmall():void
		{			
			m_blackBG.setSize(454, 397);			
			m_bluestrip.setSize(450, 39);
			m_timeLimitPart.show();
		}
	}

}