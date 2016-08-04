package game.ui.uibackpack.wujiang
{
	//import adobe.utils.CustomActions;
	import com.bit101.components.Ani;
	import com.bit101.components.ButtonTabText;
	import com.bit101.components.ButtonTextFormat;
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;		
	import com.bit101.components.PanelDraw;
	import com.dgrigg.image.Image;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import modulecommon.appcontrol.PanelDisposeEx;
	import modulecommon.GkContext;
	import com.pblabs.engine.resource.SWFResource;
	import modulecommon.commonfuntion.SysNewFeatures;
	//import modulecommon.res.ResGrid9;
	//import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.wu.WuProperty;
	import modulecommon.scene.prop.object.ZObject;
	//import com.dgrigg.image.PanelImage;
	import game.ui.uibackpack.btnlist.WuBtnList;
	import game.ui.uibackpack.UIBackPack;
	/**
	 * ...
	 * @author zouzhiqiang
	 * 管理所有的WuPanel，每个WuPanel记录每个武将的面板信息，包括装备、属性、培养、训练
	 */
	
	public class AllWuPanel extends Component
	{
		public static const PAGE_EQUIP:int = 0;
		public static const PAGE_ATTR:int = 1;
		public static const PAGE_TRAIN:int = 2;
		public static const PAGE_NUM:int = 3;
		
		private var m_wuBtnList:WuBtnList;	
		private var m_dicPanel:Dictionary;
		private var m_gkContext:GkContext;	
		private var m_wuBG:PanelContainer;
		private var m_wuEquipBG:Panel;
		private var m_vecPageBtn:Vector.<ButtonTabText>;
		private var m_curHeroID:uint;
		private var m_curPage:uint;
		
		private var m_zhuanshengAni:ZhuanshengAni;
		private var m_canEquipAni:Ani;	//当某个装备在鼠标上时，如果某个格子可以接受这个装备，那么会在这个格子上播放这个特效
		
		private var m_equipBgShare:EquipBgShare;
		public var m_wuDecorate:PanelDisposeEx;
		public var m_uibackpack:UIBackPack;
		
		private var m_wuTrainBG:PanelDraw;	//培养界面背景图
		private var m_bCreateTrainBG:Boolean;
		private var m_wuSubAttrBG:PanelDraw;//属性界面背景
		private var m_bCreateAttrBG:Boolean;
		private var m_tianfuPanel:Component;	//武将天赋显示背景相关
		private var m_mainwuPanel:Component;	//主角显示背景相关
		public var m_wuTrainSubBg:PanelDisposeEx;
		
		public function AllWuPanel(parent:DisplayObjectContainer, gk:GkContext)
		{
			m_gkContext = gk;
			super(parent);
			m_uibackpack = parent as UIBackPack;
			m_wuDecorate = new PanelDisposeEx();	
			m_wuDecorate.y = 189;
			m_equipBgShare = new EquipBgShare();
		}
		
		
		override protected function addChildren():void
		{
			m_dicPanel = new Dictionary();
			
			m_wuBG = new PanelContainer(this, 140, 43);
			
			m_wuEquipBG = new Panel(m_wuBG, -1, -1);
			m_wuEquipBG.setSize(258, 446);
			
			m_wuSubAttrBG = new PanelDraw(m_wuBG);
			m_wuSubAttrBG.setSize(257, 445);
			
			m_wuTrainBG = new PanelDraw(m_wuBG, 0, -1);
			m_wuTrainBG.setSize(257, 400);
			
			m_vecPageBtn = new Vector.<ButtonTabText>(PAGE_NUM);
			
			var fomat:ButtonTextFormat = new ButtonTextFormat();
			fomat.m_bold = true;		
			fomat.m_miaobianColor = 0x202020;
			var left:int = 12;
			var interval:int = 64;
			var btn:ButtonTabText = new ButtonTabText(m_wuBG, left, -29, "装备", onPageBtnClick);
			btn.tag = PAGE_EQUIP;
			btn.setParamByFormat(fomat);
			btn.setSize(64, 28);
			btn.setPanelImageSkin("commoncontrol/button/buttonTab8.swf");
			m_vecPageBtn[PAGE_EQUIP] = btn;
			
			left += interval;
			btn = new ButtonTabText(m_wuBG, left, -29, "属性", onPageBtnClick);
			btn.tag = PAGE_ATTR;
			btn.setParamByFormat(fomat);
			btn.setSize(64, 28);
			btn.setPanelImageSkin("commoncontrol/button/buttonTab8.swf");
			m_vecPageBtn[PAGE_ATTR] = btn;
			
			left += interval;
			btn = new ButtonTabText(m_wuBG, left, -29, "培养", onPageBtnClick);
			btn.tag = PAGE_TRAIN;
			btn.setParamByFormat(fomat);
			btn.setSize(64, 28);
			btn.setPanelImageSkin("commoncontrol/button/buttonTab8.swf");
			m_vecPageBtn[PAGE_TRAIN] = btn;
			if (!m_gkContext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_HEROTRAIN))
			{
				m_vecPageBtn[PAGE_TRAIN].visible = false;
			}
		}
		
		protected function onPageBtnClick(e:MouseEvent):void
		{
			if (m_gkContext.m_newHandMgr.isVisible())
			{
				m_gkContext.m_newHandMgr.hide();
			}
			
			var btn:ButtonTabText = e.target as ButtonTabText;
			if (btn != null)
			{
				showSubPanel(btn.tag);				
			}
		}
		//在设置完m_curPage后，调用此函数
		private function onShowSubPanel():void
		{
			if (m_curPage == PAGE_ATTR)
			{
				m_wuEquipBG.visible = false;
				
				if (false == m_bCreateAttrBG)
				{
					createSubAttrBg();
				}
				m_wuSubAttrBG.visible = true;
				
				if (m_wuTrainBG)
				{
					m_wuTrainBG.visible = false;
				}
			}
			else if (m_curPage == PAGE_TRAIN)
			{
				m_wuEquipBG.visible = false;
				
				if (m_wuSubAttrBG)
				{
					m_wuSubAttrBG.visible = false;
				}
				
				if (false == m_bCreateTrainBG)
				{
					createTrainBG();
				}
				m_wuTrainBG.visible = true;
			}
			else
			{
				m_wuEquipBG.visible = true;
				
				if (m_wuSubAttrBG)
				{
					m_wuSubAttrBG.visible = false;
				}
				
				if (m_wuTrainBG)
				{
					m_wuTrainBG.visible = false;
				}
			}
			
			if (m_zhuanshengAni)
			{
				if (m_curPage == PAGE_ATTR)
				{
					m_zhuanshengAni.onAddToAttrPage();
				}
				//else if (m_curPage == PAGE_EQUIP)
				//{
				//	m_zhuanshengAni.onAddToEquipPage();
				//}
			}
		}
		private function showSubPanel(subPageID:uint):void
		{
			m_curPage = subPageID;	
			onShowSubPanel();
			
			var panel:WuPanel = m_dicPanel[m_curHeroID] as WuPanel;
			if (panel)
			{
				panel.showSubPanel(subPageID);
			}
		}
		public function addPanel(heroID:uint):void
		{
			if (m_dicPanel[heroID] == undefined)
			{
				var panel:WuPanel = new WuPanel(this, m_wuBG, m_gkContext, heroID);
				
				m_dicPanel[heroID] = panel;
			}
		}
		
		public function addWu(heroID:uint):void
		{
			addPanel(heroID);
			m_wuBtnList.addWu(heroID);
			updateCurWu();
		}
		
		public function removeWu(heroID:uint):void
		{
			m_wuBtnList.removeWu(heroID);		
			if (m_dicPanel[heroID] != undefined)
			{
				var wuPanel:WuPanel = m_dicPanel[heroID];
				if (wuPanel.parent)
				{
					wuPanel.parent.removeChild(wuPanel);
				}
				wuPanel.dispose();
				delete m_dicPanel[heroID];
			}
			
			if (m_curHeroID == heroID)
			{
				showPanel(m_wuBtnList.defaultShowHeroID);
				m_wuBtnList.setSelected(m_wuBtnList.defaultShowHeroID);
			}			
		}
		
		//由程序在外部主动调用此函数
		public function switchToPanel(heroID:uint):void
		{
			if (m_curHeroID != heroID)
			{
				if (m_wuBtnList.setSelected(heroID))
				{
					showPanel(heroID);
				}
			}
		}
		
		public function showPanel(heroID:uint):void
		{			
			var panel:WuPanel;
			m_curHeroID = heroID;
			
			updateShowWuEquipBG();
			
			if (m_dicPanel[heroID] == undefined)
			{
				addPanel(heroID);
			}
			
			for each(var item:* in m_dicPanel)
			{
				panel = item as WuPanel;
				if (panel.heroID == heroID)
				{
					panel.show(m_curPage);					
				}
				else
				{
					panel.hide();				
				}
			}
		}
		
		public function initData():void
		{			
			m_curPage = PAGE_EQUIP;			
			m_vecPageBtn[PAGE_EQUIP].selected = true;
			showPanel(m_wuBtnList.defaultShowHeroID);	
			onShowSubPanel();
		}
		
		public function selectShowPage(pageid:int = PAGE_EQUIP):void
		{
			if (SysNewFeatures.NFT_HEROTRAIN == m_gkContext.m_sysnewfeatures.m_nft && !m_vecPageBtn[PAGE_TRAIN].isVisible())
			{
				m_vecPageBtn[PAGE_TRAIN].visible = true;
			}
			m_vecPageBtn[pageid].selected = true;
			showSubPanel(pageid);
			onShowSubPanel();
		}
		
		public function updateHero(id:uint):void
		{
			var panel:WuPanel = m_dicPanel[id] as WuPanel;
			if (panel != null)
			{
				panel.update();
			}
		}
		public function addObject(obj:ZObject):void
		{
			var panel:WuPanel = m_dicPanel[obj.m_object.m_loation.heroid] as WuPanel;
			if (panel == null)
			{
				return;
			}
			panel.addObject(obj);
		}
		public function removeObject(obj:ZObject):void
		{
			var panel:WuPanel = m_dicPanel[obj.m_object.m_loation.heroid] as WuPanel;
			if (panel == null)
			{
				return;
			}
			panel.removeObject(obj);			
		}
		public function updateObject(obj:ZObject):void
		{
			var panel:WuPanel = m_dicPanel[obj.m_object.m_loation.heroid] as WuPanel;			
			
			if (panel)
			{
				panel.updateObject(obj);
			}
		}
		
		//武将数量变化
		public function onWuNumChange(heroid:int):void
		{
			m_wuBtnList.onWuNumChange(heroid);
			this.updateHero(heroid);
		}
		
		public function generateBtnList():void
		{
			m_wuBtnList.generateBtnList();
		}
		public function createImage(res:SWFResource):void
		{
			m_wuBG.setPanelImageSkinMirror("commoncontrol/panel/backpack/framebg.png", Image.MirrorMode_LR);
			
			m_wuEquipBG.setPanelImageSkin("commoncontrol/panel/backpack/wuEquipBG.png");
			m_wuDecorate.setPanelImageSkinBySWF(res, "backpage.expbg");
			m_wuBtnList = new WuBtnList(this, m_gkContext, this, m_uibackpack);
			m_wuBtnList.x = 0;
			m_wuBtnList.y = 30;
			m_wuBtnList.m_xiayewuList = m_uibackpack.xiayeWuList;
			m_wuBtnList.initData(res);
			initData();
		}
		
		override public function dispose():void 
		{
			m_equipBgShare.disposAll();
			m_wuDecorate.disposeEx();
			if (m_wuTrainSubBg)
			{
				m_wuTrainSubBg.disposeEx();
			}
			if (m_zhuanshengAni)
			{
				m_zhuanshengAni.dispose();
			}
			var panel:WuPanel;
			for each(panel in m_dicPanel)
			{
				if (m_wuBG.contains(panel) == false)
				{
					panel.dispose();
				}
			}
			super.dispose();
		}
		public function get curHeroID():uint
		{
			return m_curHeroID;
		}
		
		public function updateCurWu():void
		{
			var panel:WuPanel = m_dicPanel[m_curHeroID] as WuPanel;
			if (panel)
			{
				panel.update();
			}
		}
		public function get zhuanshengAni():ZhuanshengAni
		{
			if (m_zhuanshengAni == null)
			{
				m_zhuanshengAni = new ZhuanshengAni(m_gkContext.m_context);
				if (m_curPage == PAGE_ATTR)
				{
					m_zhuanshengAni.onAddToAttrPage();
				}
				//else if (m_curPage == PAGE_EQUIP)
				//{
				//	m_zhuanshengAni.onAddToEquipPage();
				//}
			}
			return m_zhuanshengAni;
		}
		
		public function showEquipAni(p:DisplayObjectContainer, posX:Number, posY:Number):void
		{
			if (m_canEquipAni == null)
			{
				m_canEquipAni = new Ani(m_gkContext.m_context);
				m_canEquipAni.setImageAni("ejzhuangbeixuanzhong.swf");
				m_canEquipAni.duration = 1;
				m_canEquipAni.centerPlay = true;
				m_canEquipAni.repeatCount = 0;		
				m_canEquipAni.mouseEnabled = false;
			}
			m_canEquipAni.x = posX + 23;
			m_canEquipAni.y = posY + 23;
			if (m_canEquipAni.parent != p)
			{
				p.addChild(m_canEquipAni);
			}
			m_canEquipAni.begin();
		}
		public function hideEquipAni(p:DisplayObjectContainer):void
		{
			if (m_canEquipAni == null)
			{
				return;
			}
			if (m_canEquipAni.parent == p)
			{
				p.removeChild(m_canEquipAni);
			}
			m_canEquipAni.stop();
		}
		
		public function onEquipDrag(obj:ZObject):void
		{
			var panel:WuPanel = m_dicPanel[m_curHeroID] as WuPanel;
			if (panel == null)
			{
				return;
			}
			panel.onEquipDrag(obj);						
		}
		public function onEquipDrop(obj:ZObject):void
		{
			var panel:WuPanel = m_dicPanel[m_curHeroID] as WuPanel;
			if (panel == null)
			{
				return;
			}
			panel.onEquipDrop(obj);					
		}
		public function onUIBackPackHide():void
		{
			if (m_zhuanshengAni)
			{
				m_zhuanshengAni.onUIBackPackHide();
			}
		}
		public function onUIBackPackShow():void
		{
			if (m_zhuanshengAni)
			{
				m_zhuanshengAni.onUIBackPackShow();
			}
			var panel:WuPanel = m_dicPanel[m_curHeroID] as WuPanel;
			if (panel)
			{
				panel.onUIBackPackShow();
			}
		}
		public function get wuBtnList():WuBtnList
		{
			return m_wuBtnList;
		}
		public function get equipBgShare():EquipBgShare
		{
			return m_equipBgShare;
		}
		
		//显示武将装备分页背景
		private function updateShowWuEquipBG():void
		{
			if (WuProperty.MAINHERO_ID == curHeroID)
			{
				if (m_tianfuPanel)
				{
					m_tianfuPanel.visible = false;
				}
				
				var panel:Panel;
				if (null == m_mainwuPanel)
				{
					m_mainwuPanel = new Component(m_wuEquipBG, 0, 380);
					
					panel = new Panel(m_mainwuPanel, 5, 2);
					panel.setPanelImageSkin("commoncontrol/panel/pattern.png");
					
					panel = new Panel(m_mainwuPanel, 83, -15);
					panel.setPanelImageSkin("commoncontrol/panel/backpack/te.png");
					
					panel = new Panel(m_mainwuPanel, 162, 2);
					panel.setPanelImageSkinMirror("commoncontrol/panel/pattern.png", Image.MirrorMode_HOR);
				}
				m_mainwuPanel.visible = true;
			}
			else
			{
				if (m_mainwuPanel)
				{
					m_mainwuPanel.visible = false;
				}
				
				if (null == m_tianfuPanel)
				{
					m_tianfuPanel = new Component(m_wuEquipBG, 0, 380);
					
					panel = new Panel(m_tianfuPanel, 0, 5);
					panel.autoSizeByImage = false;
					panel.setSize(258, 39);
					panel.setPanelImageSkinMirror("commoncontrol/panel/glodflightsmall.png", Image.MirrorMode_LR);
					
					panel = new Panel(m_tianfuPanel, 8, 18);
					panel.setPanelImageSkin("commoncontrol/panel/backpack/tianfujihuo.png");
				}
				m_tianfuPanel.visible = true;
			}
		}
		
		//创建培养界面背景图及各武将共用资源
		private function createTrainBG():void
		{
			var panel:Panel;
			panel = new Panel();
			m_wuTrainBG.addDrawCom(panel);
			panel.setSize(m_wuTrainBG.width, m_wuTrainBG.height);
			panel.setSkinImagePinjie("commoncontrol/panel/wallbg.png");
			
			panel = new Panel();
			m_wuTrainBG.addDrawCom(panel);
			panel.setSize(m_wuTrainBG.width, m_wuTrainBG.height);
			panel.setSkinGrid9Image9("commoncontrol/grid9/grid9StyleEight.swf");
			
			m_wuTrainBG.drawPanel();
			
			m_wuTrainSubBg = new PanelDisposeEx();
			m_wuTrainSubBg.setPos(1, 245);
			m_wuTrainSubBg.setPanelImageSkinMirror("commoncontrol/panel/backpack/train/subBack.png", Image.MirrorMode_LR);
			
			panel = new Panel(m_wuTrainSubBg, 5, 36);
			panel.setPanelImageSkin("commoncontrol/panel/backpack/train/grid.png");
			
			m_bCreateTrainBG = true;
		}
		
		//创建属性界面背景共用资源
		private function createSubAttrBg():void
		{
			var panel:Panel;
			panel = new Panel(null, 20, 3);
			panel.autoSizeByImage = false;
			panel.setSize(216, 2);
			panel.setPanelImageSkin("commoncontrol/panel/segment.png");
			m_wuSubAttrBG.addDrawCom(panel);
			
			panel = new Panel(null, 18, 3);
			panel.autoSizeByImage = false;
			panel.setSize(210, 39);
			panel.setPanelImageSkinMirror("commoncontrol/panel/glodflightlong.png", Image.MirrorMode_LR);
			m_wuSubAttrBG.addDrawCom(panel);
			
			panel = new Panel(null, 5, 110);
			panel.autoSizeByImage = false;
			panel.setSize(246, 2);
			panel.setPanelImageSkin("commoncontrol/panel/segment.png");
			m_wuSubAttrBG.addDrawCom(panel);
			
			panel = new Panel(null, 0, 110);
			panel.setPanelImageSkinMirror("commoncontrol/panel/glodflightlong.png", Image.MirrorMode_LR);
			m_wuSubAttrBG.addDrawCom(panel);
			
			panel = new Panel(null, 5, 176);
			panel.autoSizeByImage = false;
			panel.setSize(246, 2);
			panel.setPanelImageSkin("commoncontrol/panel/segment.png");
			m_wuSubAttrBG.addDrawCom(panel);
			
			panel = new Panel(null, 0, 176);
			panel.setPanelImageSkinMirror("commoncontrol/panel/glodflightlong.png", Image.MirrorMode_LR);
			m_wuSubAttrBG.addDrawCom(panel);
			
			panel = new Panel(null, 11, 280);
			panel.setPanelImageSkin("backpage.guanxi");
			m_wuSubAttrBG.addDrawCom(panel);
			
			panel = new Panel(null, 4, 381);
			panel.setPanelImageSkin("commoncontrol/panel/pattern.png");
			m_wuSubAttrBG.addDrawCom(panel);
			
			panel = new Panel(null, 161, 381);
			panel.setPanelImageSkinMirror("commoncontrol/panel/pattern.png", Image.MirrorMode_HOR);
			m_wuSubAttrBG.addDrawCom(panel);
			
			m_wuSubAttrBG.drawPanel();
			
			m_bCreateAttrBG = true;
		}
		
		public function updateTrainDatas(heroid:uint = 0):void
		{
			if (0 == heroid)
			{
				heroid = m_curHeroID;
			}
			
			var panel:WuPanel = m_dicPanel[heroid] as WuPanel;
			if (m_wuTrainBG && m_wuTrainBG.isVisible() && panel)
			{
				panel.updateTraniDatas();
			}
		}
		
		public function updateZhanshu():void
		{
			var panel:WuPanel = m_dicPanel[WuProperty.MAINHERO_ID] as WuPanel;
			if (panel)
			{
				panel.updateZhanshu();
			}
		}
		
		public function get pageTrainBtn():ButtonTabText
		{
			if (m_vecPageBtn[PAGE_TRAIN].isVisible())
			{
				return m_vecPageBtn[PAGE_TRAIN];
			}
			else
			{
				return null;
			}
		}
	}

}