package game.ui.uiZhenfa 
{
	import com.bit101.components.controlList.CtrolComponent;
	//import com.bit101.components.Panel;
	//import com.dgrigg.image.PanelImage;
	import com.dnd.DragManager;
	//import flash.display.DisplayObject;
	import common.event.DragAndDropEvent;
	//import com.dnd.DraggingImage;
	import com.dnd.DragListener;
	//import flash.display.Bitmap;
	//import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	//import flash.geom.Rectangle;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.GkContext;
	import modulecommon.net.msg.sceneHeroCmd.stSetJinNangCmd;
	import modulecommon.scene.prop.skill.SkillMgr;
	import modulecommon.scene.wu.JinnangItem;
	import com.pblabs.engine.debug.Logger;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.prop.skill.JinnangIcon;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class JinnangGrid extends CtrolComponent  implements DragListener
	{
		private var m_iconPanel:JinnangIcon;
		private var m_jinnangItem:JinnangItem;
		private var m_gkContext:GkContext;
		private var m_jinnangpanel:JinNangPanel;
		
		public function JinnangGrid(param:Object) 
		{
			m_gkContext = param["gk"] as GkContext;
			m_jinnangpanel = param["jinnang"] as JinNangPanel;
			
			m_iconPanel = new JinnangIcon(m_gkContext);
			this.addChild(m_iconPanel);
			m_iconPanel.x = 3;
			m_iconPanel.y = 3;
			m_iconPanel.setSize(SkillMgr.ICONSIZE_Normal, SkillMgr.ICONSIZE_Normal);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			this.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			this.setDropTrigger(true);
			
			this.setSize(ZObject.IconBgSize, ZObject.IconBgSize);
			this.setPanelImageSkin(ZObject.IconBg);
		}
		
		override public function dispose():void
		{
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			this.removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			
			super.dispose();
		}
		
		public override function setData(data:Object):void
		{
			super.setData(data);
			m_jinnangItem = data as JinnangItem;
			m_iconPanel.setSkillID(m_jinnangItem);	
		}
		
		public function onMouseDown(e:MouseEvent):void
		{
			if (DragManager.isDragging() == true)
			{
				return;
			}
			if (m_iconPanel.iconLoaded == false)
			{
				return;
			}
			
			if (m_gkContext.m_newHandMgr.isVisible() && m_gkContext.m_sysnewfeatures.m_nft == SysNewFeatures.NFT_JINNANG)
			{
				m_gkContext.m_newHandMgr.promptOver();
				m_jinnangpanel.showNewHand();
			}
			
			DragManager.startDrag(this, null, m_iconPanel, this);
			
			// 播放音效
			m_gkContext.m_commonProc.playMsc(10);
		}
		override protected function onMouseOut(event:MouseEvent):void
		{
			super.onMouseOut(event);
			m_gkContext.m_uiTip.hideTip();
			m_gkContext.m_objMgr.hideObjectMouseOverPanel(this);
		}
		override protected function onMouseOver(event:MouseEvent):void
		{
			super.onMouseOver(event);
			var pt:Point = this.localToScreen(new Point(this.width, 0));
			m_gkContext.m_uiTip.hintSkillInfo(pt, m_jinnangItem.idLevel);		
			m_gkContext.m_objMgr.showObjectMouseOverPanel(this, -4, -4);
		}		
		
		public function onReadyDrop (e:DragAndDropEvent) : void
		{			
			
			if (e.getTargetComponent() is JinnangDestGrid == false)
			{
				if (!m_gkContext.m_newHandMgr.isVisible())
				{
					DragManager.drop();
				}
				return;
			}
			
			var destGrid:JinnangDestGrid = (e.getTargetComponent() as JinnangDestGrid);
			if (destGrid.open)
			{
				var send:stSetJinNangCmd = new stSetJinNangCmd();
				send.dstID = destGrid.tag;
				send.jinnangID = m_jinnangItem.idInit;			
				m_gkContext.sendMsg(send);
				Logger.info(null, null, "JinnangGrid::onReadyDrop - send: " + "stSetJinNangCmd" + "(" + m_jinnangItem.idInit + "," + send.dstID +")");
				
				var pt:Point = m_gkContext.m_context.mouseScreenPos();
				pt.y -= 50;
				m_gkContext.m_systemPrompt.prompt("锦囊设置成功", pt);
			}
		}
		public function onDragDrop (e:DragAndDropEvent) : void
		{
			m_iconPanel.onDrop();
		}

		public function onDragEnter (e:DragAndDropEvent) : void{}

		public function onDragExit (e:DragAndDropEvent) : void{}

		public function onDragOverring (e:DragAndDropEvent) : void{}

		public function onDragStart (e:DragAndDropEvent) : void
		{
			m_iconPanel.onDrag();
		}
	}

}