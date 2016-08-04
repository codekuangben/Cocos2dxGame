package game.ui.uiZhenfa.xiayewulist 
{
	import com.bit101.components.Component;
	import com.bit101.components.controlList.ControlListVHeight;
	import com.bit101.components.controlList.CtrolComponentBase;
	import com.bit101.components.controlList.CtrolVHeightComponent;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.PushButton;
	import com.bit101.utils.PanelDrawCreator;
	import com.dgrigg.utils.UIConst;
	import com.dnd.DraggingImage;
	import com.dnd.DragListener;
	import com.dnd.DragManager;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import ui.player.PlayerResMgr;
	import modulecommon.scene.beings.NpcBattleBaseMgr;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.wu.WuMainProperty;
	import modulecommon.scene.wu.WuProperty;
	import com.dgrigg.skins.ISkinButtonPanelDrawCreator;
	/**
	 * ...
	 * @author ...
	 */
	public class WuBtnItem extends CtrolVHeightComponent implements DraggingImage, ISkinButtonPanelDrawCreator
	{
		public static const WUBTN_WIDTH:int = 130;
		public static const WUBTN_HEIGHT:int = 37;
		
		private var m_gkContext:GkContext;
		private var m_wu:WuProperty;
		private var m_dragListener:DragListener;
		private var m_listCtl:ControlListVHeight;
		
		private var m_btn:PushButton;
		
		public function WuBtnItem(param:Object) 
		{
			m_gkContext = param["gk"] as GkContext;
			m_dragListener = param["dragListener"] as DragListener;
			m_listCtl = param["listCtl"] as ControlListVHeight
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.setSize(WUBTN_WIDTH, WUBTN_HEIGHT);
		}
		
		public function get wu():WuProperty
		{
			return m_wu;
		}
		
		override public function setData(data:Object):void
		{
			super.setData(data);
			m_wu = data as WuProperty;			
		}
		override public function init():void 
		{
			if (m_btn == null)
			{
				m_btn = new PushButton(this, 0, 0);
			}
			m_btn.setSkinButtonPanelDraw(this);
		}
		public function refresh():void
		{
			if (m_bHasShow&&m_btn)
			{
				m_btn.refreshSkinButtonPanelDraw();
			}
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
			panel.setPanelImageSkin("commoncontrol/button/buttonwutab/btn_normal.png");
			cr.addDrawCom(panel);
			
			//圆头像
			panel = new Panel();
			wuHero = m_wu as WuHeroProperty;
			color = wuHero.colorValue;
			panel.setPanelImageSkin(NpcBattleBaseMgr.composeRoundHeadResName((m_wu as WuHeroProperty).m_npcBase.m_squareHeadName));
			cr.addDrawCom(panel);
			
			//数量图标
			if (wuHero.m_num > 1)
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
			if (wuHero.add > 0)
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
			
			cr.setFilter(PushButton.s_funGetFilters(etbtn));
			
			return cr;
		}		
		
		public function onMouseDown(e:MouseEvent):void
		{
			if (null == m_dragListener)
			{
				return;
			}
			
			if (DragManager.isDragging() == true)
			{
				return;
			}
			
			DragManager.startDrag(this, null, this, m_dragListener, true);	
			this.becomeGray();
		}
		
		public function getDisplay():DisplayObject
		{
			var retBm:Bitmap = m_gkContext.m_context.m_dragResPool.getBitmap();
			var retBmData:BitmapData = m_btn.getNormalBitmap();
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
		
		public function switchToAcceptImage () : void
		{
			//
		}
		
		public function switchToRejectImage () : void
		{
			//
		}
		
	}

}