package game.ui.tongquetai.forestage 
{
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.progressBar.BarInProgress2;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import game.netmsg.stWuNvCmd.stReqOpenWuNvUIUserCmd;
	import game.ui.tongquetai.forestage.friendDancers.FriendDancerPanel;
	import game.ui.tongquetai.forestage.mydancers.MyDancerPanel;
	import game.ui.tongquetai.msg.FriendWuNvState;
	import modulecommon.scene.prop.BeingProp;
	import com.util.UtilColor;
	import modulecommon.ui.Form;
	import modulecommon.ui.FormStyleExitBtn;
	import modulecommon.ui.UIFormID
	import com.bit101.components.Component;
	import modulecommon.uiinterface.IUITongQueWuHui;
	import modulecommon.scene.tongquetai.DancingWuNv;
	import modulecommon.net.msg.wunvCmd.stWuNvCmd;
	import modulecommon.scene.sysbtn.SysbtnMgr;
	/**
	 * ...
	 * @author ...
	 */
	public class UITongQueWuHui extends FormStyleExitBtn implements IUITongQueWuHui
	{
		private var friendPenal:FriList;
		private var m_myPanel:MyDancerPanel;
		private var m_friendDancingPanel:FriendDancerPanel;
		private var modelPanel:Panel;
		public var leftnpc:Panel;
		public var rightnpc:Panel;
		private var redribbon:Panel;
		public var m_haoganBar:BarInProgress2;
		private var m_haoganText:Label;
		public function UITongQueWuHui() 
		{
			super();
			_hitYMax = 48;
			
			this.exitMode = EXITMODE_HIDE;
			setAniForm(70);
			timeForTimingClose = 20;
		}
		override public function onReady():void 
		{
			super.onReady();
			this.setSize(1003, 573);
			this.setPanelImageSkin("commoncontrol/panel/tongquetai/wuhuibg.png");
			m_exitBtn.setPos(973,21);
			m_exitBtn.setSkinButton1Image("commoncontrol/button/closebtn1.png");
			friendPenal = new FriList(m_gkcontext, this, 780, 66);
			friendPenal.show();
			modelPanel = new Panel(this, 147, 195);
			leftnpc = new Panel(this, 128, 367);
			leftnpc.setPanelImageSkin("commoncontrol/panel/tongquetai/npc1.png")
			rightnpc = new Panel(this,425,377);
			rightnpc.setPanelImageSkin("commoncontrol/panel/tongquetai/npc2.png")
			m_myPanel = new MyDancerPanel(m_gkcontext, modelPanel);
			m_myPanel.init();
			m_myPanel.show();
			m_friendDancingPanel = new FriendDancerPanel(this, m_gkcontext, modelPanel);
			m_gkcontext.m_tongquetaiMgr.m_uiWuhui = this;	
			var panel:Panel = new Panel(this, 742, 531);
			panel.setPanelImageSkin("commoncontrol/panel/tongquetai/barbg.png");
			m_haoganBar = new BarInProgress2(this, panel.x,panel.y);
			m_haoganBar.setSize(231, 17);
			m_haoganBar.setPanelImageSkin("commoncontrol/panel/tongquetai/bar.png");
			m_haoganBar.maximum = 1;
			m_haoganText = new Label(this, m_haoganBar.x + 80, m_haoganBar.y -1);
			m_haoganText.setFontColor(UtilColor.WHITE_Yellow);
			var haogan:int = m_gkcontext.m_beingProp.getMoney(BeingProp.MONEY_WUNV);
			m_haoganBar.initValue = haogan / m_gkcontext.m_tongquetaiMgr.haoganUpperLimit;
			m_haoganText.text = "好感:"+haogan;
		}
		
		override public function onShow():void 
		{
			super.onShow();
			
			var send:stReqOpenWuNvUIUserCmd = new stReqOpenWuNvUIUserCmd();
			m_gkcontext.sendMsg(send);
			swichToMyPanel();
			if (m_gkcontext.m_tongquetaiMgr.getNumOfDancing() == 0)
			{
				showFormTongQueTai();
			}
			if (friendPenal)
			{
				friendPenal.m_curhaoyou = -1;
			}
		}
		override public function onHide():void 
		{
			super.onHide();
			m_friendDancingPanel.onHide();
			m_myPanel.hide();
		}
		override public function dispose():void 
		{
			m_gkcontext.m_context.m_uiObjMgr.releaseAllObjectByPartialName("tongquetai.forestageWuhui");
			super.dispose();			
			
			if (m_friendDancingPanel.parent == null)
			{
				m_friendDancingPanel.dispose();
			}
			if (m_myPanel.parent == null)
			{
				m_myPanel.dispose();
			}		
			m_gkcontext.m_tongquetaiMgr.m_uiWuhui = null;
			
		}
		
		public function addDancing(dancer:DancingWuNv):void
		{
			m_myPanel.addDancing(dancer);
		}
		
		public function removeDancing(dancer:DancingWuNv):void
		{
			m_myPanel.removeDancing(dancer);
		}
		public function becomeOver(dancer:DancingWuNv):void
		{
			m_myPanel.becomeOver(dancer);
		}
		public function updateHaogan():void
		{
			var haogan:int = m_gkcontext.m_beingProp.getMoney(BeingProp.MONEY_WUNV);
			m_haoganBar.value = haogan / m_gkcontext.m_tongquetaiMgr.haoganUpperLimit;
			m_haoganText.text = "好感:"+haogan;
		}
		private function showFormTongQueTai():void
		{
			var formTongQueTai:Form = m_gkcontext.m_UIMgr.createFormInGame(UIFormID.UITongQueTai);
			formTongQueTai.show();	
		}
		public function processMsg(msg:ByteArray, param:uint):void
		{
			switch(param)
			{
				case stWuNvCmd.RET_OPEN_WU_NV_UI_USERCMD:
					{
						friendPenal.process_retOpenWuNvUIUserCmd(msg);
						break;
					}
				case stWuNvCmd.RET_FRIEND_WU_NV_DANCING_USERCMD:
					{
						m_friendDancingPanel.process_stRetFriendWuNvDancingUserCmd(msg);
						break;
					}
			}
		}
		
		public function swichToMyPanel():void
		{
			m_myPanel.show();
			m_friendDancingPanel.hide();
			if (friendPenal)
			{
				friendPenal.m_list.setSeleced( -1);
			}
		}
		public function switchToFriendPanel():void
		{
			m_myPanel.hide();
			m_friendDancingPanel.show();
		}
		
		/*private function backToMyself(e:MouseEvent):void
		{
			
		}	*/
		
		override public function getDestPosForHide():Point 
		{
			if (m_gkcontext.m_UIs.sysBtn)
			{
				var pt:Point = m_gkcontext.m_UIs.sysBtn.getBtnPosInScreenByIdx(SysbtnMgr.SYSBTN_TongqueTai);
				if (pt)
				{
					pt.x -= 13;
					pt.y -= 17;
					return pt;
				}
			}
			return null;
		}
		public function updataFriState(friendWuNv:FriendWuNvState):void
		{
			friendPenal.updataState(friendWuNv.id,friendWuNv);
		}
		public function updataTime(pos:int):void
		{
			if (m_myPanel)
			{
				m_myPanel.updataTime(pos);
			}
		}
		public function showChat(pos:int, str:String):void
		{
			if (m_myPanel)
			{
				m_myPanel.showChat(pos, str);
			}
		}
	}

}