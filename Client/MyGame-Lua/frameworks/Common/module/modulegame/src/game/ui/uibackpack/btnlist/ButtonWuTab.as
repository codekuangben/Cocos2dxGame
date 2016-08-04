package game.ui.uibackpack.btnlist 
{
	import com.bit101.components.ButtonTab;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.PushButton;
	import com.bit101.utils.PanelDrawCreator;
	import com.dgrigg.utils.UIConst;
	import com.dnd.DraggingImage;
	import com.dnd.DragListener;
	import com.dnd.DragManager;
	import common.event.DragAndDropEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import ui.player.PlayerResMgr;
	import modulecommon.scene.beings.NpcBattleBaseMgr;
	import modulecommon.scene.watch.WuHeroProperty_Watch;
	import modulecommon.scene.watch.WuMainProperty_Watch;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.wu.WuMainProperty;
	import modulecommon.scene.wu.WuProperty;
	import com.dgrigg.skins.ISkinButtonPanelDrawCreator;
	/**
	 * ...
	 * @author ...
	 */
	public class ButtonWuTab extends ButtonTab implements DragListener, DraggingImage, ISkinButtonPanelDrawCreator
	{
		public static const WUBTN_WIDTH:int = 130;
		public static const WUBTN_HEIGHT:int = 37;
		
		private var m_gkContext:GkContext;
		private var m_wu:WuProperty;	
		private var m_dragListener:DragListener;
		
		public function ButtonWuTab(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, defaultHandler:Function = null) 
		{
			super(parent, xpos, ypos, defaultHandler);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onBtnWuTabMove);
		}
		
		public function initBtnData(gk:GkContext, wu:WuProperty, dragListener:DragListener = null):void
		{
			m_gkContext = gk;
			m_wu = wu;
			m_dragListener = dragListener;
		
			this.setSkinButtonPanelDraw(this);
		}
		
		public function createPanelDrawCreator(etbtn:uint):PanelDrawCreator		
		{
			var label:Label;
			var panel:Panel;
			var cr:PanelDrawCreator = new PanelDrawCreator();
			var color:uint;
			var wuHero:WuHeroProperty
			
			cr.beginAddCom(WUBTN_WIDTH, WUBTN_HEIGHT);
			
			//btn背景
			panel = new Panel();
			if (UIConst.EtBtnSelected == etbtn)
			{
				panel.setPanelImageSkin("commoncontrol/button/buttonwutab/btn_selected.png");
			}
			else
			{
				panel.setPanelImageSkin("commoncontrol/button/buttonwutab/btn_normal.png");
			}
			cr.addDrawCom(panel);
			
			//圆头像
			panel = new Panel();
			if (m_wu.isMain)
			{
				color = 0xdddddd;
				
				var gender:uint;
				if (m_wu is WuMainProperty_Watch)
				{
					gender = (m_wu as WuMainProperty_Watch).m_uGender;
				}
				else
				{
					gender = (m_wu as WuMainProperty).m_playerMain.gender;
				}
				panel.setPanelImageSkin(m_gkContext.m_context.m_playerResMgr.roundHeadPathName(m_wu.m_uJob, gender, PlayerResMgr.HDMid));
			}
			else
			{
				wuHero = m_wu as WuHeroProperty;
				color = wuHero.colorValue;
				panel.setPanelImageSkin(NpcBattleBaseMgr.composeRoundHeadResName((m_wu as WuHeroProperty).m_npcBase.m_squareHeadName));
			}
			cr.addDrawCom(panel);
			
			//数量图标
			if (wuHero && (wuHero.m_num > 1) && !(wuHero is WuHeroProperty_Watch))
			{
				var panelcontainer:PanelContainer = new PanelContainer();
				panelcontainer.setPanelImageSkin("commoncontrol/panel/numBg.png");
				label = new Label(panelcontainer, 8, 0);
				label.autoSize = false;
				label.align = Component.CENTER;
				label.miaobian = false;
				label.setFontColor(0xaaaaaa);
				label.text = wuHero.m_num.toString();
				label.flush();
				cr.addDrawCom(panelcontainer);
			}
			
			//鬼、仙、神
			if (wuHero && wuHero.add > 0)
			{
				panel = new Panel(null, 95, 2);
				panel.setPanelImageSkin(m_gkContext.m_wuMgr.getWuAddIconName(wuHero.add));
				cr.addDrawCom(panel);
			}
			
			//名字
			var letterSpace:int;
			label = new Label(null, 43, 10);
			label.setFontSize(14);
			label.setBold(true);
			label.setMiaoBianColor(0x202020);
			label.text = m_wu.m_name;
			if (m_wu.m_name.length == 2)
			{
				letterSpace = 16;
			}
			else
			{
				letterSpace = 0;
			}
			label.setFontColor(color);
			label.setLetterSpacing(letterSpace);
			label.flush();
			cr.addDrawCom(label);
			
			cr.endAddCom();
			
			if (UIConst.EtBtnSelected != etbtn)
			{
				cr.setFilter(PushButton.s_funGetFilters(etbtn));
			}
			
			return cr;
		}
		
		public function refresh():void
		{
			this.refreshSkinButtonPanelDraw();
		}
		
		public function get wu():WuProperty
		{
			return m_wu;
		}
		
		public function get wuID():uint
		{
			return m_wu.m_uHeroID;
		}
		
		private function onBtnWuTabMove(event:MouseEvent):void
		{
			if (null == m_dragListener || !isDown || wu.isMain)
			{
				return;
			}
			
			if (true == DragManager.isDragging())
			{
				
			}
			else
			{
				DragManager.startDrag(this, null, this, m_dragListener, true);	
				this.becomeGray();
			}
		}
		
		override protected function onMouseGoUp(event:MouseEvent):void
		{
			super.onMouseGoUp(event);
			if (null == m_dragListener)
			{
				return;
			}
			
			DragManager.drop();
			this.becomeUnGray();
		}
		
		public function getDisplay ():DisplayObject
		{
			var retBm:Bitmap = m_gkContext.m_context.m_dragResPool.getBitmap();
			var retBmData:BitmapData = this.getNormalBitmap();
			if (!retBmData)
			{
				retBmData = m_gkContext.m_context.m_dragResPool.getBitmapData(WUBTN_WIDTH, WUBTN_HEIGHT);
				var shape:Shape=new Shape();
				shape.graphics.beginFill(0x59A3FF);
				shape.graphics.drawRoundRect(0, 0, WUBTN_WIDTH, WUBTN_HEIGHT,10,10);
				shape.graphics.endFill();
				retBmData.draw(shape);
			}
			
			retBm.bitmapData = retBmData;
			retBm.width = WUBTN_WIDTH;
			retBm.height = WUBTN_HEIGHT;
			retBm.x = -WUBTN_WIDTH / 2;
			retBm.y = -WUBTN_HEIGHT / 2;
			
			return retBm;
		}
		
		public function onReadyDrop (e:DragAndDropEvent): void
		{
			
		}
		
		public function onDragDrop (e:DragAndDropEvent) : void
		{
			
		}
		
		public function switchToAcceptImage () : void{}
		public function switchToRejectImage () : void { }
		
		public function onDragEnter (e:DragAndDropEvent) : void{}
		public function onDragExit (e:DragAndDropEvent) : void{}
		public function onDragOverring (e:DragAndDropEvent) : void{}
		public function onDragStart (e:DragAndDropEvent) : void{}
		
	}

}