package game.ui.uiZhenfa
{
	//import com.bit101.components.ButtonText;
	import com.ani.AniPosition;
	import com.bit101.components.ButtonText;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.PushButton;
	import com.dgrigg.image.Image;
 	import com.dgrigg.image.PanelImage;
	import modulecommon.commonfuntion.LocalDataMgr;
	import modulecommon.scene.wu.WuProperty;
	import modulecommon.uiinterface.IUIFastSwapEquips;
	import game.ui.uiZhenfa.xiayewulist.XiayeWuList;
	//import com.dgrigg.minimalcomps.skins.VScrollSliderSkin;
	import com.pblabs.engine.entity.BeingEntity;
	//import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	//import flash.geom.Rectangle;
	import modulecommon.appcontrol.DigitComponent;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.scene.beings.PlayerMain;
	import modulecommon.scene.sysbtn.SysbtnMgr;
	import modulecommon.scene.wu.WuMainProperty;
	//import modulecommon.scene.wu.WuProperty;
	import modulecommon.ui.Form;
	import modulecommon.ui.FormStyleNine;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIZhenfa;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.SWFResource;
	import com.dgrigg.image.CommonImageManager;
	//import modulecommon.uiObject.UIMBeing;
	//import org.ffilmation.engine.core.fRenderableElement;
	//import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9ElementRenderer;
	import game.ui.uiZhenfa.event.DragWuEvent;	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class UIZhenfa extends FormStyleNine implements IUIZhenfa
	{				
		private var m_imageRes:SWFResource;
		private var m_wuList:WuIconList;
		private var m_bgPanel:PanelContainer;		
		private var m_zhenfa:ZhenfaPanel;
		private var m_jinnangPanel:JinNangPanel;
		private var m_neededImage:Array;
		private var m_restraintPanel:Panel;
		private var m_wuZhanliDC:DigitComponent;
		private var m_zhenliLabel:Label;
		private var m_closedBg2:PanelContainer;
		private var m_notopenPanel:Panel;
		private var m_herosUpPanel:Panel;	//武将上阵总数
		private var m_xiayeWuList:XiayeWuList;		//下野武将列表
		private var m_indentBtn:PushButton;			//下野武将列表显示按钮
		private var m_ani:AniPosition;
		private var m_bShowXiayeWuPanel:Boolean;	//是否显示下野武将列表
		private var m_fastswapBtn:ButtonText;
		
		public function UIZhenfa():void
		{
			this.exitMode = EXITMODE_HIDE;
			setAniForm();				
		}
	
		override public function onReady():void
		{			
			m_gkcontext.addLog("阵法onready开始");			
			
			beginPanelDrawBg(762, 479);
			endPanelDraw();
			
			m_bgPanel = new PanelContainer(this, 16, 38);
			m_bgPanel.setSize(730, 424);
			
			var label:Label;
			label = new Label(m_bgPanel, 618, 36, "拖入左边锦囊栏", 0xE0972E);
			label = new Label(m_bgPanel, 618, 52, "战斗中将能起效", 0xE0972E);
			label = new Label(m_bgPanel, 611, 172, "在野武将锦囊无效", 0xE0972E);
			
			m_restraintPanel = new Panel(m_bgPanel, 606, 223);
			m_restraintPanel.setSize(118, 197);
			
			m_wuList = new WuIconList(this, m_gkcontext);
			m_wuList.setPos(18, 40);
			
			m_wuZhanliDC = new DigitComponent(m_gkcontext.m_context, m_bgPanel, 235, 18);
			m_wuZhanliDC.setParam("commoncontrol/digit/digit01",10,18);
		
			m_zhenliLabel = new Label(m_bgPanel, 188, 46, "暂未开放", 0xE0972E, 12);
			m_zhenliLabel.setSize(70, 30)
			
			m_herosUpPanel = new Panel(this, 538, 112);
			
			m_xiayeWuList = new XiayeWuList(m_gkcontext, this, null, -180, 0);
			this.addChildAt(m_xiayeWuList, 0);
			
				
			m_jinnangPanel = new JinNangPanel(this, 625, 134, m_gkcontext);
			
			m_indentBtn = new PushButton(this, -20, 207, onIndentBtn);
			m_indentBtn.setSkinButton1ImageMirror("commoncontrol/button/leftArrow5.png", Image.MirrorMode_HOR);
			
			m_fastswapBtn = new ButtonText(this, 190, 142, "换装", onClickFastSwapBtn);
			m_fastswapBtn.setSize(49, 26);
			m_fastswapBtn.setSkinButton1Image("commoncontrol/button/button8.png");
			
			timeForTimingClose = 20;			
			
		}
		override public function onHide():void
		{
			if (m_zhenfa)
			{
				m_zhenfa.unAttachTickMgr();
			}
		}
		public function setWuPos(heroID:uint, gridNO:int):void
		{
			m_zhenfa.setWuPos(heroID,gridNO);
		}
		public function clearWuByPos(gridNO:int):void
		{
			m_zhenfa.clearWuByPos(gridNO);			
		}
		public function buildList():void
		{
			m_wuList.generate();
		}
		
		public function  clearJinnang(pos:int):void
		{
			m_jinnangPanel.clearJinnang(pos);			
		}
		public function  setJinnang(idInit:uint, pos:int):void
		{
			m_jinnangPanel.setJinnang(idInit,pos);			
		}
		
		public function  onLevelup():void
		{
			m_jinnangPanel.updateLock();
		}
		
		public function updateJinnangGrid():void
		{
			if (m_jinnangPanel)
			{
				m_jinnangPanel.updateJinnangGrid();
			}
		}
		
		public function addWu(heroID:uint):void
		{
			m_wuList.generate();
		}
		
		public function openGrid(gridNo:int):void
		{
			m_zhenfa.openGrid(gridNo);
		}
		
		public function updateXiayeWuNum(wu:WuProperty):void
		{
			m_xiayeWuList.updateWuNum(wu);
		}
		
		public function addXiayeWu(wu:WuProperty):void
		{
			m_xiayeWuList.addXiayeWu(wu);
		}
		
		public function removeXiayeWu(wu:WuProperty):void
		{
			m_xiayeWuList.removeXiayeWu(wu);
		}
		
		
		
		override public function onShow():void
		{
			//super.onShow();
			this.adjustPosWithAlign();
			m_wuList.generate();
			
			m_wuList.showNewHandToWuList();
			m_jinnangPanel.showNewHandOfJinnang();
			
			if (m_zhenfa)
			{
				m_zhenfa.atachTickMgr();
			}
			
			if (!m_gkcontext.m_newHandMgr.isVisible())
			{
				super.onShow();
			}
			else
			{
				this.resetShowParam();
			}
			
			if (m_gkcontext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_JINNANG))
			{
				m_restraintPanel.visible = true;
				
				if (m_closedBg2)
				{
					m_closedBg2.visible = false;
				}
				m_jinnangPanel.showTopBackOfJNNotOpen(false);
			}
			else
			{
				m_restraintPanel.visible = false;
				
				if (null == m_closedBg2)
				{
					m_closedBg2 = new PanelContainer(this, 621, 260);
					m_closedBg2.setPanelImageSkinMirror("commoncontrol/panel/jinnangBg2.png", Image.MirrorMode_LR);
					m_notopenPanel = new Panel(m_closedBg2, 34, 115);
					m_notopenPanel.setPanelImageSkin("commoncontrol/panel/notOpen.png");
				}
				m_jinnangPanel.showTopBackOfJNNotOpen(true);
			}
			m_jinnangPanel.updateLock();
			
			updateShowXiayeWuList();
			updateZhenfaHerosUp();
		}
		
		//更新下野武将列表显示
		private function updateShowXiayeWuList():void
		{
			if (m_gkcontext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_HEROXIAYE))
			{
				var list:Array = m_gkcontext.m_wuMgr.getXiayeWuList();
				if (list.length > 0)
				{
					m_bShowXiayeWuPanel = true;
					m_xiayeWuList.setPos( -180, 0);
					m_indentBtn.setSkinButton1ImageMirror("commoncontrol/button/leftArrow5.png", Image.MirrorMode_HOR);
				}
				else
				{
					m_bShowXiayeWuPanel = false;
					m_xiayeWuList.setPos( 0, 0);
					m_indentBtn.setSkinButton1Image("commoncontrol/button/leftArrow5.png");
				}
				m_xiayeWuList.visible = true;
				m_indentBtn.visible = true;
			}
			else
			{
				m_xiayeWuList.visible = false;
				m_indentBtn.visible = false;
			}
		}
		
		override public function onStageReSize():void
		{
			super.onStageReSize();
		}		

		override public function setImageSWF(imageSWF:SWFResource):void 
		{
			super.setImageSWF(imageSWF);
			
			m_neededImage = new Array();
			var comMGr:CommonImageManager = m_gkcontext.m_context.m_commonImageMgr;
			m_neededImage.push(comMGr.loadSWF(imageSWF, PanelImage, "zhenfa.accept"));
			m_neededImage.push(comMGr.loadSWF(imageSWF, PanelImage, "zhenfa.refuse"));
			
			setTitleDraw(282, "zhenfa.word_zhenfa", imageSWF, 61);
			
			m_bgPanel.setPanelImageSkinBySWF(imageSWF, "zhenfa.zhenfaGB");
			m_restraintPanel.setPanelImageSkinBySWF(imageSWF, "zhenfa.restraint");
			
			m_wuList.initData(imageSWF);	
			m_zhenfa = new ZhenfaPanel(this, m_bgPanel, m_gkcontext);
			m_zhenfa.createImage(imageSWF);
			m_zhenfa.initData();
			
			m_wuList.addEventListener(DragWuEvent.DRAG_WU, m_zhenfa.onDragWu);
			m_wuList.addEventListener(DragWuEvent.DROP_WU, m_zhenfa.onDropWu);
			
			m_jinnangPanel.initData();
			m_jinnangPanel.createImage(imageSWF);
			
			m_xiayeWuList.setDatas();
			m_xiayeWuList.m_wuIconList = m_wuList;			
			
			m_bInitiated = true;
			m_gkcontext.m_UIs.zhenfa = this;
		}
		private function createImage(res:SWFResource):void
		{
			
			show();
		} 
		
		override public function onDestroy():void 
		{
			super.onDestroy();
			m_gkcontext.m_UIs.zhenfa = null;
		}
		
		override public function dispose():void
		{
			m_gkcontext.m_UIs.zhenfa = null;
			if(m_wuList)
			{
				m_wuList.removeEventListener(DragWuEvent.DRAG_WU, m_zhenfa.onDragWu);
				m_wuList.removeEventListener(DragWuEvent.DROP_WU, m_zhenfa.onDropWu);
			}
			
			super.dispose();
			
			if (m_gkcontext.m_newHandMgr.isVisible())
			{
				m_gkcontext.m_newHandMgr.hide();
				
				var hurt:BeingEntity = m_gkcontext.m_npcManager.getBeingByNpcID(1011);
				var main:PlayerMain = m_gkcontext.m_playerManager.hero;
				if (hurt && main)
				{
					main.moveToNpcVisitByNpcID(hurt.x, hurt.y, 1011);
				}
			}
		}
		
		public function get zhenfa():ZhenfaPanel
		{
			if (m_zhenfa)
			{
				return m_zhenfa;
			}
			else
			{
				return null;
			}
		}
		
		public function getZhenfaGrid(gridNO:int):zhenfaGrid
		{
			if (m_zhenfa)
			{
				return m_zhenfa.getZhenfaGrid(gridNO);
			}
			else
			{
				return null;
			}
		}
		
		public function updateAllWuZhanli():void
		{
			/*
			var count:uint;
			var arrFight:Array = m_gkcontext.m_wuMgr.getFightWuList(true, true);
			
			for each(var wu:WuProperty in arrFight)
			{
				count += wu.m_uZhanli;
			}
			*/
			var wu:WuMainProperty = this.m_gkcontext.m_wuMgr.getMainWu();
			if(wu == null)
			{
				return;
			}
			
			m_wuZhanliDC.digit = wu.m_uZongZhanli;
		}
		
		//更新上阵人数显示
		public function updateZhenfaHerosUp():void
		{
			m_herosUpPanel.setPanelImageSkin("commoncontrol/digit/digit02/" + m_gkcontext.m_zhenfaMgr.m_zhenfaHerosUp + ".png");
		}
		
		override public function getDestPosForHide():Point 
		{
			if (m_gkcontext.m_UIs.sysBtn)
			{
				var pt:Point = m_gkcontext.m_UIs.sysBtn.getBtnPosInScreenByIdx(SysbtnMgr.SYSBTN_ZhenXing);
				if (pt)
				{
					pt.x -= 13;
					pt.y -= 17;
					return pt;
				}
			}
			return null;
		}
		
		private function onIndentBtn(event:MouseEvent):void
		{
			showXiayeWuPanel();
		}
		
		private function onClickFastSwapBtn(event:MouseEvent):void
		{
			if (event.currentTarget == m_fastswapBtn)
			{
				var form:IUIFastSwapEquips = m_gkcontext.m_UIMgr.showFormInGame(UIFormID.UIFastSwapEquips) as IUIFastSwapEquips;
				form.initData(WuProperty.MAINHERO_ID);				
			}
		}
		
		public function showXiayeWuPanel():void
		{
			if (m_ani == null)
			{
				m_ani = new AniPosition();
				m_ani.sprite = m_xiayeWuList;
				m_ani.duration = 0.6;
			}
			
			if (m_ani.bRun)
			{
				return;
			}
			
			m_ani.setBeginPos(m_xiayeWuList.x, m_xiayeWuList.y);
			if (m_bShowXiayeWuPanel)
			{
				m_indentBtn.setSkinButton1Image("commoncontrol/button/leftArrow5.png");
				m_ani.setEndPos(m_xiayeWuList.x + 180, m_xiayeWuList.y);
			}
			else
			{
				m_indentBtn.setSkinButton1ImageMirror("commoncontrol/button/leftArrow5.png", Image.MirrorMode_HOR);
				m_ani.setEndPos(m_xiayeWuList.x - 180, m_xiayeWuList.y);
			}
			m_ani.begin();
			
			m_bShowXiayeWuPanel = !m_bShowXiayeWuPanel;
		}
		
	}

}