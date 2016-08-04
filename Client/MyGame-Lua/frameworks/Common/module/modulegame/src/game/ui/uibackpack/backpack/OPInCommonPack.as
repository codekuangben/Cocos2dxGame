package game.ui.uibackpack.backpack 
{
	import com.bit101.components.Panel;
	import com.dnd.DragManager;
	import flash.events.MouseEvent;
	import modulecommon.scene.prop.object.ObjectPanel;
	import modulecommon.scene.prop.object.Package;
	import modulecommon.scene.prop.object.stObjLocation;
	import modulecommon.ui.UIFormID;
	import game.ui.uibackpack.msg.stReqOpenMainPackGeZiUserCmd;
	
	import flash.display.DisplayObjectContainer;
	import modulecommon.GkContext;
	/**
	 * ...
	 * @author 
	 */
	public class OPInCommonPack extends ObjectPanel 
	{		
		private var m_bLock:Boolean;
		private var m_lockPanel:Panel;
		private var m_openGridInTime:OpenGridInTime;
		private var m_bInSale:Boolean;
		public function OPInCommonPack(gk:GkContext, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(gk, parent, xpos, ypos);
			m_gkContext = gk;		
		}
		
		public function set lock(bFlag:Boolean):void
		{
			if (m_bLock == bFlag)
			{
				return;
			}
			if (bFlag == true)
			{
				this.mouseChildren = true;
				m_lockPanel = new Panel(this, 3, 3);
				m_lockPanel.setPanelImageSkin("commoncontrol/panel/objectlock.png");
				m_lockPanel.addEventListener(MouseEvent.CLICK, onLockPanelClick);				
			}
			else
			{
				this.mouseChildren = false;
				if (m_lockPanel)
				{
					this.removeChild(m_lockPanel);
					m_lockPanel.removeEventListener(MouseEvent.CLICK, onLockPanelClick);
					m_lockPanel.dispose();
					m_lockPanel = null;
				}
				
				if (m_openGridInTime)
				{
					this.removeChild(m_openGridInTime);
					m_openGridInTime.removeEventListener(MouseEvent.CLICK, onLockPanelClick);
					m_openGridInTime.dispose();
					m_openGridInTime = null;
				}
			}
			m_bLock = bFlag;
		}
		public function get lock():Boolean
		{
			return m_bLock;
		}
		
		public function setOpenNext():void
		{
			if (m_openGridInTime == null)
			{
				m_openGridInTime = new OpenGridInTime(m_gkContext, this, 4, 4);
				m_openGridInTime.addEventListener(MouseEvent.CLICK, onLockPanelClick);
			}
			if (m_lockPanel)
			{
				m_lockPanel.visible = false;
			}
		}
		
		public function onUIBackPackShow():void
		{
			if (m_openGridInTime)
			{
				m_openGridInTime.onShowEx();
			}
		}
		public function onUIBackPackHide():void
		{
			if (m_openGridInTime)
			{
				m_openGridInTime.onHideEx();
			}
		}
		
		public function onLockPanelClick(e:MouseEvent):void
		{
			if (DragManager.isDragging() == true)
			{
				return;
			}
			
			//包裹开启新规则：提升Vip等级，或在线等待，均可开启新包裹
			
			/*
			var pac1:Package = m_gkContext.m_objMgr.getCommonPackage(stObjLocation.OBJECTCELLTYPE_COMMON1);
			var pac2:Package = m_gkContext.m_objMgr.getCommonPackage(stObjLocation.OBJECTCELLTYPE_COMMON2);
			var pac3:Package = m_gkContext.m_objMgr.getCommonPackage(stObjLocation.OBJECTCELLTYPE_COMMON3);
			
			var numOpened:int = pac1.openedSize + pac2.openedSize + pac3.openedSize;
			
			var curIndex:int=(this.m_location.location - stObjLocation.OBJECTCELLTYPE_COMMON1) * pac1.size +
			m_location.y * pac1.iWidth + m_location.x + 1;	//based 1
			
			var num:int = curIndex - numOpened;
			var i:int;
			var cost:int = 0;
			for (i = numOpened - 20 + 1; i <= curIndex - 20; i++)
			{
				cost += Math.floor((i + 5) / 5) * 2;
			}
			var str:String = "是否要开启 " + num + " 个格子?\n" + "( 花费 " + cost + " 元宝 )";
			m_gkContext.m_confirmDlgMgr.tempData = num;
			m_gkContext.m_confirmDlgMgr.showMode1(UIFormID.UIBackPack, str,openGridsOnConfirm,null);	
			*/
		}
		
		private function openGridsOnConfirm():Boolean
		{
			var send:stReqOpenMainPackGeZiUserCmd = new stReqOpenMainPackGeZiUserCmd();
			send.m_num = m_gkContext.m_confirmDlgMgr.tempData as int;
			m_gkContext.sendMsg(send);
			return true;
		}
		
		public function set bInSale(b:Boolean):void
		{
			if (b == m_bInSale)
			{
				return;
			}
			m_bInSale = b;
			if (m_bInSale)
			{
				this.becomeGray();
			}
			else
			{
				this.becomeUnGray();
			}
		}
		
		public function get canOperation():Boolean
		{
			return !m_bInSale;
		}
		
	}

}