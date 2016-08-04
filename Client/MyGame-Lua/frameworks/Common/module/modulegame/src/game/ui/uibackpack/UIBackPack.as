package game.ui.uibackpack
{
	import com.ani.AniPosition;
	import com.bit101.components.ButtonText;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.PushButton;
	import com.dgrigg.image.CommonImageManager;
	import com.dgrigg.image.Image;
	import com.dgrigg.image.ImageForm;
	import com.dgrigg.image.PanelImage;
	import com.pblabs.engine.entity.BeingEntity;
	import com.util.DebugBox;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import game.ui.uibackpack.relationwu.RelationMainWu.RelationMainWuPanel;
	import modulecommon.appcontrol.PanelDisposeEx;
	import modulecommon.commonfuntion.LocalDataMgr;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.res.ResGrid9;
	import modulecommon.scene.beings.PlayerMain;
	import modulecommon.scene.prop.object.stObjLocation;
	import modulecommon.scene.prop.object.T_Object;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TObjectBaseItem;
	import modulecommon.scene.sysbtn.SysbtnMgr;
	import modulecommon.scene.wu.WuProperty;
	import modulecommon.ui.FormStyleNine;
	import modulecommon.ui.UIFormID;
	import org.ffilmation.engine.datatypes.IntPoint;
	import game.ui.uibackpack.backpack.BackPack;
	import game.ui.uibackpack.fastswapequips.UIFastSwapEquips;
	import game.ui.uibackpack.relationwu.RelationWuPanel;
	import game.ui.uibackpack.xiayewulist.XiayeWuList;
	
	import game.ui.uibackpack.subForm.fastZhuansheng.FastZhuanshengMgr;
	import game.ui.uibackpack.subForm.UIChaifenDlg;
	import game.ui.uibackpack.watch.UIWatchPlayer;
	import game.ui.uibackpack.wujiang.AllWuPanel;
	
	//import common.Context;
	import modulecommon.ui.Form;
	import flash.events.MouseEvent;
	import modulecommon.uiinterface.IUIBackPack;
	import com.pblabs.engine.resource.SWFResource;
	import com.pblabs.engine.resource.ResourceEvent;	
	import ui.IImageSWFHost;
	import ui.ImageSWFLoader;
	/**
	 * ...
	 * @author
	 */
	public class UIBackPack extends FormStyleNine implements IUIBackPack, IImageSWFHost
	{
		private var m_swfLoader:ImageSWFLoader;
		private var m_backPack:BackPack;
		private var m_allWu:AllWuPanel;
		
		private var m_neededImage:Array;
		private var m_chaifenDlg:UIChaifenDlg;
		private var m_updateAllObjectsDirty:Boolean;	
		public var m_fastZhuangMgr:FastZhuanshengMgr;
		private var m_xiayeWuList:XiayeWuList;		//下野武将列表
		private var m_indentBtn:PushButton;			//打开"下野武将列表"按钮
		private var m_ani:AniPosition;
		private var m_bShowXiayeWuPanel:Boolean;	//是否显示下野武将列表
		private var m_relationWuPanel:RelationWuPanel;			//武将关系激活列表
		private var m_relationMainWuPanel:RelationMainWuPanel;	//主角"我的三国关系"激活武将列表
		private var m_relationBtn:PushButton;		//打开"关系武将"按钮
		private var m_relationAni:AniPosition;
		private var m_packageBtn:PushButton;		//打开"包裹"按钮
		private var m_packageAni:AniPosition;
		
		public function UIBackPack()
		{
			super();
			this.hideOnCreate = true;
			setAniForm();	
		}
		
		override public function onReady():void
		{
			this.exitMode = EXITMODE_HIDE;
			this.m_gkcontext.m_UIs.backPack = this;
			
			m_allWu = new AllWuPanel(this, m_gkcontext);
			m_allWu.setPos(20, 22);
			
			m_xiayeWuList = new XiayeWuList(m_gkcontext, this, null, -180, 27);
			this.addChildAt(m_xiayeWuList, 0);
			
			m_relationWuPanel = new RelationWuPanel(m_gkcontext, this, null, 306, 27);
			this.addChildAt(m_relationWuPanel, 0);
			
			m_indentBtn = new PushButton(this, -20, 240, onBtnClick);
			m_indentBtn.setSkinButton1ImageMirror("commoncontrol/button/leftArrow5.png", Image.MirrorMode_HOR);
			m_indentBtn.tag = 0;
			
			m_relationBtn = new PushButton(this, 426, 150, onBtnClick);
			m_relationBtn.tag = 1;
			
			m_packageBtn = new PushButton(this, 426, 310, onBtnClick);
			m_packageBtn.tag = 2;
			
			m_swfLoader = new ImageSWFLoader(m_gkcontext.m_context, this);
			m_swfLoader.load("module/backpack.swf");
			
			this.setDropTrigger(true);
			m_fastZhuangMgr = new FastZhuanshengMgr(m_gkcontext);
			
			m_gkcontext.m_wuMgr.loadConfig();//读取培养配置文件数据
			m_gkcontext.m_wuMgr.loadConfigUAR();//"我的三国关系"激活关系数据
		}
		
		override public function onDestroy():void
		{
			super.onDestroy();
			this.m_gkcontext.m_UIs.backPack = null;
			if (m_neededImage != null)
			{
				var comMGr:CommonImageManager = m_gkcontext.m_context.m_commonImageMgr;
				for (var i:int; i < m_neededImage.length; i++)
				{
					comMGr.unLoad((m_neededImage[i] as Image).name);
				}
				m_neededImage = null;
			}
		}
		
		public function updateHero(id:uint):void
		{
			m_allWu.updateHero(id);
		}
			
		override public function onShow():void
		{
			//super.onShow();
			m_allWu.onUIBackPackShow();
			m_allWu.updateTrainDatas();
			
			onShowXiayeWuList();
			onShowRelationWuPanel();
			onShowPackage();
			
			if (m_updateAllObjectsDirty)
			{
				updateAllObjectsEx();
				m_updateAllObjectsDirty = false;
			}
			
			var pageid:int = AllWuPanel.PAGE_EQUIP;
			if (m_gkcontext.m_newHandMgr.isVisible())
			{
				adjustPosWithAlign();
				m_allWu.selectShowPage(pageid);
				onShowNewHand();
			}
			
			if (!m_gkcontext.m_newHandMgr.isVisible())
			{
				super.onShow();
			}
			else
			{
				this.resetShowParam();
			}
		}
		
		//更新下野武将列表显示
		private function onShowXiayeWuList():void
		{
			if (m_gkcontext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_HEROXIAYE))
			{
				var list:Array = m_gkcontext.m_wuMgr.getXiayeWuList();
				if (list.length > 0)
				{
					m_bShowXiayeWuPanel = true;
					m_xiayeWuList.setPos( -180, 27);
					m_indentBtn.setSkinButton1ImageMirror("commoncontrol/button/leftArrow5.png", Image.MirrorMode_HOR);
				}
				else
				{
					m_bShowXiayeWuPanel = false;
					m_xiayeWuList.setPos( 0, 27);
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
		
		//更新"关系武将"显示
		public function onShowRelationWuPanel():void
		{
			m_relationBtn.visible = true;
			
			if (WuProperty.MAINHERO_ID == curHeroID || m_gkcontext.m_sysbtnMgr.m_bShowPackage)
			{
				if (WuProperty.MAINHERO_ID == curHeroID)
				{
					if (m_gkcontext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_USERACTRELAIONS))
					{
						if (null == m_relationMainWuPanel)
						{
							m_relationMainWuPanel = new RelationMainWuPanel(m_gkcontext, this, null, 446, 0);
							this.addChildAt(m_relationMainWuPanel, 0);
						}
						m_relationMainWuPanel.visible = true;
					}
					else
					{
						m_relationBtn.visible = false;
					}
				}
				
				if (m_relationMainWuPanel)
				{
					if (m_gkcontext.m_sysbtnMgr.m_bShowPackage)
					{
						m_relationMainWuPanel.visible = false;
						m_relationMainWuPanel.setShowPos(false);
					}
					else
					{
						m_relationMainWuPanel.visible = true;
						m_relationMainWuPanel.setShowPos(true);
					}
				}
				
				m_relationWuPanel.setShowPos(false);
			}
			else
			{
				m_relationWuPanel.setShowPos(true);
			}
			
			if (WuProperty.MAINHERO_ID == curHeroID)
			{
				if (m_relationMainWuPanel)
				{
					m_relationMainWuPanel.visible = true;
				}
			}
			else
			{
				if (m_relationMainWuPanel)
				{
					m_relationMainWuPanel.visible = false;
				}
				m_relationWuPanel.showRelationWusByHeroID(curHeroID);
			}
		}
		
		//更新"包裹"显示
		public function onShowPackage():void
		{
			if (m_gkcontext.m_sysbtnMgr.m_bShowPackage)
			{
				if (m_relationWuPanel.bShow)
				{
					m_relationWuPanel.setShowPos(false);
				}
				if (m_relationMainWuPanel && m_relationMainWuPanel.bShow)
				{
					m_relationMainWuPanel.setShowPos(false);
				}
				
				if (null == m_backPack)
				{
					m_backPack = new BackPack(m_gkcontext, this, m_allWu);
					this.addChildAt(m_backPack, 0);
					m_backPack.setPos(146, 0);
				}
				
				m_backPack.onUIBackPackShow();
				m_backPack.setShowPos(true);
			}
			else
			{
				if (m_backPack)
				{
					m_backPack.setShowPos(false);
				}
			}
		}
		
		override protected function computeAdjustPosWithAlign():Point
		{
			var ret:Point = super.computeAdjustPosWithAlign();
			
			ret.x -= 160;
			
			return ret;
		}
		
		override public function onHide():void 
		{
			super.onHide();
			m_allWu.onUIBackPackHide();
			if (m_backPack)
			{
				m_backPack.onUIBackPackHide();
				m_backPack.setShowPos(false);
			}
			
			m_relationWuPanel.setShowPos(false);
			m_gkcontext.m_sysbtnMgr.m_bShowPackage = false;
		}
		
		override public function onStageReSize():void
		{
			super.onStageReSize();
		}
		
		public function addObject(obj:ZObject):void
		{
			if (inEquipPackage(obj))
			{
				m_allWu.addObject(obj);
			}
			else
			{
				if (m_backPack)
				{
					m_backPack.addObject(obj);
				}
			}
		
		}
		
		public function removeObject(obj:ZObject):void
		{
			if (inEquipPackage(obj))
			{
				m_allWu.removeObject(obj);
			}
			else
			{
				if (m_backPack)
				{
					m_backPack.removeObject(obj);
				}
			}
		
		}
		
		public function updateObject(obj:ZObject):void
		{			
			if (inEquipPackage(obj))
			{
				m_allWu.updateObject(obj);
			}
			else
			{
				if (m_backPack)
				{
					m_backPack.updateObject(obj);
				}
			}
		}
		
		public function onBtnClk(event:MouseEvent):void
		{
			var obj:ZObject = new ZObject();
			obj.m_ObjectBase = this.m_gkcontext.m_dataTable.getItem(DataTable.TABLE_OBJECT, 4) as TObjectBaseItem;
			obj.m_object = new T_Object();
			obj.m_object.m_loation.x = 2;
			obj.m_object.m_loation.y = 2;
			addObject(obj);		
		}
		
		public function updateWu():void
		{
			m_allWu.updateCurWu();			
		}
		
		public function updateFastZhuanshengForm():void
		{
			m_fastZhuangMgr.updateForm();			
		}
		
		public function updateHeroTrain(id:uint = 0):void
		{
			m_allWu.updateTrainDatas(id);
		}
		
		public function updateZhanshu():void
		{
			m_allWu.updateZhanshu();
		}
		
		public function addWu(heroID:uint):void
		{
			m_allWu.addWu(heroID);
			m_allWu.updateCurWu();
			m_fastZhuangMgr.updateForm();
			
			if (m_relationMainWuPanel)
			{
				m_relationMainWuPanel.updateWuState(heroID);
			}
		}		
		
		
		public function createImage(res:SWFResource):void
		{
			m_neededImage = new Array();
			var comMGr:CommonImageManager = m_gkcontext.m_context.m_commonImageMgr;
			m_neededImage.push(comMGr.loadSWF(res, PanelImage, "backpage.zhanli"));
			m_neededImage.push(comMGr.loadSWF(res, PanelImage, "backpage.guanxi"));
			m_neededImage.push(comMGr.loadSWF(res, PanelImage, "backpage.textBG"));
			//================================================
			var panel:Panel;
			beginPanelDrawBg(446, 524);
			//m_bgPart.addContainer();
			
			panel = new Panel(null, 164, 34);
			panel.setSize(250, 30);
			panel.autoSizeByImage = false;
			panel.setPanelImageSkinMirrorBySWF(res, "backpage.topline", Image.MirrorMode_LR);
			m_bgPart.addDrawCom(panel);
			
			panel = new Panel(null, 120, 60);
			panel.setPanelImageSkinBySWF(res, "backpage.whiteline");
			m_bgPart.addDrawCom(panel);
			
			panel = new Panel(null, 412, 60);
			panel.setPanelImageSkinBySWF(res, "backpage.whitedoubleline");
			m_bgPart.addDrawCom(panel);
			
			panel = new Panel(null, 699, 60);
			panel.setPanelImageSkinBySWF(res, "backpage.whitedoubleline");
			m_bgPart.addDrawCom(panel);
			
			endPanelDraw();
			
			setTitleDraw(262, "backpage.word_renwu", res, 63);
			/*
			m_bgPart.addContainer();
			var size:IntPoint = ImageForm.s_round(674, 474);
			
			this.setSize(size.x, size.y);
			m_bgPart.addContainer();
			m_bgPart.setSize(this.width, this.height);
			this.setTitle("人物", 385);
			
			var panel:Panel;
			var panelContainer:PanelContainer = new PanelContainer();
			panelContainer.setSize(this.width, this.height);
			m_bgPart.addDrawCom(panelContainer, true);
			panelContainer.setSkinForm("form4.swf");	
			
			panelContainer = new PanelContainer(null, 130, 23);
			panelContainer.setSize(255, 426);
			panelContainer.setSkinGrid9Image9(ResGrid9.StypeTwo);
			m_bgPart.addDrawCom(panelContainer, true);
			m_bgPart.drawPanel();
			*/
			//==========================================
			m_relationBtn.setSkinButton1ImageBySWF(res, "backpage.relationBtn");
			m_packageBtn.setSkinButton1ImageBySWF(res, "backpage.packageBtn");
			
			m_allWu.createImage(res);
			m_xiayeWuList.setDatas();
			m_xiayeWuList.m_wubtnlist = m_allWu.wuBtnList;
			
			
			m_bInitiated = true;
			show();	
		}
		
		public function removeWu(heroID:uint):void
		{
			m_allWu.removeWu(heroID);
			
			if (m_relationMainWuPanel)
			{
				m_relationMainWuPanel.updateWuState(heroID);
			}
		}
		//武将数量变化
		public function onWuNumChange(heroid:int):void
		{
			m_allWu.onWuNumChange(heroid);
			
			m_xiayeWuList.updateWuNum(m_gkcontext.m_wuMgr.getWuByHeroID(heroid));
		}
		
		public function generateBtnList():void
		{
			m_allWu.generateBtnList();
		}
		
		public function addXiayeWu(wu:WuProperty):void
		{
			m_xiayeWuList.addXiayeWu(wu);
			
			if (m_relationMainWuPanel)
			{
				m_relationMainWuPanel.updateWuState(wu.m_uHeroID);
			}
		}
		
		public function removeXiayeWu(wu:WuProperty):void
		{
			m_xiayeWuList.removeXiayeWu(wu);
			
			if (m_relationMainWuPanel)
			{
				m_relationMainWuPanel.updateWuState(wu.m_uHeroID);
			}
		}
		
		public function updateLocState(oldOpenedSize:int, nowOpenedSize:int):void
		{
			if (m_backPack)
			{
				m_backPack.updateLocState(oldOpenedSize, nowOpenedSize);
			}
		}
		public function updateNextOpenedGrid():void
		{
			if (m_backPack)
			{
				m_backPack.updateNextOpenedGrid();
			}
		}
		public function updateAllObjects():void
		{
			if (isVisible()==false)
			{
				m_updateAllObjectsDirty = true;
			}
			else
			{
				updateAllObjectsEx();
			}
		}
		
		public function reloadCommonObjects():void
		{
			if (m_backPack)
			{
				m_backPack.reloadObjects();
			}
		}
		public function reloadBaowuPackage():void
		{
			if (m_backPack)
			{
				m_backPack.reloadBaowuPackage();
			}
		}
		private function updateAllObjectsEx():void
		{
			if (m_backPack)
			{
				m_backPack.updateAllObjects();
			}
		}
		protected static function inEquipPackage(obj:ZObject):Boolean
		{
			var loc:int = obj.m_object.m_loation.location;
			
			if (loc >= stObjLocation.OBJECTCELLTYPE_COMMON1 && loc <= stObjLocation.OBJECTCELLTYPE_COMMON3 || loc == stObjLocation.OBJECTCELLTYPE_BAOWU)
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		
		public function get curHeroID():uint
		{
			return this.m_allWu.wuBtnList.curHeroID;
		}
		
		public function get decoratePanel():PanelDisposeEx
		{
			return m_allWu.m_wuDecorate;
		}
		
		public function get xiayeWuList():XiayeWuList
		{
			return m_xiayeWuList;
		}
		
		public function get relationWuPanel():RelationWuPanel
		{
			return m_relationWuPanel;
		}
		
		override public function dispose():void 
		{
			m_swfLoader.dispose();
			if (m_chaifenDlg)
			{
				m_gkcontext.m_UIMgr.destroyForm(m_chaifenDlg.id);
				m_chaifenDlg = null;
			}			
			
			super.dispose();
		}
		
		override protected function onExitBtnClick(e:MouseEvent):void
		{
			super.onExitBtnClick(e);
			
			if (m_gkcontext.m_newHandMgr.isVisible())
			{
				var npcID:uint = 0;
				if (m_gkcontext.m_sysnewfeatures.m_nft == SysNewFeatures.NFT_WUJIANGJIHUO)
				{
					//武将激活功能，引导完成后，访问固定NPC
					npcID = 30005;
				}
				else if (m_gkcontext.m_sysnewfeatures.m_nft == SysNewFeatures.NFT_HEROREBIRTH)
				{
					npcID = 1011;
				}
				m_gkcontext.m_newHandMgr.hide();
				
				var hurt:BeingEntity = m_gkcontext.m_npcManager.getBeingByNpcID(npcID);
				var main:PlayerMain = m_gkcontext.m_playerManager.hero;
				if (npcID && hurt && main)
				{
					main.moveToNpcVisitByNpcID(hurt.x, hurt.y, npcID);
				}
			}
		}
		
		public function switchToHero(heroID:uint):void
		{		
			m_allWu.switchToPanel(heroID);
		}
		
		public function showChaifenDlg(callBack:Function, param:Object):void
		{
			if (m_chaifenDlg == null)
			{  
				m_chaifenDlg = new UIChaifenDlg();
				m_gkcontext.m_UIMgr.addForm(m_chaifenDlg);
			}
			m_chaifenDlg.setParam(callBack, param);
			m_chaifenDlg.show();
		}
		override public function getDestPosForHide():Point 
		{
			if (m_gkcontext.m_UIs.sysBtn)
			{
				var btnid:int;
				var pt:Point;
				
				if (m_gkcontext.m_sysbtnMgr.m_bShowPackage)
				{
					btnid = SysbtnMgr.SYSBTN_BeiBao;
				}
				else
				{
					btnid = SysbtnMgr.SYSBTN_WuJiang;
				}
				
				pt = m_gkcontext.m_UIs.sysBtn.getBtnPosInScreenByIdx(btnid);
				
				if (pt)
				{
					pt.x -= 13;
					pt.y -= 17;
					return pt;
				}
			}
			return null;
		}
		private function onShowNewHand():void
		{
			if (m_gkcontext.m_newHandMgr.isVisible())
			{
				m_gkcontext.m_newHandMgr.m_bMoveToNext = true;
				if (m_allWu.wuBtnList && m_allWu.wuBtnList.dicBtn[1190] && (m_gkcontext.m_sysnewfeatures.m_nft == SysNewFeatures.NFT_WUJIANGJIHUO))
				{
					m_gkcontext.m_newHandMgr.setFocusFrame(-12, -10, 154, 57, 1);
					m_gkcontext.m_newHandMgr.prompt(true, 0, 32, "查看马腾属性。", m_allWu.wuBtnList.dicBtn[1190]);
				}
				else if (m_allWu.wuBtnList && m_allWu.wuBtnList.dicBtn[1190] && (m_gkcontext.m_sysnewfeatures.m_nft == SysNewFeatures.NFT_HEROREBIRTH))
				{
					if (1190 == curHeroID)
					{
						m_relationWuPanel.newHnadMoveToCard();
					}
					else
					{
						m_gkcontext.m_newHandMgr.promptOver();
						switchToHero(1190);
					}
				}
				else if (m_allWu.pageTrainBtn && m_gkcontext.m_sysnewfeatures.m_nft == SysNewFeatures.NFT_HEROTRAIN)
				{
					m_gkcontext.m_newHandMgr.setFocusFrame(-8, -8, 80, 44, 1);
					m_gkcontext.m_newHandMgr.prompt(true, 0, 32, "点击打开武将培养分页。", m_allWu.pageTrainBtn);
				}
				else
				{
					m_gkcontext.m_newHandMgr.hide();
				}
			}
		}
		
		private function onBtnClick(event:MouseEvent):void
		{
			var btn:PushButton = event.currentTarget as PushButton;
			if (null == btn)
			{
				return;
			}
			
			switch(btn.tag)
			{
				case 0:
					updateShowXiayeWuPanel();
					break;
				case 1:
					updateShowRelationWuPanel();
					break;
				case 2:
					updateShowPackage();
					break;
			}
		}
		
		//显示下野武将列表
		private function updateShowXiayeWuPanel():void
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
		
		//显示"包裹"
		private function updateShowPackage():void
		{
			if (m_relationWuPanel.bShow)
			{
				m_relationWuPanel.updateShowPos();
			}
			if (m_relationMainWuPanel && m_relationMainWuPanel.bShow)
			{
				m_relationMainWuPanel.updateShowPos();
			}
			
			if (null == m_backPack)
			{
				m_backPack = new BackPack(m_gkcontext, this, m_allWu);
				this.addChildAt(m_backPack, 0);
				m_backPack.setPos(146, 0);
				
				m_backPack.onUIBackPackShow();
			}
			
			m_backPack.updateShowPos();
		}
		
		//显示"关系武将列表"
		private function updateShowRelationWuPanel():void
		{
			if (m_backPack && m_backPack.bShow)
			{
				m_backPack.updateShowPos();
			}
			
			if (WuProperty.MAINHERO_ID == curHeroID)
			{
				m_relationWuPanel.setShowPos(false);
				if (m_relationMainWuPanel)
				{
					m_relationMainWuPanel.updateShowPos();
				}
			}
			else
			{
				if (m_relationMainWuPanel)
				{
					m_relationMainWuPanel.setShowPos(false);
				}
				m_relationWuPanel.updateShowPos();
			}
		}
		
		public function updateRelationWuPanel():void
		{
			m_relationWuPanel.update();
		}
		
		//隐藏下一关系武将列表（即关系武将显示第2列(含)以后）
		public function hideNextRelationWuListByHeroID(heroid:uint):void
		{
			m_relationWuPanel.hideNextRelationWuListByHeroID(heroid);
		}
		
		//"我的三国关系"激活成功
		public function actSuccessUAR(groupid:uint):void
		{
			if (m_relationMainWuPanel)
			{
				m_relationMainWuPanel.actSuccessUAR(groupid);
			}
		}
	}
}