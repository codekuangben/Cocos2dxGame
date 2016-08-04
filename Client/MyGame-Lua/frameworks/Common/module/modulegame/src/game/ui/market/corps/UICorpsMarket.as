package game.ui.market.corps 
{
	import com.bit101.components.ButtonTabText;
	import com.bit101.components.Label;
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
	import com.util.UtilColor;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUICorpsMarket;
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
	public class UICorpsMarket extends FormStyleNine implements IUICorpsMarket
	{		
					
		private var m_dicPage:Dictionary;		
		private var m_preloadImags:Vector.<Image>;
		
		private var m_turnPageBtn:PageTurn;
		private var m_curPage:int; 
		
		private var m_gongxianLabel:Label;
		private var m_blackBG:Panel;
		private var m_bluestrip:Panel;
		
		private var m_donateBtn:PushButton;
		
		public function UICorpsMarket() 
		{
			super();
			hideOnCreate = true;
			exitMode = EXITMODE_HIDE;
			_bShowAfterAllImageLoaded = false;
			//_playAniWhenShowAndHide = true;
			timeForTimingClose = 10;
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
			m_gkcontext.m_marketMgr.m_uiCorpsMarketForm = null;
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
			
			setTitleDraw(282, "commoncontrol/panel/market/word_juntuanshangcheng.png", null, 102);
			
			m_blackBG = new Panel(this, 20, 71);
			m_blackBG.setSize(684, 397);	
			m_blackBG.setSkinGrid9Image9BySWF(res, "market.blackbg");
					
			
			m_bluestrip = new Panel(this, 30, 428);			
			m_bluestrip.autoSizeByImage = false;
			m_bluestrip.setSize(680, 39);
			m_bluestrip.setPanelImageSkinBySWF(res, "market.bluestrip");
			
			panel = new Panel(this, -287, 10);
			panel.setPanelImageSkinBySWF(res, "market.women");
			
			panel = new Panel(this, 19, 465);
			panel.setPanelImageSkinMirrorBySWF(res, "market.decorationbottom", Image.MirrorMode_LR);
			
			var label:Label = new Label(this, 50, 490, "我的军团贡献"); label.mouseEnabled = true;
		
			m_donateBtn = new PushButton(this, 595, 487, onFunBtnClick);
			m_donateBtn.setPanelImageSkin("commoncontrol/button/buttonDonate.swf");
			
			preCreateImage(res);
			createControls(res);
			m_bInitiated = true;
			m_gkcontext.m_marketMgr.m_uiCorpsMarketForm = this;
			timeForTimingClose = 10;
			this.show();
		}
		
		private function preCreateImage(res:SWFResource):void
		{
			m_preloadImags = new Vector.<Image>();
			m_preloadImags.push(m_gkcontext.m_context.m_commonImageMgr.addImage(res, "market.commoditybg", PanelImage));			
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
			openPage(stMarket.TYPE_corps);			
		
			updateGongxian();	
			updateNumOfbuy();
		}
		
		private function createControls(res:SWFResource):void
		{			
			
			m_turnPageBtn = new PageTurn(this, 325, 439);			
			m_turnPageBtn.setBtnNameHorizontal_Mirror("leftArrow2.swf");
			m_turnPageBtn.setBtnPos(0, 0, 75, 0, 0, 18);				
			
			m_gongxianLabel = new Label(this, 135, 489);
			m_gongxianLabel.setBold(true);
			m_gongxianLabel.setFontSize(14);
			m_gongxianLabel.setFontColor(UtilColor.GREEN);
			m_dicPage = new Dictionary();				
		}
	
		
		public function updateGongxian():void
		{
			m_gongxianLabel.intText = m_gkcontext.m_corpsMgr.m_corpsInfo.gongxian;
		}
		
		public function updateNumOfbuy():void
		{			
			
			var part:CommonPart;
			for each(part in m_dicPage)
			{
				part.update();
			}
		}
		
		public function openPage(iPage:int):void
		{			
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
				pageShow = new CorpsPart(m_turnPageBtn, m_gkcontext, marketData, this, 26, 84);
				
				m_dicPage[iPage] = pageShow;
			}
			(pageShow as CorpsPart).updateList();
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
		}
		
		private function onFunBtnClick(e:MouseEvent):void
		{
			m_gkcontext.m_UIMgr.showFormEx(UIFormID.UICorpsDonate);
		}
				
		
	}

}