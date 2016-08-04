package game.ui.uibackpack.backpack
{
	import com.ani.AniPosition;
	import com.bit101.components.ButtonTabText;
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.PanelDraw;
	import com.bit101.components.PushButton;
	import com.dnd.DragManager;
	import com.gamecursor.GameCursor;
	import com.pblabs.engine.resource.SWFResource;
	import common.event.DragAndDropEvent;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import net.ContentBuffer;
	import modulecommon.net.msg.propertyUserCmd.stSplitObjPropertyUserCmd;
	import modulecommon.net.msg.propertyUserCmd.stSwapObjectPropertyUserCmd;
	import modulecommon.scene.prop.object.ObjectMgr;
	import modulecommon.scene.prop.object.ObjectPanel;
	import modulecommon.scene.prop.object.Package;
	import modulecommon.scene.prop.object.stObjLocation;
	import modulecommon.scene.prop.object.ZObject;
	import com.dnd.DragListener;
	import modulecommon.res.ResGrid9;
	import com.dgrigg.image.Image;
	import modulecommon.scene.prop.object.ZObjectDef;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import com.util.UtilTools;
	import game.ui.uibackpack.msg.reqSortMainPackageUserCmd;
	import game.ui.uibackpack.msg.stObjSaleInfo;
	import game.ui.uibackpack.msg.stSaleObjPropertyUserCmd;
	import game.ui.uibackpack.UIBackPack;
	import game.ui.uibackpack.wujiang.AllWuPanel;
	import game.ui.uibackpack.sale.SalePart;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class BackPack extends PanelContainer implements DragListener
	{
		//public static const Package_First:int = stObjLocation.OBJECTCELLTYPE_COMMON1;
		//public static const Package_Second:int = stObjLocation.OBJECTCELLTYPE_COMMON2;
		//public static const Package_Third:int = stObjLocation.OBJECTCELLTYPE_COMMON3;
		//public static const Package_Baowu:int = stObjLocation.OBJECTCELLTYPE_BAOWU;
		//public static const Package_Count:int = 3;
		
		private var m_gkContext:GkContext;
		private var m_bg:PanelDraw;
		
		private var m_dicPackages:Dictionary;
		private var m_dicPageBtns:Dictionary;
		private var m_pageIDList:Vector.<int>;
		
		private var m_chushouBtn:PushButton; //出售按钮
		private var m_chaifenBtn:PushButton; //拆分按钮
		private var m_zhengliBtn:PushButton; //整理按钮
		private var m_uiBackPack:UIBackPack;
		private var m_allWu:AllWuPanel;
		private var m_curClickObj:ZObject;
		private var m_curPage:int;
		private var m_fisrtLock:stObjLocation;
		
		private var m_vecOpenEff:Vector.<OpenBackpackEff>;
		private var m_salePart:SalePart;
		private var m_preClickTime:Number = 0;
		private var m_ani:AniPosition;		//包裹显示动画
		private var m_bShow:Boolean;		//包裹是否显示
		private var m_closeBtn:PushButton;	//关闭按钮
		
		public function BackPack(gk:GkContext, uiBP:UIBackPack, allWu:AllWuPanel)
		{
			m_gkContext = gk;
			m_uiBackPack = uiBP;
			m_allWu = allWu;
			
			m_fisrtLock = new stObjLocation();
			this.setSize(300, 524);
			this.setSkinForm("form8.swf");
			setDropTrigger(true);
			
			m_bg = new PanelDraw(this, 15, 65);
			m_bg.setSize(270, 430);
			
			var panel:Panel;
			panel = new Panel();
			panel.setSize(270, 419);
			panel.setPanelImageSkin("commoncontrol/panel/backpack/pageBG.png");
			m_bg.addDrawCom(panel);
			
			panel = new Panel(null, 8, 340);
			panel.setPanelImageSkin("commoncontrol/panel/backpack/framebg.png");
			m_bg.addDrawCom(panel);
			
			panel = new Panel(null, 8, 340);
			panel.setPanelImageSkinMirror("commoncontrol/panel/glodflightlong.png", Image.MirrorMode_LR);
			m_bg.addDrawCom(panel);
			
			var i:int = 0;
			var j:int = 0;
			var k:int = 0;
			var left:int = 8;
			var top:int = 15;
			var interval:int = 52;
			
			for (i = 0; i < PackagePanel.HEIGHT; i++)
			{
				left = 8;
				for (j = 0; j < PackagePanel.WIDTH; j++)
				{
					panel = new Panel(null, left, top);
					m_bg.addDrawCom(panel, true);
					panel.setPanelImageSkin(ZObject.IconBg);
					
					k++;
					left += interval;
				}
				top += interval + 2;
			}
			m_bg.drawPanel();
			
			//-------------------
			m_dicPackages = new Dictionary();
			m_dicPageBtns = new Dictionary();
			
			//--------------
			left = 20;
			interval = 64;
			var btn:ButtonTabText;
			
			var arTitle:Array = ["包裹一", "包裹二", "包裹三", "宝物"];
			m_pageIDList = Vector.<int>([stObjLocation.OBJECTCELLTYPE_COMMON1, stObjLocation.OBJECTCELLTYPE_COMMON2, stObjLocation.OBJECTCELLTYPE_COMMON3, stObjLocation.OBJECTCELLTYPE_BAOWU]);
			for (i = 0; i < 4; i++)
			{
				btn = new ButtonTabText(this, left, 36, arTitle[i]);
				btn.setSize(64, 28);
				btn.setDropTrigger(true);
				btn.setParam(12, true, onPageBtnClick, 0xeeeeee, 0xffffff, 0xaaaaaa, 0x202020);			
				btn.goupID = 911;
				btn.tag = m_pageIDList[i];
				btn.setPanelImageSkin("commoncontrol/button/buttonTab8.swf");
				m_dicPageBtns[btn.tag] = btn;
				left += interval;
			}
			
			m_dicPageBtns[stObjLocation.OBJECTCELLTYPE_COMMON1].selected = true;
			showPage(stObjLocation.OBJECTCELLTYPE_COMMON1);
			
			m_chushouBtn = new PushButton(this, 27, 445, onFunBtnClick);
			m_chushouBtn.setSkinButton1Image("commoncontrol/panel/backpack/chushou.png");
			m_chushouBtn.tag = 0;
			
			m_chaifenBtn = new PushButton(this, 110, 445, onFunBtnClick);
			m_chaifenBtn.setSkinButton1Image("commoncontrol/panel/backpack/chaifen.png");
			m_chaifenBtn.tag = 1;
			
			m_zhengliBtn = new PushButton(this, 193, 445, onFunBtnClick);
			m_zhengliBtn.setSkinButton1Image("commoncontrol/panel/backpack/zhengli.png");
			m_zhengliBtn.tag = 2;
			
			m_ani = new AniPosition();
			m_ani.sprite = this;
			m_ani.duration = 0.5;
			
			m_closeBtn = new PushButton(this, this.width - 29, 6, onCloseBtnClick);
			m_closeBtn.setSkinButton1Image("commoncontrol/button/closebtn1.png");
		}
		
		public function onPageBtnClick(e:MouseEvent):void
		{
			if (e.target is ButtonTabText)
			{
				showPage((e.target as ButtonTabText).tag);
			}
		}
		
		override public function dispose():void
		{
			for each (var panel:PackagePanel in m_dicPackages)
			{
				if (panel.parent == null)
				{
					panel.dispose();
				}
			}
			
			if (m_salePart && m_salePart.isVisible() == false)
			{
				m_salePart.dispose();
			}
			
			m_ani.dispose();
			
			super.dispose();
		}
		
		protected function showPage(page:int):void
		{
			if (m_dicPackages[page] == undefined)
			{
				var pac:PackagePanel = new PackagePanel(m_gkContext, this, page, 15, 65);
				m_dicPackages[page] = pac;
				pac.initData();
			}
			
			for each (var panel:PackagePanel in m_dicPackages)
			{
				if (panel.no == page)
				{
					panel.show();
				}
				else
				{
					panel.hide();
				}
			}
			m_curPage = page;
		}
		
		public function updateAllObjects():void
		{
			for each (var panel:PackagePanel in m_dicPackages)
			{
				panel.updateAllObjects();
			}
		}
		
		public function reloadObjects():void
		{
			var pac:PackagePanel = m_dicPackages[stObjLocation.OBJECTCELLTYPE_COMMON1] as PackagePanel;
			if (pac)
			{
				pac.clearAllObjects();
				pac.initObjects();
			}
			pac = m_dicPackages[stObjLocation.OBJECTCELLTYPE_COMMON2] as PackagePanel;
			if (pac)
			{
				pac.clearAllObjects();
				pac.initObjects();
			}
			pac = m_dicPackages[stObjLocation.OBJECTCELLTYPE_COMMON3] as PackagePanel;
			if (pac)
			{
				pac.clearAllObjects();
				pac.initObjects();
			}
		}
		
		public function reloadBaowuPackage():void
		{
			var pac:PackagePanel = m_dicPackages[stObjLocation.OBJECTCELLTYPE_BAOWU] as PackagePanel;
			if (pac)
			{
				pac.clearAllObjects();
				pac.initObjects();
			}
		}
		
		public function get curHeroID():uint
		{
			return m_uiBackPack.curHeroID;
		}
		
		public function addObject(obj:ZObject):void
		{
			var panel:PackagePanel = m_dicPackages[obj.m_object.m_loation.location];
			if (panel)
			{
				panel.addObject(obj);
			}
		}
		
		public function removeObject(obj:ZObject):void
		{
			var panel:PackagePanel = m_dicPackages[obj.m_object.m_loation.location];
			if (panel)
			{
				panel.removeObject(obj);
			}
		}
		
		public function updateObject(obj:ZObject):void
		{
			var panel:PackagePanel = m_dicPackages[obj.m_object.m_loation.location];
			if (panel)
			{
				panel.updateObject(obj);
			}
		}
		
		public function onAddToSale(obj:ZObject):void
		{
			var panel:PackagePanel = m_dicPackages[obj.m_object.m_loation.location];
			if (panel)
			{
				panel.onAddToSale(obj);
			}
		}
		
		public function onRemoveToSale(obj:ZObject):void
		{
			var panel:PackagePanel = m_dicPackages[obj.m_object.m_loation.location];
			if (panel)
			{
				panel.onRemoveToSale(obj);
			}
		}
		
		public function updateLocState(oldOpenedSize:int, nowOpenedSize:int):void
		{
			if (m_vecOpenEff == null)
			{
				m_vecOpenEff = new Vector.<OpenBackpackEff>();
			}
			var op:OPInCommonPack;
			var openEff:OpenBackpackEff;
			var index:int;
			var i:int;
			var oldLen:int = m_vecOpenEff.length;
			for (index = oldOpenedSize; index < nowOpenedSize; index++)
			{
				op = getOPInCommonPackByIndex(index);
				if (op == null)
				{
					continue;
				}
				openEff = new OpenBackpackEff(m_gkContext, op.parent, op, op.x + 20, op.y + 5);
				m_vecOpenEff.push(openEff);
			}
			
			for (i = oldLen + 1; i < m_vecOpenEff.length; i++)
			{
				m_vecOpenEff[i - 1].setNextPlayCallBack(m_vecOpenEff[i].beginPlay)
			}
			
			if (oldLen < m_vecOpenEff.length)
			{
				m_vecOpenEff[oldLen].setAniEnd(null); //这里有这个考虑，上次播放还没有结束
				m_vecOpenEff[oldLen].beginPlay();
			}
			if (m_vecOpenEff.length > 0)
			{
				m_vecOpenEff[m_vecOpenEff.length - 1].setAniEnd(onOpenOffEnd);
			}
		}
		
		private function onOpenOffEnd():void
		{
			var openEff:OpenBackpackEff;
			for each (openEff in m_vecOpenEff)
			{
				openEff.dispose();
				if (openEff.parent)
				{
					openEff.parent.removeChild(openEff);
				}
			}
			m_vecOpenEff.length = 0;
			setNextOpenedGrid();
		}
		
		public function onUIBackPackShow():void
		{
			if (m_curPage == stObjLocation.OBJECTCELLTYPE_BAOWU)
			{
				(m_dicPageBtns[stObjLocation.OBJECTCELLTYPE_COMMON1] as ButtonTabText).selected = true;
				showPage(stObjLocation.OBJECTCELLTYPE_COMMON1);
			}
			
			var op:OPInCommonPack = getNextOpenGrid();
			if (op)
			{
				op.onUIBackPackShow();
			}
		}
		
		public function onUIBackPackHide():void
		{
			var op:OPInCommonPack = getNextOpenGrid();
			if (op)
			{
				op.onUIBackPackHide();
			}
			if (m_salePart && m_salePart.isVisible())
			{
				m_salePart.exit();
			}
		}
		
		public function updateNextOpenedGrid():void
		{
			if (m_vecOpenEff && m_vecOpenEff.length > 0)
			{
				return;
			}
			setNextOpenedGrid();
		}
		
		private function setNextOpenedGrid():void
		{
			var op:OPInCommonPack = getNextOpenGrid();
			if (op)
			{
				op.setOpenNext();
				if (m_uiBackPack.isVisible())
				{
					op.onUIBackPackShow();
				}
			}
		}
		
		public function getNextOpenGrid():OPInCommonPack
		{
			var op:OPInCommonPack = null;
			var openedSize:int = m_gkContext.m_objMgr.getSizeOfOpenedGrid();
			var size:int = ObjectMgr.PACKAGE_MAIN_WIDTH * ObjectMgr.PACKAGE_MAIN_HEIGHT * 3;
			if (openedSize < size)
			{
				op = getOPInCommonPackByIndex(openedSize);
			}
			return op;
		}
		
		protected function onFunBtnClick(e:MouseEvent):void
		{
			if (e.target is PushButton == false)
			{
				return;
			}
			var btnTag:int = (e.target as PushButton).tag;
			if (btnTag == 0)
			{
				m_gkContext.m_context.m_gameCursor.setCmdState(GameCursor.CMDSTATE_Sale, null, onSaleMouseUpCallback);
					//出售
			}
			else if (btnTag == 1)
			{
				//拆分
				m_gkContext.m_context.m_gameCursor.setCmdState(GameCursor.CMDSTATE_ChaifenItem, null, onChaifenMouseUpCallback);
			}
			else if (btnTag == 2)
			{
				var uT:Number = 5 - (m_gkContext.m_context.m_timeMgr.getCalendarTimeSecond() - m_preClickTime);
				if (m_preClickTime > 0 && uT > 0)
				{
					m_gkContext.m_systemPrompt.promptOnTopOfMousePos("请在 " + Math.ceil(uT) + "秒 后再进行整理包裹");
				}
				else
				{
					//整理
					var sendZhengli:reqSortMainPackageUserCmd = new reqSortMainPackageUserCmd();
					m_gkContext.sendMsg(sendZhengli);
					
					m_preClickTime = m_gkContext.m_context.m_timeMgr.getCalendarTimeSecond();
				}
			}
		}
		
		private function onSaleMouseUpCallback(e:MouseEvent, state:int):void
		{
			var btn:ButtonTabText = UtilTools.getDisplayObjectByChild(ButtonTabText, e.target as DisplayObject) as ButtonTabText;
			if (btn && isBackTabBtn(btn))
			{
				return;
			}
			
			if (m_bg == e.target)
			{
				if (m_bg.mouseY >= 64 && m_bg.mouseY <= 340)
				{
					return;
				}
				
			}
			var panel:OPInCommonPack = UtilTools.getDisplayObjectByChild(OPInCommonPack, e.target as DisplayObject) as OPInCommonPack;
			if (panel != null)
			{
				var obj:ZObject = panel.objectIcon.zObject;
				if (obj)
				{
					if (obj.price_GameMoney == 0)
					{
						m_gkContext.m_systemPrompt.prompt("不可出售");
						return;
					}
					if (obj.isEquip && obj.bHaveGems())
					{
						m_gkContext.m_systemPrompt.prompt("已镶嵌宝石，不可出售");
						return;
					}
					
					if (obj.iconColor >= ZObjectDef.COLOR_PURPLE || (obj.isEquip && obj.m_object.m_equipData.enhancelevel > 3))
					{
						var str:String;
						UtilHtml.beginCompose();
						UtilHtml.addStringNoFormat("确认出售");
						str = "【" + obj.name + "】"; //?\n价格"+objSor.price_GameMoney+"银币";
						UtilHtml.add(str, obj.colorValue, 14);
						UtilHtml.addStringNoFormat("？");
						UtilHtml.breakline();
						UtilHtml.add("（价格 ", UtilColor.WHITE_Yellow, 14);
						UtilHtml.add(obj.price_GameMoney.toString(), UtilColor.GREEN);
						if (obj.m_object.num > 1)
						{
							UtilHtml.add(" X " + obj.m_object.num, UtilColor.GREEN);
						}
						UtilHtml.add(" 银币）", UtilColor.WHITE_Yellow, 14);
						m_gkContext.m_confirmDlgMgr.tempData = obj;
						//m_gkContext.m_confirmDlgMgr.showModeInputYes(m_uiBackPack.id, "提示", UtilHtml.getComposedContent(), onBatchSaleConfirm, "确认", "取消");
						m_gkContext.m_confirmDlgMgr.showMode1(m_uiBackPack.id, UtilHtml.getComposedContent(), onBatchSaleConfirm, onBatchSaleConcel, "确认", "取消");
						return;
					}
					addZObjectToSalePart(obj);
					return;
				}
			}
			
			m_gkContext.m_context.m_gameCursor.releaseCmdState(state);
		}
		
		private function onBatchSaleConfirm():Boolean
		{
			addZObjectToSalePart(m_gkContext.m_confirmDlgMgr.tempData as ZObject);
			m_gkContext.m_context.m_gameCursor.setCmdState(GameCursor.CMDSTATE_Sale, null, onSaleMouseUpCallback);
			return true;
		}
		private function onBatchSaleConcel():Boolean
		{
			m_gkContext.m_context.m_gameCursor.setCmdState(GameCursor.CMDSTATE_Sale, null, onSaleMouseUpCallback);
			return true;
		}
		
		public function onSalePartShow():void
		{
			m_chaifenBtn.enabled = false;
			m_zhengliBtn.enabled = false;
		}
		
		public function onSalePartHide():void
		{
			m_chaifenBtn.enabled = true;
			m_zhengliBtn.enabled = true;
		}
		
		private function addZObjectToSalePart(obj:ZObject):void
		{
			if (m_salePart == null)
			{
				m_salePart = new SalePart(m_gkContext, this, this, this.width - 5, 28);
			}
			if (m_salePart.isInitiated)
			{
				m_salePart.show();
			}
			m_salePart.addObject(obj);
		}
		
		private function isBackTabBtn(btn:ButtonTabText):Boolean
		{
			var item:ButtonTabText;
			for each (item in m_dicPageBtns)
			{
				if (item == btn)
				{
					return true;
				}
			}
			return false;
		}
		
		private function onChaifenMouseUpCallback(e:MouseEvent, state:int):void
		{
			var panel:ObjectPanel = UtilTools.getDisplayObjectByChild(ObjectPanel, e.target as DisplayObject) as ObjectPanel;
			if (panel != null)
			{
				var objDest:ZObject = panel.objectIcon.zObject;
				if (objDest && objDest.m_object.num > 1)
				{
					m_uiBackPack.showChaifenDlg(onChaifen, panel);
				}
			}
			
			m_gkContext.m_context.m_gameCursor.releaseCmdState(state);
		}
		
		public function onChaifen(num:int, param:Object):void
		{
			if (num == 0)
			{
				return;
			}
			var chaiInfo:Object = new Object();
			chaiInfo["splitObj"] = param;
			chaiInfo["num"] = num;
			m_gkContext.m_contentBuffer.addContent(ContentBuffer.OBJECT_Chaifen, chaiInfo);
			
			var panel:ObjectPanel = param as ObjectPanel;
			
			DragManager.startDrag(panel, null, panel.objectIcon, this, true, false);
			panel.objectIcon.onDrag();
		}
		
		public function onReadyDrop(e:DragAndDropEvent):void
		{
			if (e.getDragInitiator() is OPInCommonPack == false)
			{
				return;
			}
			
			var panel:ObjectPanel = e.getDragInitiator() as ObjectPanel;
			var objSor:ZObject = panel.objectIcon.zObject;
			if (objSor == null)
			{
				return;
			}
			
			var target:Component = e.getTargetComponent();
			var panelDest:ObjectPanel;
			var sendSwap:stSwapObjectPropertyUserCmd;
			if ((target is ObjectPanel) && m_uiBackPack.contains(target))
			{
				if (target is OPInCommonPack)
				{
					var opInCommonPack:OPInCommonPack = target as OPInCommonPack;
					if (opInCommonPack.lock || opInCommonPack.canOperation == false)
					{
						return;
					}
				}
				
				panelDest = e.getTargetComponent() as ObjectPanel;
				
				if (objSor.m_object.m_loation.location != stObjLocation.OBJECTCELLTYPE_BAOWU && panelDest.objLocation.location == stObjLocation.OBJECTCELLTYPE_BAOWU)
				{
					m_gkContext.m_systemPrompt.prompt("不能放入宝物包裹的");
					return;
				}
				
				var objDest:ZObject = panelDest.objectIcon.zObject;
				
				if (panelDest == panel)
				{
					DragManager.drop();
					return;
				}
				//判断是否发送stSplitObjPropertyUserCmd消息
				var bSendSplitObjPropertyUserCmd:Boolean = false;
				var numSplit:uint = 0;
				if (objSor.maxNum > 1)
				{
					var chaiInfo:Object = m_gkContext.m_contentBuffer.getContent(ContentBuffer.OBJECT_Chaifen, true);
					if (chaiInfo && chaiInfo["splitObj"] == panel)
					{
						
						if (objDest == null || (objDest.ObjID == objSor.ObjID && objDest.m_object.num < objDest.maxNum))
						{
							numSplit = chaiInfo["num"];
							bSendSplitObjPropertyUserCmd = true;
						}
					}
					else
					{
						if (objDest && (objDest.ObjID == objSor.ObjID && objDest.m_object.num < objDest.maxNum))
						{
							numSplit = objSor.m_object.num;
							bSendSplitObjPropertyUserCmd = true;
						}
					}
				}
				
				if (bSendSplitObjPropertyUserCmd)
				{
					var sendSplitObjPropertyUserCmd:stSplitObjPropertyUserCmd = new stSplitObjPropertyUserCmd();
					sendSplitObjPropertyUserCmd.srcthisid = objSor.thisID;
					sendSplitObjPropertyUserCmd.num = numSplit;
					sendSplitObjPropertyUserCmd.pos = panelDest.objLocation;
					m_gkContext.sendMsg(sendSplitObjPropertyUserCmd);
					return;
				}
				
				if (panelDest.objLocation.matchPos(objSor.type) == false)
				{
					DragManager.drop();
					return;
				}
				if (objDest != null)
				{
					if (panel.objLocation.matchPos(objDest.type) == false)
					{
						DragManager.drop();
						return;
					}
				}
				//trace(panelDest.objLocation.heroid.toString() +"," + panelDest.objLocation.y.toString() );
				if (stObjLocation.OBJECTCELLTYPE_HEQUIP == panelDest.objLocation.location || stObjLocation.OBJECTCELLTYPE_UEQUIP == panelDest.objLocation.location)
				{
					if (objSor.needLevel > m_gkContext.playerMain.level)
					{
						var pt:Point = m_gkContext.m_context.mouseScreenPos();
						pt.y -= 50;
						m_gkContext.m_systemPrompt.prompt("人物等级不足", pt);
						DragManager.drop();
						return;
					}
				}
				
				sendSwap = new stSwapObjectPropertyUserCmd();
				sendSwap.dst = panelDest.objLocation;
				sendSwap.thisID = objSor.thisID;
				m_gkContext.sendMsg(sendSwap);
				return;
			}
			else if (target is ButtonTabText && (target as ButtonTabText).goupID == 911)
			{
				return;
			}
			
			DragManager.drop();
			if (target && m_uiBackPack.contains(target))
			{
				return;
			}
			
			if (objSor.bHaveGems())
			{
				m_gkContext.m_systemPrompt.prompt("装备已镶嵌宝石，请取下宝石");
				return;
			}
			
			if (!objSor.isEquip)
			{
				if (objSor.price_GameMoney == 0)
				{
					m_gkContext.m_systemPrompt.prompt("不可出售");
					return;
				}
				
				if (objSor.isEquip && objSor.bHaveGems())
				{
					m_gkContext.m_systemPrompt.prompt("已镶嵌宝石，不可出售");
					return;
				}
			}
			
			m_curClickObj = objSor;
			
			var bInputYes:Boolean;
			if (objSor.iconColor >= ZObjectDef.COLOR_PURPLE || (objSor.isEquip && objSor.m_object.m_equipData.enhancelevel > 3))
			{
				bInputYes = true;
			}
			var str:String;
			UtilHtml.beginCompose();
			UtilHtml.addStringNoFormat("确认出售");
			str = "【" + objSor.name + "】"; //?\n价格"+objSor.price_GameMoney+"银币";
			UtilHtml.add(str, objSor.colorValue, 14);
			UtilHtml.addStringNoFormat("？");
			UtilHtml.breakline();
			UtilHtml.add("（价格 ", UtilColor.WHITE_Yellow, 14);
			UtilHtml.add(objSor.price_GameMoney.toString(), UtilColor.GREEN);
			if (objSor.m_object.num > 1)
			{
				UtilHtml.add(" x" + objSor.m_object.num, UtilColor.GREEN);
			}
			UtilHtml.add(" 银币）", UtilColor.WHITE_Yellow, 14);
			
			if (bInputYes == false)
			{
				m_gkContext.m_confirmDlgMgr.showMode1(m_uiBackPack.id, UtilHtml.getComposedContent(), ConfirmFn, null, "确认", "取消");
			}
			else
			{
				m_gkContext.m_confirmDlgMgr.showModeInputYes(m_uiBackPack.id, "提示", UtilHtml.getComposedContent(), ConfirmFn, "确认", "取消");
			}
		
		}
		
		private function ConfirmFn():Boolean
		{
			var sendSale:stSaleObjPropertyUserCmd = new stSaleObjPropertyUserCmd();
			var sale:stObjSaleInfo = new stObjSaleInfo();
			sale.num = m_curClickObj.m_object.num;
			sale.thisid = m_curClickObj.thisID;
			sendSale.m_list.push(sale);
			m_gkContext.sendMsg(sendSale);
			
			return true;
		}
		
		public function get uiBackPack():UIBackPack
		{
			return m_uiBackPack;
		}
		
		public function onDragStart(e:DragAndDropEvent):void
		{
			if (e.getDragInitiator() is ObjectPanel == false)
			{
				return;
			}
			var panel:ObjectPanel = e.getDragInitiator() as ObjectPanel;
			var obj:ZObject = panel.objectIcon.zObject;
			if (obj.isEquip)
			{
				m_allWu.onEquipDrag(obj);
			}
		}
		
		public function onDragEnter(e:DragAndDropEvent):void
		{
		}
		
		public function onDragOverring(e:DragAndDropEvent):void
		{
		}
		
		public function onDragExit(e:DragAndDropEvent):void
		{
		
		}
		
		public function onDragDrop(e:DragAndDropEvent):void
		{
			if (e.getDragInitiator() is ObjectPanel == false)
			{
				return;
			}
			var panel:ObjectPanel = e.getDragInitiator() as ObjectPanel;
			var obj:ZObject = panel.objectIcon.zObject;
			if (obj.isEquip)
			{
				m_allWu.onEquipDrop(obj);
			}
			
			panel.objectIcon.onDrop();
		}
		
		//将4个子包裹连在一起后，可以看做是一个大包裹，可以用index访问这个大包裹中的每个格子
		public function getOPInCommonPackByIndex(index:int):OPInCommonPack
		{
			var size:int = ObjectMgr.PACKAGE_MAIN_WIDTH * ObjectMgr.PACKAGE_MAIN_HEIGHT;
			var pacPanel:PackagePanel;
			
			var pageIndex:int = index / size;
			var opIndexInPage:int = index % size;
			pacPanel = m_dicPackages[m_pageIDList[pageIndex]];
			if (pacPanel)
			{
				return pacPanel.getObjectPanelByIndex(opIndexInPage);
			}
			return null;
		}
		
		//设置"包裹"显示位置
		public function setShowPos(isShow:Boolean):void
		{
			m_bShow = isShow;
			
			if (m_bShow)
			{
				this.setPos(446, 0);
			}
			else
			{
				this.setPos(146, 0);
				onUIBackPackHide();
			}
		}
		
		//更新"包裹"显示位置
		public function updateShowPos():void
		{
			if (m_ani.bRun)
			{
				return;
			}
			
			m_ani.setBeginPos(this.x, this.y);
			if (m_bShow)
			{
				m_ani.setEndPos(this.x - 300, this.y);
				onUIBackPackHide();
			}
			else
			{
				m_ani.setEndPos(this.x + 300, this.y);
			}
			m_ani.begin();
			
			m_bShow = !m_bShow;
			m_gkContext.m_sysbtnMgr.m_bShowPackage = m_bShow;
		}
		
		public function get bShow():Boolean
		{
			return m_bShow;
		}
		
		private function onCloseBtnClick(event:MouseEvent):void
		{
			if (event.target is PushButton)
			{
				if (bShow)
				{
					updateShowPos();
				}
			}
		}
	}

}