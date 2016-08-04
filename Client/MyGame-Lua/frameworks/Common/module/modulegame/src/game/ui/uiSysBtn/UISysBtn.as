package game.ui.uiSysBtn
{
	import com.ani.AniPosition;
	import com.bit101.components.Ani;
	import com.bit101.components.ButtonAni;
	import modulecommon.scene.beings.MountsSys;
	import modulecommon.scene.beings.PlayerMain;
	import modulecommon.uiinterface.IUIBackPack;
	import modulecommon.uiinterface.IUIMountsSys;
	//import com.bit101.components.ButtonText;
	import com.bit101.components.Component;
	//import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.PushButton;
	import com.bit101.components.progressBar.BarInProgress2;
	//import com.bit101.components.progressBar.ProgressBar;
	import com.dgrigg.image.CommonImageManager;
	//import com.dgrigg.skins.PanelImageSkin;
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.SWFResource;
	import modulecommon.scene.sysbtn.SysbtnMgr;
	
	//import flash.display.Sprite;
	//import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import modulecommon.commonfuntion.SysNewFeatures;
	//import modulecommon.net.msg.copyUserCmd.stReqAvailableCopyUserCmd;
	//import modulecommon.net.msg.mailCmd.stReqMailListCmd;
	//import modulecommon.scene.beings.PlayerMain;
	import modulecommon.scene.wu.WuMainProperty;
	//import com.util.UtilTools;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUiSysBtn;
	import modulecommon.scene.tongquetai.TongQueTaiMgr;
	//import modulecommon.net.msg.zhanXingCmd.stLocation;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class UISysBtn extends Form implements IUiSysBtn
	{
		private static const WIDTH:int = 669;
		private static const HEIGHT:int = 109;
		
		private var m_vecBtn:Vector.<ButtonAni>;
		private var m_dicBtnConfig:Dictionary;
		private var m_curSwfRes:SWFResource;
		private var m_expFormPanel:PanelContainer;
		private var m_expBar:BarInProgress2;
		private var m_btnAniVec:Vector.<AniPosition>;
		private var m_exp:uint;
		private var m_expTotal:uint;
		private var m_expTotalOld:uint;
		private var m_latticeVec:Vector.<Panel>;
		private var m_dicEffectAni:Dictionary;
		private var m_addNewBtnId:int;
		
		public function UISysBtn():void
		{
			m_dicBtnConfig = new Dictionary();
			m_dicEffectAni = new Dictionary();
		}
		
		public static function IMAGESWF():String
		{
			return CommonImageManager.toPathString("module/uisysbtn.swf");
		}
		
		override public function onReady():void
		{
			super.onReady();
			this.alignHorizontal = Component.RIGHT;
			this.alignVertial = Component.BOTTOM;
			this.marginRight = 2;
			this.marginBottom = -1;
			
			this.setSize(WIDTH, HEIGHT);
			m_expFormPanel = new PanelContainer(this, 90, 86);
			m_expFormPanel.setSize(450, 16);
			m_expFormPanel.autoSizeByImage = false;
			m_expFormPanel.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOverExpBar);
			m_expFormPanel.addEventListener(MouseEvent.ROLL_OUT, m_gkcontext.hideTipOnMouseOut);
			
			m_expBar = new BarInProgress2(m_expFormPanel, 2, 2);
			
			m_latticeVec = new Vector.<Panel>(5);
			var i:int;
			var interval:int = 450 / 6;
			for (i = 0; i < 5; i++)
			{
				m_latticeVec[i] = new Panel(m_expFormPanel, interval * (i + 1), 1);
			}
			
			m_btnAniVec = new Vector.<AniPosition>();
			
			m_dicBtnConfig[SysbtnMgr.SYSBTN_Marekt] = new SysBtnConfig("marketbtn");
			m_dicBtnConfig[SysbtnMgr.SYSBTN_WuJiang] = new SysBtnConfig("wujiangbtn");//显示与角色头像一致
			m_dicBtnConfig[SysbtnMgr.SYSBTN_BeiBao] = new SysBtnConfig("beibaobtn");
			
			if (m_gkcontext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_JUNTUAN))
			{
				m_dicBtnConfig[SysbtnMgr.SYSBTN_JunTuan] = new SysBtnConfig("juntuanbtn");
			}
			if (m_gkcontext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_DAZAO))
			{
				m_dicBtnConfig[SysbtnMgr.SYSBTN_DuanZao] = new SysBtnConfig("duanzaobtn");
			}
			if (m_gkcontext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_ZHENFA))
			{
				m_dicBtnConfig[SysbtnMgr.SYSBTN_ZhenXing] = new SysBtnConfig("zhenxingbtn");
			}
			if (m_gkcontext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_DAZUO))
			{
				m_dicBtnConfig[SysbtnMgr.SYSBTN_DaZuo] = new SysBtnConfig("dazuobtn");
			}
			if (m_gkcontext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_HEROXIAYE))
			{
				m_dicBtnConfig[SysbtnMgr.SYSBTN_WuXiaye] = new SysBtnConfig("wujiangbtn");
			}
			if (m_gkcontext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_ZHANXING))
			{
				m_dicBtnConfig[SysbtnMgr.SYSBTN_ZhanXing] = new SysBtnConfig("wuxuebtn");
			}
			if (m_gkcontext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_TONGQUETAI))
			{
				m_dicBtnConfig[SysbtnMgr.SYSBTN_TongqueTai] = new SysBtnConfig("tongquetaibtn");
			}
			if (m_gkcontext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_MOUNT))
			{
				m_dicBtnConfig[SysbtnMgr.SYSBTN_Mounts] = new SysBtnConfig("mountsbtn");
			}
			
			m_gkcontext.m_context.m_resMgr.load(UISysBtn.IMAGESWF(), SWFResource, onImageSwfLoaded, onImageSwfFailed);
			this.draggable = false;
			
		}
		
		private function onFunClick(event:MouseEvent):void
		{
			var form:IUIBackPack = m_gkcontext.m_UIMgr.getForm(UIFormID.UIBackPack) as IUIBackPack;
			
			switch (event.target)
			{
				case m_vecBtn[SysbtnMgr.SYSBTN_WuJiang]:
				{
					if (m_gkcontext.m_newHandMgr.isVisible())
					{
						m_gkcontext.m_newHandMgr.promptOver();
					}
					
					var formPack:Form = m_gkcontext.m_UIMgr.getForm(UIFormID.UIBackPack);
					if (formPack && formPack.isVisible())
					{						
						if (m_gkcontext.m_sysbtnMgr.m_bShowPackage)
						{
							m_gkcontext.m_sysbtnMgr.m_bShowPackage = false;
							if (form)
							{
								form.onShowRelationWuPanel();
								form.onShowPackage();
							}
						}
						else
						{
							formPack.exit();							
						}
					}
					else
					{
						if (formPack)
						{
							formPack.show();
						}
						else
						{
							m_gkcontext.m_UIMgr.createFormInGame(UIFormID.UIBackPack);
						}
					}
					break;
				}
				case m_vecBtn[SysbtnMgr.SYSBTN_BeiBao]: 
				{
					if (m_gkcontext.m_UIMgr.isFormVisible(UIFormID.UIBackPack))
					{
						if (m_gkcontext.m_sysbtnMgr.m_bShowPackage)
						{
							m_gkcontext.m_UIMgr.exitForm(UIFormID.UIBackPack);
						}
						else
						{
							m_gkcontext.m_sysbtnMgr.m_bShowPackage = true;
							if (form)
							{
								form.onShowPackage();
							}
						}
					}
					else
					{
						m_gkcontext.m_sysbtnMgr.m_bShowPackage = true;
						
						var formbeibao:Form = m_gkcontext.m_UIMgr.getForm(UIFormID.UIBackPack);
						if (formbeibao)
						{
							formbeibao.show();
						}
						else
						{
							m_gkcontext.m_UIMgr.createFormInGame(UIFormID.UIBackPack);
						}
					}
					break;
				}
				case m_vecBtn[SysbtnMgr.SYSBTN_ZhenXing]: 
				{
					if (m_gkcontext.m_newHandMgr.isVisible())
					{
						m_gkcontext.m_newHandMgr.promptOver();
					}
					
					if (m_gkcontext.m_UIMgr.isFormVisible(UIFormID.UIZhenfa) == true)
					{
						m_gkcontext.m_UIMgr.exitForm(UIFormID.UIZhenfa);
					}
					else
					{						
						m_gkcontext.m_UIMgr.showFormWidthProgress(UIFormID.UIZhenfa);						
					}
					break;
				}
				case m_vecBtn[SysbtnMgr.SYSBTN_JunTuan]: 
				{
					if (m_gkcontext.m_newHandMgr.isVisible())
					{
						m_gkcontext.m_newHandMgr.hide();
					}
					
					if (m_gkcontext.m_corpsMgr.hasCorps)
					{
						if (m_gkcontext.m_corpsMgr.m_ui && m_gkcontext.m_corpsMgr.m_ui.isVisible())
						{
							m_gkcontext.m_corpsMgr.m_ui.exit();
						}
						else
						{
							m_gkcontext.m_corpsMgr.openPage();
						}
					}
					else
					{
						if (m_gkcontext.m_UIMgr.isFormVisible(UIFormID.UICorpsLst) == true)
						{
							m_gkcontext.m_UIMgr.exitForm(UIFormID.UICorpsLst);
						}
						else
						{
							m_gkcontext.m_UIMgr.showFormEx(UIFormID.UICorpsLst);							
						}
					}
					break;
				}
				case m_vecBtn[SysbtnMgr.SYSBTN_DuanZao]: 
				{
					if (m_gkcontext.m_newHandMgr.isVisible())
					{
						m_gkcontext.m_newHandMgr.promptOver();
					}
					
					if (m_gkcontext.m_UIMgr.isFormVisible(UIFormID.UIEquipSys) == true)
					{
						m_gkcontext.m_UIMgr.exitForm(UIFormID.UIEquipSys);
					}
					else
					{
						m_gkcontext.m_UIMgr.showFormEx(UIFormID.UIEquipSys);
					}
					break;
				}
				case m_vecBtn[SysbtnMgr.SYSBTN_DaZuo]: 
				{
					if (m_gkcontext.m_newHandMgr.isVisible())
					{
						m_gkcontext.m_newHandMgr.hide();
					}
					
					//特定场景不允许打坐修炼
					if (false == m_gkcontext.m_dazuoMgr.isCanDaZuo)
					{
						m_gkcontext.m_systemPrompt.prompt("当前场景无法进行打坐修炼");
						return;
					}
					
					m_gkcontext.m_dazuoMgr.updateStateOfDaZuo();
					break;
				}
				case m_vecBtn[SysbtnMgr.SYSBTN_WuXiaye]:
				{
					if (m_gkcontext.m_newHandMgr.isVisible())
					{
						m_gkcontext.m_newHandMgr.hide();
					}
					
					if (m_gkcontext.m_UIMgr.isFormVisible(UIFormID.UIWuXiaye) == true)
					{
						m_gkcontext.m_UIMgr.exitForm(UIFormID.UIWuXiaye);
					}
					else
					{
						m_gkcontext.m_UIMgr.showFormEx(UIFormID.UIWuXiaye);
					}
					break;
				}
				case m_vecBtn[SysbtnMgr.SYSBTN_Marekt]: 
				{
					if (m_gkcontext.m_marketMgr.isUIMarketVisible())
					{
						m_gkcontext.m_marketMgr.closeUIMarket();
					}
					else
					{
						m_gkcontext.m_marketMgr.openUIMarket();
					}
					break;
				}
				case m_vecBtn[SysbtnMgr.SYSBTN_ZhanXing]: 
				{
					if (m_gkcontext.m_newHandMgr.isVisible())
					{
						m_gkcontext.m_newHandMgr.hide();
					}
					
					if (m_gkcontext.m_UIMgr.isFormVisible(UIFormID.UIZhanxing))
					{
						m_gkcontext.m_UIMgr.exitForm(UIFormID.UIZhanxing);
					}
					else
					{
						m_gkcontext.m_UIMgr.showFormEx(UIFormID.UIZhanxing);
					}
					
					break;
				}
				case m_vecBtn[SysbtnMgr.SYSBTN_Mounts]: 
				{
					if (m_gkcontext.m_newHandMgr.isVisible())
					{
						m_gkcontext.m_newHandMgr.promptOver();
					}
					
					var mountssys:IUIMountsSys = m_gkcontext.m_UIMgr.getForm(UIFormID.UIMountsSys) as IUIMountsSys;
					var uimounts:Form;
					var uishouhun:Form;
					//if (mountssys)
					//{
					//	mountssys.exit();
					//}
					//else
					if (!mountssys)
					{
						m_gkcontext.m_mountsSysLogic.btnClkLoadModuleMode = true;
						m_gkcontext.m_UIMgr.loadForm(UIFormID.UIMountsSys);
					}
					else if(mountssys && mountssys.isResReady())
					{
						uimounts = m_gkcontext.m_UIMgr.getForm(UIFormID.UIMounts);
						uishouhun = m_gkcontext.m_UIMgr.getForm(UIFormID.UIShouHun);
						if (!uimounts && !uishouhun)
						{
							mountssys.showCCSUI(UIFormID.UIMounts);
						}
						else
						{
							if(uimounts)
							{
								uimounts.exit();
							}
							if(uishouhun)
							{
								uishouhun.exit();
							}
						}
					}
					break;
				}
				case m_vecBtn[SysbtnMgr.SYSBTN_TongqueTai]:
				{
					if (m_gkcontext.m_newHandMgr.isVisible())
					{
						m_gkcontext.m_newHandMgr.promptOver();
					}
					
					/*if (m_gkcontext.m_UIMgr.isFormVisible(UIFormID.UITongQueTai))
					{
						m_gkcontext.m_UIMgr.exitForm(UIFormID.UITongQueTai);
					}
					else */
					if (m_gkcontext.m_UIMgr.isFormVisible(UIFormID.UITongQueWuHui))
					{
						m_gkcontext.m_UIMgr.exitForm(UIFormID.UITongQueWuHui);
					}
					else
					{
						var formTong:Form = m_gkcontext.m_UIMgr.createFormInGame(UIFormID.UITongQueWuHui);
						formTong.show();
					}
					break;
				}
			}
		}
		
		private function onImageSwfLoaded(event:ResourceEvent):void
		{
			var resource:SWFResource = event.resourceObject as SWFResource;
			createImage(resource);
			m_gkcontext.m_context.m_resMgr.unload(UISysBtn.IMAGESWF(), SWFResource);
		}
		
		private function createImage(resource:SWFResource):void
		{
			m_curSwfRes = resource;
			this.setPanelImageSkinBySWF(m_curSwfRes, "uisysbtn.back");
			m_expFormPanel.setHorizontalImageSkinBySWF(m_curSwfRes, "uisysbtn.expform");
			
			m_expBar.setSize(446, 12);
			m_expBar.autoSizeByImage = false;
			m_expBar.setPanelImageSkinBySWF(m_curSwfRes, "uisysbtn.exp");
			m_expBar.maximum = 1;
			m_expBar.initValue = 0;
			
			for (var i:int = 0; i < m_latticeVec.length; i++)
			{
				m_latticeVec[i].setPanelImageSkinBySWF(m_curSwfRes, "uisysbtn.lattice");
			}
			
			updateExpCount();
			
			m_vecBtn = new Vector.<ButtonAni>(SysbtnMgr.SYSBTN_Count);
			updateCreateBtn();
			
			if (m_gkcontext.m_zhanxingMgr.getAllFree() != 0)
			{			
				showEffectAni(SysbtnMgr.SYSBTN_ZhanXing);
			}
			
			if (m_gkcontext.m_tongquetaiMgr.getTimeup())
			{
				showEffectAni(SysbtnMgr.SYSBTN_TongqueTai);	
			}
			
			var playermain:PlayerMain = m_gkcontext.m_playerManager.hero;
			if (playermain && (playermain.horseSys as MountsSys).mountsAttr.times < 3)
			{
				showEffectAni(SysbtnMgr.SYSBTN_Mounts);
			}
			
			this.m_gkcontext.m_UIs.sysBtn = this;
		}
		
		public function getWuJiangPosInScreen():Point
		{
			if (null == m_vecBtn)
			{
				return null;
			}
			var btn:ButtonAni = m_vecBtn[SysbtnMgr.SYSBTN_WuJiang];
			return btn.localToScreen(new Point(btn.width / 2, btn.height / 2));
		}
		
		public function getBtnPosInScreenByIdx(idx:uint):Point
		{
			if (null == m_vecBtn)
			{
				return null;
			}
			var btn:ButtonAni = m_vecBtn[idx];
			if (btn == null)
			{
				return null;
			}
			return btn.localToScreen(new Point(btn.width / 2, btn.height / 2));
		}
		
		public function updateCreateBtn():void
		{
			var resname:String = "";
			var btn:ButtonAni;
			for (var i:int = 0; i < SysbtnMgr.SYSBTN_Count; i++)
			{
				btn = m_vecBtn[i];
				
				if (m_dicBtnConfig[i] && (null == btn))
				{
					btn = new ButtonAni(this, 0, 0, onFunClick);
					btn.m_musicType = PushButton.BNMOpen;
					btn.setSize(56, 81);
					if (SysbtnMgr.SYSBTN_Marekt != i)
					{
						btn.moveAniDirection = ButtonAni.DIRECTION_UP;
					}
					else
					{
						btn.beginLiuguang();
					}
					
					if ((SysbtnMgr.SYSBTN_WuJiang == i) && m_gkcontext.playerMain)
					{
						resname = "sysbtnhead/" + m_gkcontext.m_context.m_playerResMgr.uiName(m_gkcontext.playerMain.job, m_gkcontext.playerMain.gender) + ".png";
					}
					else
					{
						resname = "commoncontrol/panel/sysbtn/" + (m_dicBtnConfig[i] as SysBtnConfig).m_resName + ".png";
					}
					btn.setSkinButton1Image(resname);
					
					m_vecBtn[i] = btn;
				}
			}
			
			updateJustPos();
		}
		
		public function addNewFeature(type:uint, btn:ButtonAni = null):void
		{
			if (null == btn)
			{
				return;
			}
			
			var id:int = SysbtnMgr.getBtnId(type);
			if (!m_dicBtnConfig[id] && m_gkcontext.m_sysnewfeatures.isSet(type))
			{
				if (id == SysbtnMgr.SYSBTN_DuanZao)
				{
					m_dicBtnConfig[id] = new SysBtnConfig("duanzaobtn");
				}
				else if (id == SysbtnMgr.SYSBTN_ZhenXing)
				{
					m_dicBtnConfig[id] = new SysBtnConfig("zhenxingbtn");
				}
				else if (id == SysbtnMgr.SYSBTN_DaZuo)
				{
					m_dicBtnConfig[id] = new SysBtnConfig("dazuobtn");
				}
				else if (id == SysbtnMgr.SYSBTN_WuXiaye)
				{
					m_dicBtnConfig[id] = new SysBtnConfig("wujiangbtn");
				}
				else if (id == SysbtnMgr.SYSBTN_JunTuan)
				{
					m_dicBtnConfig[id] = new SysBtnConfig("juntuanbtn");
				}
				else if (id == SysbtnMgr.SYSBTN_ZhanXing)
				{
					m_dicBtnConfig[id] = new SysBtnConfig("wuxuebtn");
				}
				else if (id == SysbtnMgr.SYSBTN_TongqueTai)
				{
					m_dicBtnConfig[id] = new SysBtnConfig("tongquetaibtn");
				}
				else if (id == SysbtnMgr.SYSBTN_Mounts)
				{
					m_dicBtnConfig[id] = new SysBtnConfig("mountsbtn");
				}
			}
			
			updateCreateBtn();
		}
		
		private function updateJustPos():void
		{
			var top:int = 8;
			var right:int = 480;
			var interval:int = 60;
			
			if (m_dicBtnConfig[0])
			{
				m_vecBtn[0].setPos(561, 39);
			}
			
			for (var i:int = 1; i < SysbtnMgr.SYSBTN_Count; i++)
			{
				if (m_dicBtnConfig[i] && m_vecBtn[i])
				{
					m_vecBtn[i].setPos(right, top);
					right -= interval;
				}
			}
		}
		
		override public function dispose():void
		{
			m_dicBtnConfig = null;
			this.m_gkcontext.m_UIs.sysBtn = null;
			
			for each(var ani:Ani in m_dicEffectAni)
			{
				if (ani)
				{
					if (ani.parent)
					{
						ani.parent.removeChild(ani);
					}
					ani.dispose();
				}
			}
			m_dicEffectAni = null;
			
			super.dispose();
		}
		
		//经验条显示更新
		public function updateExpCount():void
		{
			var wu:WuMainProperty = this.m_gkcontext.m_wuMgr.getMainWu();
			if (wu)
			{
				m_exp = wu.m_uExp;
				m_expTotal = wu.m_uExpTotal;
				m_expTotal = m_exp > m_expTotal ? m_exp : m_expTotal;
				
				if (m_expTotalOld && m_expTotal > m_expTotalOld)
				{
					m_expBar.setAniEndCallBack(updateExpToNextLevel);
					m_expBar.value = 1;
				}
				else
				{
					m_expBar.setAniEndCallBack(null);
					if (m_expBar.value)
					{
						m_expBar.value = m_exp / m_expTotal;
					}
					else
					{
						m_expBar.initValue = m_exp / m_expTotal;
					}
				}
				m_expTotalOld = m_expTotal;
			}
		}
		
		private function updateExpToNextLevel():void
		{
			var wu:WuMainProperty = this.m_gkcontext.m_wuMgr.getMainWu();
			m_expBar.initValue = 0;
			m_expBar.value = wu.m_uExp / wu.m_uExpTotal;
			m_expBar.setAniEndCallBack(null)
		}
		
		public function getButton(type:uint):ButtonAni
		{
			var id:int = SysbtnMgr.getBtnId(type);
			if (m_dicBtnConfig[id] && m_vecBtn[id])
			{
				return m_vecBtn[id];
			}
			else
			{
				return null;
			}
		}
		
		//获得新加功能按钮在屏幕中的显示位置，如果该按钮已存在，则返回该按钮在屏幕中的位置
		public function getButtonPosInScreen(type:uint):Point
		{
			var newbtnid:int = SysbtnMgr.getBtnId(type);
			var pt:Point = this.localToScreen();
			var count:int = 0;
			for (var i:int = 1; i < SysbtnMgr.SYSBTN_Count; i++)
			{
				if (m_vecBtn[i] && (i < newbtnid))
				{
					count++;
				}
				if (m_vecBtn[i] && (i == newbtnid))
				{
					return m_vecBtn[i].localToScreen();
				}
			}
			pt.x = pt.x + 480 - count * 60;
			pt.y += 8;
			
			return pt;
		}
		
		//如果按钮是在新加按钮左边，则向左移动
		public function vacateRoomForButton(type:uint):void
		{
			var m_addNewBtnId:int = SysbtnMgr.getBtnId(type);
			var btnAni:AniPosition;
			m_btnAniVec.length = 0;
			for (var i:int = SysbtnMgr.SYSBTN_Count - 1; i > 0; i--)
			{
				if (m_vecBtn[i] && (i > m_addNewBtnId))
				{
					btnAni = new AniPosition();
					btnAni.sprite = m_vecBtn[i];
					btnAni.duration = 0.6;
					btnAni.setBeginPos(m_vecBtn[i].x, m_vecBtn[i].y);
					btnAni.setEndPos(m_vecBtn[i].x - 60, m_vecBtn[i].y);
					m_btnAniVec.push(btnAni);
				}
			}
			
			for each (var ani:AniPosition in m_btnAniVec)
			{
				ani.begin();
			}
			
			if (m_btnAniVec.length)
			{
				m_btnAniVec[m_btnAniVec.length - 1].onEnd = btnMoveEndCB;
			}
		}
		
		private function btnMoveEndCB():void
		{
			var i:int;
			
			for (i = 0; i < SysbtnMgr.SYSBTN_Count; i++)
			{
				updatePosEffectAni(i);
			}
		}
		
		private function onMouseRollOverExpBar(evetn:MouseEvent):void
		{
			var str:String = m_exp + " / " + m_expTotal + "   ( " + Math.floor(100 * m_exp / m_expTotal) + "% )";
			var mousePos:Point = m_gkcontext.m_context.mouseScreenPos();
			var expbarPos:Point = m_expBar.localToScreen();
			
			m_gkcontext.m_uiTip.hintHtiml(mousePos.x, expbarPos.y - 50, str);
		}
		
		//非通过“开启新功能”开启的功能(未走新手引导流程)
		public function addNewOneSysBtn(type:uint):void
		{
			var btnid:int = SysbtnMgr.getBtnId(type);
			
			if (!m_dicBtnConfig[btnid] && (btnid > -1))
			{
				//vacateRoomForButton(type);
				
				if (btnid == SysbtnMgr.SYSBTN_DuanZao)
				{
					m_dicBtnConfig[btnid] = new SysBtnConfig("duanzaobtn");
				}
				else if (btnid == SysbtnMgr.SYSBTN_ZhenXing)
				{
					m_dicBtnConfig[btnid] = new SysBtnConfig("zhenxingbtn");
				}
				else if (btnid == SysbtnMgr.SYSBTN_DaZuo)
				{
					m_dicBtnConfig[btnid] = new SysBtnConfig("dazuobtn");
				}
				else if (btnid == SysbtnMgr.SYSBTN_WuXiaye)
				{
					m_dicBtnConfig[btnid] = new SysBtnConfig("wujiangbtn");
				}
				else if (btnid == SysbtnMgr.SYSBTN_JunTuan)
				{
					m_dicBtnConfig[btnid] = new SysBtnConfig("juntuanbtn");
				}
				else if (btnid == SysbtnMgr.SYSBTN_ZhanXing)
				{
					m_dicBtnConfig[btnid] = new SysBtnConfig("wuxuebtn");
				}
				else if (btnid == SysbtnMgr.SYSBTN_TongqueTai)
				{
					m_dicBtnConfig[btnid] = new SysBtnConfig("tongquetaibtn");
				}
				else if (id == SysbtnMgr.SYSBTN_Mounts)
				{
					m_dicBtnConfig[btnid] = new SysBtnConfig("mountsbtn");
				}
				
				updateCreateBtn();
				//showEffectAni(btnid);
			}
		}
		
		private function updatePosEffectAni(btnid:int):void
		{
			var btn:ButtonAni = m_vecBtn[btnid];
			var ani:Ani = m_dicEffectAni[btnid] as Ani;
			if (ani && btn)
			{
				ani.x = btn.x + 27;
				ani.y = btn.y + 38;
			}
		}
		
		//显示按钮提示特效
		public function showEffectAni(btnid:int):void
		{
			var btn:ButtonAni = m_vecBtn[btnid];
			if (null == btn)
			{
				return;
			}
			
			var ani:Ani = m_dicEffectAni[btnid] as Ani;
			if (null == ani)
			{
				ani = new Ani(m_gkcontext.m_context);
				ani.centerPlay = true;
				ani.scaleX = 0.75;
				ani.scaleY = 0.75;
				ani.setImageAni("ejanniugongneng.swf");
				ani.duration = 1.5;
				ani.repeatCount = 0;
				ani.mouseEnabled = false;
				m_dicEffectAni[btnid] = ani;
			}
			
			if (ani)
			{
				ani.begin();
				if (!this.contains(ani))
				{
					this.addChild(ani);
					this.swapChildren(btn, ani);
				}				
				ani.x = btn.x + 27;
				ani.y = btn.y + 38;
			}
		}
		
		//取消按钮特效显示
		public function hideEffectAni(btnid:int):void
		{
			var ani:Ani = m_dicEffectAni[btnid] as Ani;
			if (ani)
			{
				if (ani.parent)
				{
					ani.parent.removeChild(ani);
				}
				ani.dispose();
				delete m_dicEffectAni[btnid];
			}
		}
		
		//获得当前经验进度条显示位置
		public function getCurExpPos():Point
		{
			return m_expBar.localToScreen(new Point(450 * m_expBar.value, 6));
		}
		
		public function moveToLayer(layerID:uint):void
		{
			m_gkcontext.m_UIMgr.switchFormToLayer(this, layerID);
		}
		
		public function moveBackFirstLayer():void
		{
			m_gkcontext.m_UIMgr.switchFormToLayer(this, UIFormID.FirstLayer); 
		}
	}
}