package game.ui.uibackpack.backpack 
{
	import com.bit101.components.Ani;
	import com.bit101.components.label.Label2;
	import com.bit101.components.label.LabelFormat;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.gamecursor.GameCursor;
	import com.pblabs.engine.core.InputKey;
	import modulecommon.scene.prop.object.Package;
	
	import com.dnd.DragManager;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.GkContext;
	import modulecommon.net.msg.propertyUserCmd.stSwapObjectPropertyUserCmd;
	import modulecommon.scene.prop.object.ObjectIcon;
	import modulecommon.scene.prop.object.ObjectPanel;
	import modulecommon.scene.prop.object.stObjLocation;
	import modulecommon.scene.prop.object.ZObject;
	import com.pblabs.engine.resource.SWFResource;
	
	import modulecommon.scene.prop.object.ZObjectDef;
	import modulecommon.scene.wu.WuProperty;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class PackagePanel extends PanelContainer
	{
		public static const WIDTH:int = 5;
		public static const HEIGHT:int = 6;
		private static const NUMSLOT:int = WIDTH * NUMSLOT;
		
		private var m_backPack:BackPack;
		private var m_gkContext:GkContext;
		private var m_useObj:UseObject;
		
		private var m_vecPanel:Vector.<OPInCommonPack>;
		private var m_label:Label2
		private var m_packageNo:uint;	//其取值为stObjLocation.OBJECTCELLTYPE_COMMON1等
		private var m_parent:DisplayObjectContainer;		
		
		public function PackagePanel(gk:GkContext, bp:BackPack, no:uint, xpos:Number = 0, ypos:Number = 0) 
		{ 
			m_parent = bp;
			this.setPos(xpos, ypos);
			this.cacheAsBitmap = true;
			m_gkContext = gk;
			m_backPack = bp;
			m_packageNo = no;
			var i:int = 0;
			var j:int = 0;
			var k:int = 0;
			var left:int = 8;  
			var top:int = 15;
			var interval:int = 52;
			var panel:OPInCommonPack;
			m_useObj = new UseObject(gk, m_backPack);
			m_vecPanel = new Vector.<OPInCommonPack>(NUMSLOT);			
			
			for (i = 0; i < HEIGHT; i++)
			{
				left = 8;
				for (j = 0; j < WIDTH; j++)
				{					
					panel = new OPInCommonPack(m_gkContext, this, left, top);
					panel.setSize(ZObject.IconBgSize, ZObject.IconBgSize);
					//panel.setPanelImageSkin(ZObject.IconBg);
					panel.gridX = j;
					panel.gridY = i;
					panel.objLocation.heroid = WuProperty.MAINHERO_ID;
					panel.objLocation.location = m_packageNo;
					panel.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					
					panel.addEventListener(MouseEvent.ROLL_OUT, m_gkContext.hideTipOnMouseOut);
					panel.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
					panel.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
					panel.mouseChildren = false;
					panel.doubleClickEnabled = true;				
					
					m_vecPanel[k] = panel;
					k++;
					left += interval;
				}
				top += interval + 2;
			}			
			
			if (m_packageNo == stObjLocation.OBJECTCELLTYPE_BAOWU)
			{
				m_label = new Label2(this, 55, 425);
				var lf:LabelFormat = new LabelFormat();
				lf.color = 0x5CB656;
				lf.text = "宝物只用于酒馆中招募紫将...";
				lf.bMiaobian = false;
				m_label.labelFormat = lf;
			}
		}
		
		public function initData():void
		{		
			initObjects();
			
			var op:OPInCommonPack = m_backPack.getNextOpenGrid();
			if (m_vecPanel.indexOf(op) != -1)
			{
				op.setOpenNext();
				op.onUIBackPackShow();
			}
		}
		
		public function initObjects():void
		{
			var pac:Package = m_gkContext.m_objMgr.getPakage(WuProperty.MAINHERO_ID, m_packageNo);
			pac.execFun(addObjectOnInit);
			updateLocState();
		}
		
		public function clearAllObjects():void
		{			
			var op:OPInCommonPack;
			for each(op in m_vecPanel)
			{
				op.objectIcon.removeZObject();
			}
		}
		public function updateLocState():void
		{
			if (m_packageNo == stObjLocation.OBJECTCELLTYPE_BAOWU)
			{
				return;
			}
			var pac:Package = m_gkContext.m_objMgr.getPakage(WuProperty.MAINHERO_ID, m_packageNo);
			var i:int;
			var size:int = m_vecPanel.length;
			var sizeUnLock:int = pac.openedSize;
			var b:Boolean;
			for (i = 0; i < size; i++)
			{
				if (i < sizeUnLock)
				{
					b = false;
				}
				else
				{
					b = true;
				}
				m_vecPanel[i].lock = b;
			}			
		}
		
		private function addObjectOnInit(obj:ZObject, param:Object):void
		{
			addObject(obj);
		}
		
		public function objectPanelInPos(gridX:int, gridY:int):ObjectPanel
		{
			return m_vecPanel[gridY * WIDTH + gridX];
		}
		public function objectIconInPos(gridX:int, gridY:int):ObjectIcon
		{
			return m_vecPanel[gridY * WIDTH + gridX].objectIcon;
		}
		
		public function OPInCommonPackInPos(gridX:int, gridY:int):OPInCommonPack
		{
			return m_vecPanel[gridY * WIDTH + gridX];
		}
		
		public function getObjectPanelByIndex(index:int):OPInCommonPack
		{
			return m_vecPanel[index];
		}
		public function addObject(obj:ZObject):void
		{
			var objIcon:ObjectIcon = objectIconInPos(obj.m_object.m_loation.x, obj.m_object.m_loation.y);
			var levelPlayer:int = m_gkContext.playerMain.level;
			if (levelPlayer < obj.needLevel)
			{
				objIcon.redMask = true;
			}
			else
			{
				objIcon.redMask = false;
			}
			objIcon.setZObject(obj);
		}
		public function removeObject(obj:ZObject):void
		{
			objectIconInPos(obj.m_object.m_loation.x, obj.m_object.m_loation.y).removeZObject();
		}
		public function updateObject(obj:ZObject):void
		{
			objectIconInPos(obj.m_object.m_loation.x, obj.m_object.m_loation.y).freshIcon();
		}
		
		public function onAddToSale(obj:ZObject):void
		{
			OPInCommonPackInPos(obj.m_object.m_loation.x, obj.m_object.m_loation.y).bInSale = true;
		}
		public function onRemoveToSale(obj:ZObject):void
		{
			OPInCommonPackInPos(obj.m_object.m_loation.x, obj.m_object.m_loation.y).bInSale = false;
		}
		public function updateAllObjects():void
		{
			var panel:ObjectPanel;
			var objIcon:ObjectIcon;
			var levelPlayer:int = m_gkContext.playerMain.level;
			for each(panel in m_vecPanel)
			{
				objIcon = panel.objectIcon;
				if (objIcon.zObject && objIcon.redMask)
				{
					if (levelPlayer >= objIcon.zObject.needLevel)
					{
						objIcon.redMask = false;
					}
				}
			}
		}
		
		public function onMouseDown(e:MouseEvent):void
		{
			if (m_gkContext.m_context.m_gameCursor.cmdState != GameCursor.CMDSTATE_None)
			{
				return;
			}
			
			var panel:OPInCommonPack = e.currentTarget as OPInCommonPack;
			if (panel == null)
			{
				return;
			}
			
			if (panel.canOperation == false)
			{
				return;
			}
			if (DragManager.isDragging() == true)
			{
				var dragPanel:ObjectPanel = DragManager.getDragInitiator() as ObjectPanel;
				if (dragPanel == panel)
				{
					DragManager.drop();
				}
				return;
			}
			
			if (panel.objectIcon.zObject == null || panel.objectIcon.loaded==false)
			{
				return;
			}
			if (this.m_gkContext.m_context.m_inputManager.isKeyDown(InputKey.SHIFT.keyCode))
			{
				m_gkContext.m_uiChat.exhibitZObject(panel.objectIcon.zObject);
				return;
			}
			if (m_useObj.objMenu(panel.objectIcon) == true)
			{
				m_useObj.m_pos.x = 0;
				m_useObj.m_pos.y = -20;
				m_useObj.m_pos = panel.localToScreen(m_useObj.m_pos);
				e.stopImmediatePropagation();
				return;
			}
			
			DragManager.startDrag(panel, null, panel.objectIcon, m_backPack,true);	
			panel.objectIcon.onDrag();
			
			// 播放音效
			m_gkContext.m_commonProc.playMsc(10);
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			if (event.currentTarget is ObjectPanel)
			{
				var panel:ObjectPanel = event.currentTarget as ObjectPanel;
				var pt:Point = panel.localToScreen();
				
				var obj:ZObject = panel.objectIcon.zObject;
				if (obj != null)
				{					
					m_gkContext.m_uiTip.hintObjectInfo(pt, obj, this.m_backPack.curHeroID);
				}
			}			
		}
		
		protected function onDoubleClick(event:MouseEvent):void
		{
			if (m_gkContext.m_context.m_gameCursor.cmdState != GameCursor.CMDSTATE_None)
			{
				return;
			}
			if (event.currentTarget is OPInCommonPack)
			{
				var panel:OPInCommonPack = event.currentTarget as OPInCommonPack;
				if (panel.canOperation == false)
				{
					return;
				}
				var obj:ZObject = panel.objectIcon.zObject;
				if (obj != null)
				{
					if (m_useObj.directUseObj(obj) == true)
					{
						m_useObj.m_pos.x = 0;
						m_useObj.m_pos.y = -20;
						m_useObj.m_pos = panel.localToScreen(m_useObj.m_pos);
						m_gkContext.m_uiMenu.exit();
						return;
					}
					if (obj.needLevel > m_gkContext.playerMain.level)
					{
						var pt:Point = m_gkContext.m_context.mouseScreenPos();
						pt.y -= 50;
						m_gkContext.m_systemPrompt.prompt("人物等级不足", pt);
						return;
					}
					
					var sendSwap:stSwapObjectPropertyUserCmd = new stSwapObjectPropertyUserCmd();
					sendSwap.thisID = obj.m_object.thisID;
					sendSwap.dst.heroid = this.m_backPack.curHeroID;					
					if (sendSwap.dst.heroid == WuProperty.MAINHERO_ID)
					{
						sendSwap.dst.location = stObjLocation.OBJECTCELLTYPE_UEQUIP;
					}
					else
					{
						sendSwap.dst.location = stObjLocation.OBJECTCELLTYPE_HEQUIP;
					}
					sendSwap.dst.y = ZObjectDef.typeToEquipPos(obj.type);
					//trace(sendSwap.dst.heroid.toString() +"," +sendSwap.dst.location.toString()+"," +sendSwap.dst.y.toString());
					m_gkContext.sendMsg(sendSwap);
				}
			}
		}
		
		public function get no():uint
		{
			return m_packageNo;
		}
		
		public function show():void
		{
			if (this.parent != m_parent)
			{
				m_parent.addChild(this);
			}
		}
		
		public function hide():void
		{
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
		}	
	}

}