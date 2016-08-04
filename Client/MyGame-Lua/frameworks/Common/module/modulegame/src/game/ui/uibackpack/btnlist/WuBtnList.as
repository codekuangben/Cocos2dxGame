package game.ui.uibackpack.btnlist
{
	import com.bit101.components.PanelContainer;
	import com.bit101.components.TextNoScroll;
	import com.dnd.DragListener;
	import com.dnd.DragManager;
	import common.event.DragAndDropEvent;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.net.msg.sceneHeroCmd.stSetHeroXiaYeCmd;
	import modulecommon.scene.wu.WuHeroProperty;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import modulecommon.ui.UIFormID;
	import game.ui.uibackpack.UIBackPack;
	import game.ui.uibackpack.xiayewulist.XiayeWuList;

	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.dgrigg.image.Image;
	import com.pblabs.engine.resource.SWFResource;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import flash.display.DisplayObjectContainer;
	import modulecommon.scene.wu.WuProperty;
	import game.ui.uibackpack.wujiang.AllWuPanel;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class WuBtnList extends Component implements DragListener
	{
		public static const INTERVAL:int = 3;
		public static const BUTTONH:int = 37;
		public static const BUTTONW:int = 130;
		
		private var m_arBtnList:Array;
		private var m_gkContext:GkContext;
		private var m_ui:UIBackPack;
		private var m_dicBtn:Dictionary;
		private var m_uCurHeroID:uint;
		
		private var m_inImagePanel:Panel; 	//未出战武将
		private var m_allWu:AllWuPanel;
		private var m_container:PanelContainer;
		private var m_selectedPanel:Panel;	//BtnTab选中
		
		public var m_xiayewuList:XiayeWuList;
		
		public function WuBtnList(parent:DisplayObjectContainer, gk:GkContext, allWu:AllWuPanel, ui:UIBackPack)
		{
			m_gkContext = gk;
			m_allWu = allWu;
			m_ui = ui;
			super(parent);
			
			m_arBtnList = new Array();
			m_dicBtn = new Dictionary();
			m_container = new PanelContainer(this, 0, 8);
			m_inImagePanel = new Panel(m_container, 0, 0);
			m_selectedPanel = new Panel(m_container, 0, -8);
			m_selectedPanel.mouseEnabled = false;
			
			this.setSize(130, 450);
			this.setDropTrigger(true);
		}
		
		public function initData(res:SWFResource):void
		{
			var btn:ButtonWuTab;
			var wuPro:WuProperty;
			var arr:Array = m_gkContext.m_wuMgr.getAllWu();
			
			m_inImagePanel.setPanelImageSkinMirror("commoncontrol/panel/glodflightsmall.png", Image.MirrorMode_LR);
			m_inImagePanel.visible = false;
			for each (var item:*in arr)
			{
				wuPro = (item as WuProperty);
				if (wuPro.xiaye)
				{
					continue;
				}
				btn = new ButtonWuTab(m_container, 0, 0, onClick);
				btn.initBtnData(m_gkContext, wuPro, this);
				btn.setSize(BUTTONW, BUTTONH);
				
				m_dicBtn[wuPro.m_uHeroID] = btn;
			}
			
			generateBtnList();
			
			if (m_dicBtn[defaultShowHeroID] != null)
			{
				(m_dicBtn[defaultShowHeroID] as ButtonWuTab).selected = true;
				m_uCurHeroID = defaultShowHeroID;
			}
			
			if (m_dicBtn[m_uCurHeroID])
			{
				showSelectedPanel(m_dicBtn[m_uCurHeroID]);
			}
		}
		
		//武将数量变化
		public function onWuNumChange(heroid:int):void
		{
			var btn:ButtonWuTab = m_dicBtn[heroid] as ButtonWuTab;
			if (btn)
			{
				btn.refresh();
			}
		}
		
		public function addWu(heroID:uint):void
		{
			var btn:ButtonWuTab;
			var wuPro:WuProperty;
			wuPro = m_gkContext.m_wuMgr.getWuByHeroID(heroID);
			if (wuPro == null)
			{
				return;
			}
			btn = new ButtonWuTab(m_container, 0, 0, onClick);
			btn.initBtnData(m_gkContext, wuPro, this);
			btn.setSize(BUTTONW, BUTTONH);
			
			m_dicBtn[wuPro.m_uHeroID] = btn;
			
			generateBtnList();
		}
		
		public function removeWu(heroID:uint):void
		{
			var btn:ButtonWuTab = m_dicBtn[heroID] as ButtonWuTab;
			if (btn == null)
			{
				return;
			}
			delete m_dicBtn[heroID];
			m_container.removeChild(btn);
			btn.dispose();
			generateBtnList();
		}
		
		public function setSelected(heroID:uint):Boolean
		{
			var btn:ButtonWuTab = m_dicBtn[heroID] as ButtonWuTab;
			if (btn == null)
			{
				return false;
			}
			
			btn.selected = true;
			m_uCurHeroID = heroID;
			m_ui.onShowRelationWuPanel();
			
			showSelectedPanel(btn);
			
			return true;
		}
		
		public function generateBtnList():void
		{
			var wuPro:WuProperty;
			var arOut:Array = m_gkContext.m_wuMgr.getFightWuList(true, true);
			var arIn:Array = m_gkContext.m_wuMgr.getFightWuList(false, true);
			
			m_arBtnList.length = 0;
			var i:int;
			var top:int = 0;
			var btn:ButtonWuTab;
			for (i = 0; i < arOut.length; i++)
			{
				top += INTERVAL;
				btn = m_dicBtn[(arOut[i] as WuProperty).m_uHeroID];
				btn.y = top;
				m_arBtnList.push(btn);
				top += BUTTONH;
			}
			
			if (arIn.length > 0)
			{
				top += 5;
				m_inImagePanel.visible = true;
				m_inImagePanel.y = top;
				
				top += 7;
			}
			else
			{
				m_inImagePanel.visible = false;
			}
			
			for (i = 0; i < arIn.length; i++)
			{
				top += INTERVAL;
				btn = m_dicBtn[(arIn[i] as WuProperty).m_uHeroID];
				btn.y = top;
				m_arBtnList.push(btn);
				top += BUTTONH;
			}
			
			if (m_dicBtn[m_uCurHeroID])
			{
				showSelectedPanel(m_dicBtn[m_uCurHeroID]);
			}
		}
		
		private function onClick(e:MouseEvent):void
		{
			if (m_gkContext.m_newHandMgr.isVisible())
			{
				m_gkContext.m_newHandMgr.promptOver();
			}
			
			var btn:ButtonWuTab = e.target as ButtonWuTab;
			if (btn != null)
			{
				m_uCurHeroID = btn.wuID;
				m_allWu.showPanel(btn.wuID);
				m_ui.onShowRelationWuPanel();
			}
			
			showSelectedPanel(btn);
		}
		
		public function get curHeroID():uint
		{
			return m_uCurHeroID;
		}
		
		public function get dicBtn():Dictionary
		{
			return m_dicBtn;
		}
		
		//武将列表有武将，且"我的三国关系"未开启时，默认显示第一个武将，否则，显示玩家自己
		public function get defaultShowHeroID():uint
		{
			var ret:uint = WuProperty.MAINHERO_ID;
			var btn:ButtonWuTab;
			
			if (m_arBtnList.length > 1 && !m_gkContext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_USERACTRELAIONS))
			{
				btn = m_arBtnList[1] as ButtonWuTab;
				if (btn)
				{
					ret = btn.wuID;
				}
			}
			
			return ret;
		}
		
		public function showSelectedPanel(btn:ButtonWuTab):void
		{
			if (null == btn || (m_selectedPanel.y == (btn.y - 22)))
			{
				return;
			}
			
			m_selectedPanel.setPos(btn.x - 22, btn.y - 22);
			
			var res:String = "wubtnselect_green";
			var wuhero:WuHeroProperty = btn.wu as WuHeroProperty;
			if (wuhero)
			{
				switch(wuhero.color)
				{
					case WuProperty.COLOR_GREEN:
						res = "wubtnselect_green";
						break;
					case WuProperty.COLOR_BLUE:
						res = "wubtnselect_blue";
						break;
					case WuProperty.COLOR_PURPLE:
						res = "wubtnselect_purple";
						break;
				}
			}
			m_selectedPanel.setPanelImageSkin("commoncontrol/button/buttonwutab/" + res + ".png");
		}
		
		public function onReadyDrop (e:DragAndDropEvent) : void
		{			
			if (false == (e.getTargetComponent() is XiayeWuList))
			{
				DragManager.drop();
				return;
			}
			DragManager.drop();
		}
		
		public function onDragDrop (e:DragAndDropEvent) : void
		{
			var wubtn:ButtonWuTab = e.getDragInitiator() as ButtonWuTab;
			wubtn.becomeUnGray();
			
			var targetCom:Component = e.getTargetComponent();
			if (targetCom && targetCom is XiayeWuList)
			{
				var wu:WuProperty = wubtn.wu;
				var str:String;
				
				if (wu.chuzhan)
				{
					str = "出战武将下野后，将会下阵, 装备自动脱下到包裹中，请问您要继续吗？";
				}
				else
				{
					if (m_gkContext.m_objMgr.hasEquipForWus(wu.m_uHeroID))
					{
						str = "武将下野后，装备自动脱下到包裹中，请问您要继续吗？";
					}
				}
				
				if (str == null)
				{
					sendXiaye(wu.m_uHeroID);
					return;
				}
				
				m_gkContext.m_confirmDlgMgr.tempData = wu.m_uHeroID;
				m_gkContext.m_confirmDlgMgr.showMode1(UIFormID.UIBackPack, str, onConfirmFnWuXiaye, onConcelWuXiaye);					
			}
		}
		
		private function sendXiaye(id:uint):void
		{
			var send:stSetHeroXiaYeCmd = new stSetHeroXiaYeCmd();
			send.toXiaye = true;
			send.heroid = id;
			m_gkContext.sendMsg(send);
		}
		
		private function onConfirmFnWuXiaye():Boolean
		{
			var heroID:uint = m_gkContext.m_confirmDlgMgr.tempData as uint;
			var hasEquip:Boolean = m_gkContext.m_objMgr.hasEquipForWus(heroID);
			var hasEnougthFreeGrids:Boolean;
			
			if (hasEquip)
			{
				hasEnougthFreeGrids = m_gkContext.m_objMgr.hasEnoughGridForWus([heroID]);
				if (hasEnougthFreeGrids == false)
				{
					m_gkContext.m_systemPrompt.prompt("您的包裹空间不足，先清理包裹哦!");
					return false;
				}
			}
			
			if (m_gkContext.m_objMgr.hasEquipForWus(heroID))
			{
				m_gkContext.m_objMgr.moveWuEquipsToCommonPackage([heroID]);
			}
			
			sendXiaye(m_gkContext.m_confirmDlgMgr.tempData as uint);
			
			return true;
		}
		
		private function onConcelWuXiaye():Boolean
		{
			DragManager.drop();
			return true;
		}
		
		
		public function onDragEnter (e:DragAndDropEvent) : void{}
		
		public function onDragExit (e:DragAndDropEvent) : void{}
		
		public function onDragOverring (e:DragAndDropEvent) : void{}
		
		public function onDragStart (e:DragAndDropEvent) : void { }
		
	}

}