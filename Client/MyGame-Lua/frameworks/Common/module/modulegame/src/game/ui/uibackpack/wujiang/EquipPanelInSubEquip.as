package game.ui.uibackpack.wujiang
{
	//import adobe.utils.CustomActions;
	import com.bit101.components.ButtonTabText;
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.dnd.DragListener;
	import com.dnd.DragManager;
	import com.pblabs.engine.core.InputKey;
	import modulecommon.scene.prop.object.ObjectIcon;
	import com.util.UtilColor;
	import com.util.UtilHtml;

	import common.event.DragAndDropEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.net.msg.propertyUserCmd.stBuyEquipToHeroCmd;
	import modulecommon.net.msg.propertyUserCmd.stSwapObjectPropertyUserCmd;
	import modulecommon.scene.equipsys.EquipSysMgr;
	import modulecommon.scene.prop.object.ObjectPanel;
	import modulecommon.GkContext;
	import flash.display.DisplayObjectContainer;
	import modulecommon.scene.prop.object.stObjLocation;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.prop.object.ZObjectDef;
	import modulecommon.scene.prop.table.TObjectBaseItem;
	import modulecommon.ui.UIFormID;
	import game.ui.uibackpack.backpack.OPInCommonPack;
	import game.ui.uibackpack.UIBackPack;
	
	/**
	 * ...
	 * @author
	 */
	public class EquipPanelInSubEquip extends Component implements DragListener
	{
		private var m_allWu:AllWuPanel;
		private var m_gkContext:GkContext;
		private var m_objPanel:ObjectPanel;
		private var m_buyEquip:PushButton;
				
		public function EquipPanelInSubEquip(allWu:AllWuPanel, i:int, loc:int, heroID:uint, gk:GkContext, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			m_allWu = allWu;
			m_gkContext = gk;
			super(parent, xpos, ypos);
			m_objPanel = new ObjectPanel(gk, this);
			m_objPanel.gridY = i;
			m_objPanel.objLocation.location = loc;
			m_objPanel.objLocation.heroid = heroID;
			
			m_objPanel.addEventListener(MouseEvent.ROLL_OUT, m_gkContext.hideTipOnMouseOut);
			m_objPanel.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			m_objPanel.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			m_objPanel.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
			m_objPanel.setSize(ZObject.IconBgSize, ZObject.IconBgSize);
			m_objPanel.doubleClickEnabled = true;
		}
		
		public function setZObject(obj:ZObject):void
		{
			if (obj.iconColor >= ZObjectDef.COLOR_BLUE)
			{
				if (obj.maxEnhanceLevel && obj.curEnhanceLevel == obj.maxEnhanceLevel)
				{
					m_objPanel.showColorAniType = ZObjectDef.ObjAniType_Neiguang;
				}
				else
				{
					m_objPanel.showColorAniType = ZObjectDef.ObjAniType_Huanrao;
				}
			}
			else
			{
				m_objPanel.showColorAniType = ZObjectDef.ObjAniType_None;
			}
			
			m_objPanel.objectIcon.setZObject(obj);
			hideBuyEquip();
		}
		
		public function removeZObject():void
		{
			m_objPanel.objectIcon.removeZObject();
			showBuyEquip();
		}
		
		public function freshIcon():void
		{
			var obj:ZObject = m_objPanel.objectIcon.zObject;
			if (obj.iconColor >= ZObjectDef.COLOR_BLUE)
			{
				if (obj.maxEnhanceLevel && obj.curEnhanceLevel == obj.maxEnhanceLevel)
				{
					m_objPanel.showColorAniType = ZObjectDef.ObjAniType_Neiguang;
				}
				else
				{
					m_objPanel.showColorAniType = ZObjectDef.ObjAniType_Huanrao;
				}
			}
			else
			{
				m_objPanel.showColorAniType = ZObjectDef.ObjAniType_None;
			}
			
			m_objPanel.freshIcon();
		}
		
		private function showBuyEquip():void
		{
			if (m_gkContext.playerMain.level < 14)
			{
				return;
			}
			if (m_buyEquip == null)
			{
				m_buyEquip = new PushButton(this, 27, 27, onBuyEquipBtnClick);
				m_buyEquip.setSkinButton1Image("commoncontrol/button/addbtn2.png");
				m_buyEquip.addEventListener(MouseEvent.ROLL_OUT, m_gkContext.hideTipOnMouseOut);
				m_buyEquip.addEventListener(MouseEvent.ROLL_OVER, onBuyEquipMouseOver);
			}
			m_buyEquip.visible = true;
		}
		
		private function hideBuyEquip():void
		{
			if (m_buyEquip)
			{
				m_buyEquip.visible = false;
			}
		}
		
		public function initBuyEquip():void
		{
			if (!m_objPanel.objectIcon.zObject)
			{
				showBuyEquip();
			}			
		}
		
		private function onBuyEquipBtnClick(event:MouseEvent):void
		{
			var send:stBuyEquipToHeroCmd = new stBuyEquipToHeroCmd();
			send.m_location = m_objPanel.objLocation;
			m_gkContext.sendMsg(send);
		}
		
		//购买装备花费=int(1+装备等级/10)*1000
		protected function onBuyEquipMouseOver(event:MouseEvent):void
		{
			var pt:Point = this.localToScreen();
			var obj:ZObject = m_objPanel.objectIcon.zObject;
			if (obj == null)
			{
				var id:uint = ZObjectDef.composeEquipID(m_objPanel.objLocation.y, 1);
				var item:TObjectBaseItem = m_gkContext.m_objMgr.getObjectBaseByTableID(id);
				
				var money:int = Math.floor(1 + item.m_iLevel / 10) * 1000;
				var str:String = "花费 " + money + " 银币直接购买: " + item.m_iLevel + "级绿装[" + item.m_name+"]";
				UtilHtml.beginCompose();
				UtilHtml.add(str, UtilColor.WHITE_B, 12);
				UtilHtml.breakline();
				UtilHtml.add("鼠标点击后直接扣银币", UtilColor.WHITE_B, 12);
				
				m_gkContext.m_uiTip.hintHtiml(pt.x,pt.y+46, UtilHtml.getComposedContent(), 340);
			}
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{			
			var pt:Point = this.localToScreen();
			var obj:ZObject = m_objPanel.objectIcon.zObject;
			if (obj != null)
			{
				m_gkContext.m_uiTip.hintObjectInfo(pt, obj);
			}		
		}
		
		//负责拿起道具
		public function onMouseDown(e:MouseEvent):void
		{
			if (DragManager.isDragging() == true)
			{
				var dragPanel:EquipPanelInSubEquip = DragManager.getDragInitiator() as EquipPanelInSubEquip;
				if (dragPanel == this)
				{
					DragManager.drop();
				}
				return;
			}
			
			var objIcon:ObjectIcon = m_objPanel.objectIcon;
			if (objIcon.zObject == null || objIcon.loaded==false)
			{
				return;
			}
			if (this.m_gkContext.m_context.m_inputManager.isKeyDown(InputKey.SHIFT.keyCode))
			{
				m_gkContext.m_uiChat.exhibitZObject(objIcon.zObject);
				return;
			}
					
			DragManager.startDrag(m_objPanel, null, objIcon, this, true);
			m_objPanel.objectIcon.onDrag();
		
		}
		
		public function onReadyDrop(e:DragAndDropEvent):void
		{
			var objSor:ZObject = m_objPanel.objectIcon.zObject;
			if (objSor == null)
			{
				return;
			}
			
			var target:Component = e.getTargetComponent();
			var panelDest:ObjectPanel;
			var sendSwap:stSwapObjectPropertyUserCmd;
			if ((target is ObjectPanel) && m_allWu.m_uibackpack.contains(target))
			{				
				if (target is OPInCommonPack )
				{
					var opInCommonPack:OPInCommonPack = target as OPInCommonPack;
					if (opInCommonPack.lock || opInCommonPack.canOperation == false)
					{
						return;
					}
				}
				panelDest = target as ObjectPanel;
				if (panelDest == m_objPanel)
				{
					DragManager.drop();
					return;
				}
				
				if (panelDest.objLocation.location == stObjLocation.OBJECTCELLTYPE_BAOWU)
				{
					m_gkContext.m_systemPrompt.prompt("不能放入宝物包裹的");
					return;
				}
				var objDest:ZObject = panelDest.objectIcon.zObject;
				if (panelDest.objLocation.matchPos(objSor.type) == false)
				{
					DragManager.drop();
					return;
				}
				if (objDest != null)
				{
					if (m_objPanel.objLocation.matchPos(objDest.type) == false)
					{
						DragManager.drop();
						return;
					}
				}
				
				if (objDest && (objDest.needLevel > m_gkContext.playerMain.level))
				{
					var pt:Point = m_gkContext.m_context.mouseScreenPos();
					pt.y -= 50;
					m_gkContext.m_systemPrompt.prompt("人物等级不足", pt);
					return;
				}
				
				sendSwap = new stSwapObjectPropertyUserCmd();
				sendSwap.dst = panelDest.objLocation;
				sendSwap.thisID = objSor.thisID;
				m_gkContext.sendMsg(sendSwap);
			}
			else if (target is ButtonTabText && (target as ButtonTabText).goupID == 911)
			{
				return;
			}
			else
			{
				DragManager.drop();
				if (target&&m_allWu.m_uibackpack.contains(target))
				{
					return;
				}
				
				if (objSor.bHaveGems())
				{
					m_gkContext.m_systemPrompt.prompt("装备已镶嵌宝石，请取下宝石");
					return;
				}
				
				m_gkContext.m_confirmDlgMgr.tempData = objSor;
				m_gkContext.m_confirmDlgMgr.showMode1(UIFormID.UIBackPack, "物品被丢弃，将永远消失，确定要丢弃吗？", ConfirmFn, null, "确定", "取消");
			}
		}
		
		private function ConfirmFn():Boolean
		{
			var obj:ZObject = m_gkContext.m_confirmDlgMgr.tempData as ZObject;
			var sendSwap:stSwapObjectPropertyUserCmd = new stSwapObjectPropertyUserCmd();
			sendSwap.dst.location = 0;
			sendSwap.thisID = obj.thisID;
			m_gkContext.sendMsg(sendSwap);
			
			return true;
		}
		
		public function onDragStart(e:DragAndDropEvent):void
		{
			
			m_allWu.showEquipAni(this, 0, 0);
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
			m_allWu.hideEquipAni(this);
			m_objPanel.objectIcon.onDrop();
		}
		
		protected function onDoubleClick(event:MouseEvent):void
		{
			
			var obj:ZObject = m_objPanel.objectIcon.zObject;
			if (obj != null)
			{
				var loc:stObjLocation = this.m_gkContext.m_objMgr.findFirstEmptyGridInBackPack();
				if (loc != null)
				{
					var sendSwap:stSwapObjectPropertyUserCmd = new stSwapObjectPropertyUserCmd();
					sendSwap.thisID = obj.m_object.thisID;
					sendSwap.dst = loc;
					
					m_gkContext.sendMsg(sendSwap);
				}
			}
		
		}		
		
			
	
	}

}