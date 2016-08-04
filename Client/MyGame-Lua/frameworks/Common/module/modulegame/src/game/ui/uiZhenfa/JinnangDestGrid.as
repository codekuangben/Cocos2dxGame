package game.ui.uiZhenfa
{
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.dnd.DragListener;
	import com.dnd.DragManager;
	import com.pblabs.engine.debug.Logger;
	
	import common.event.DragAndDropEvent;
	
	//import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	//import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	//import flash.geom.Rectangle;
	
	import modulecommon.GkContext;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.net.msg.sceneHeroCmd.stSetJinNangCmd;
	import modulecommon.net.msg.sceneHeroCmd.stTakeDownKitCmd;
	//import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.prop.skill.JinnangIcon;
	//import modulecommon.scene.prop.skill.SkillMgr;
	//import com.util.UtilHtml;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 * 用Component::tag表示格子编号
	 */
	public class JinnangDestGrid extends PanelContainer implements DragListener
	{
		private var m_bOpen:Boolean;
		private var m_lockPanel:Panel;
		private var m_iconPanel:JinnangIcon;
		private var m_uGridID:uint;
		private var m_uizhenfa:UIZhenfa;
		private var m_gkContext:GkContext;
		private var m_jinnangpanel:JinNangPanel;
		public function JinnangDestGrid(ui:UIZhenfa, parent:DisplayObjectContainer, xPos:int, yPos:int, gk:GkContext, gridID:uint)
		{
			super(parent, xPos, yPos);
			this.setDropTrigger(true);
			m_gkContext = gk;
			m_uGridID = gridID;
			m_uizhenfa = ui;
			m_jinnangpanel = (parent as JinNangPanel);
			
			m_iconPanel = new JinnangIcon(m_gkContext);
			this.addChild(m_iconPanel);
			m_iconPanel.setPos(4, 4);
			this.setSize(48, 48);
			this.setPanelImageSkin("commoncontrol/panel/objectBG3.png");
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			this.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
		}
		
		public function updateLockState():void
		{
			var bCreate:Boolean = false;
			if (m_uGridID == 0)
			{
				if (!m_gkContext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_JINNANG))
				{
					bCreate = true;
				}
			}
			else if (m_uGridID == 1)
			{
				if (m_gkContext.playerMain.level < 30)
				{
					bCreate = true;
				}
			}
			else
			{
				if (m_gkContext.playerMain.level < 50)
				{
					bCreate = true;
				}
			}
			
			if (bCreate && null == m_lockPanel)
			{
				m_lockPanel = new Panel(this, 3, 3);
				m_lockPanel.setSize(40, 40);
				m_lockPanel.setPanelImageSkin("skillicon/lock.png");
			}
			
			if (m_lockPanel)
			{
				if (open)
				{
					m_lockPanel.visible = false;
				}
				else
				{
					m_lockPanel.visible = true;
				}
			}
			
		}
		
		override public function dispose():void
		{
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			this.removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			super.dispose();
		}
		
		public function setJinang(idInit:uint):void
		{
			m_iconPanel.setSkillID(m_gkContext.m_wuMgr.jinangIDLevel(idInit));
			if (m_iconPanel.jinnang == null)
			{
				m_gkContext.addLog("没有武将拥有锦囊ID=" + idInit.toString);
				return;
			}
			m_jinnangpanel.setDescJinnang(m_iconPanel.jinnang.idLevel);
			
			if (m_gkContext.m_newHandMgr.isVisible() && m_gkContext.m_sysnewfeatures.m_nft == SysNewFeatures.NFT_JINNANG && m_uGridID == 0)
			{
				m_gkContext.m_sysnewfeatures.m_nft = SysNewFeatures.NFT_NONE;
				//m_gkContext.m_newHandMgr.promptOver();
				//m_uizhenfa.newHandMoveToExitBtn();
				m_gkContext.m_newHandMgr.hide();
			}
		}
		
		public function clear():void
		{
			m_iconPanel.remove();
			m_jinnangpanel.setDescJinnang(0);
		}
		
		public function set open(open:Boolean):void
		{
			m_bOpen = open;
		}
		
		public function get open():Boolean
		{
			return m_bOpen;
		}
		
		public function onMouseDown(e:MouseEvent):void
		{
			if (DragManager.isDragging() == true)
			{
				if (!m_gkContext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_JINNANG))
				{
					m_gkContext.m_systemPrompt.prompt("该功能还未开启");
				}
				return;
			}
			if (m_iconPanel.iconLoaded == false)
			{
				return;
			}
			
			DragManager.startDrag(this, null, m_iconPanel, this);
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			m_gkContext.m_uiTip.hideTip();
			m_gkContext.m_objMgr.hideObjectMouseOverPanel(this);
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			m_gkContext.m_objMgr.showObjectMouseOverPanel(this, -4, -4);
			var str:String;
			var level:uint = m_gkContext.playerMain.level;
			var pt:Point = this.localToScreen(new Point(this.width, this.height));
			if (this.m_uGridID == 1)
			{
				if (level < 30)
				{
					str = "30开放";
				}
			}
			else if (this.m_uGridID == 2)
			{
				if (level < 50)
				{
					str = "50开放";
				}
			}
			if (str != null)
			{
				//str = UtilHtml.formatPDirect(str, 0xcccccc, 12, UtilHtml.LEFT);
				pt.x -= this.width / 2;
				pt.y -= this.height;
				m_gkContext.m_uiTip.hintCondense(pt, str);
				return;
			}
			
			if (m_iconPanel.jinnang == null)
			{
				return;
			}
			
			m_gkContext.m_uiTip.hintSkillInfo(pt, m_iconPanel.jinnang.idLevel);
		}
		
		public function onReadyDrop(e:DragAndDropEvent):void
		{
			if (e.getTargetComponent() is JinnangDestGrid == true)
			{
				var destGrid:JinnangDestGrid = (e.getTargetComponent() as JinnangDestGrid);
				if (destGrid == this)
				{
					DragManager.drop();
					return;
				}
				else
				{
					if (destGrid.open == false)
					{
						return;
					}
					else
					{
						var send:stSetJinNangCmd = new stSetJinNangCmd();
						send.dstID = destGrid.tag;
						send.jinnangID = m_iconPanel.jinnang.idInit;
						m_gkContext.sendMsg(send);
						Logger.info(null, null, "JinnangGrid::onReadyDrop - send: " + "stSetJinNangCmd" + "(" + m_iconPanel.jinnang.idInit + "," + send.dstID + ")");
						return;
					}
				}
			}
			else
			{
				var sendDrop:stTakeDownKitCmd = new stTakeDownKitCmd();
				sendDrop.kitPos = this.tag;
				m_gkContext.sendMsg(sendDrop);
				return;
			}
		}
		
		public function onDragDrop(e:DragAndDropEvent):void
		{
			m_iconPanel.onDrop();
		}
		
		public function onDragEnter(e:DragAndDropEvent):void
		{
		}
		
		public function onDragExit(e:DragAndDropEvent):void
		{
		}
		
		public function onDragOverring(e:DragAndDropEvent):void
		{
		}
		
		public function onDragStart(e:DragAndDropEvent):void
		{
			m_iconPanel.onDrag();
		}
	}

}