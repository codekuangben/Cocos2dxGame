package game.ui.uiviptiyan
{
	import com.bit101.components.AniZoom;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.util.UtilCommon;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import game.ui.uilqwj.msg.stReqQuickCoolOnlineGiftCmd;
	import game.ui.uiviptiyan.msg.reqPracticeVipUserCmd;
	//import modulecommon.net.msg.activityCmd.getVip3PracticeRewardCmd;
	import modulecommon.ui.Form;
	import modulecommon.uiinterface.IUIVipTiYan;
	import modulecommon.ui.UIFormID;
	
	/**
	 * @brief 领取武将
	 */
	public class UIVipTiYan extends Form implements IUIVipTiYan
	{
		protected var m_pnlBG:Panel;	// 背景面板
		protected var _exitBtn:PushButton;
		protected var m_pnlZunGui:AniZoom;	// 最贵
		protected var m_pnlTeQuan:AniZoom;	// 特权
		protected var m_pnlLiBao:AniZoom;	// 礼包

		protected var m_btnTY:PushButton;	// 体验按钮
		protected var m_btnCZ:PushButton;	// 充值按钮
		protected var m_JLLst:JLLst;		// 奖励物品列表
		
		public function UIVipTiYan()
		{
			this.id = UIFormID.UIVipTiYan;
		}
		
		override public function onReady():void
		{
			super.onReady();
			this.setSize(898, 432);
			
			m_pnlBG = new Panel(this);
			this.addBackgroundChild(m_pnlBG);
			m_pnlBG.setPanelImageSkin("module/viptiyan/formbg.png");
			
			_exitBtn = new PushButton(this, 787, 30);
			_exitBtn.setSkinButton1Image("commoncontrol/button/closebtn1.png");
			_exitBtn.addEventListener(MouseEvent.CLICK, onExitBtnClick);
			
			m_pnlZunGui = new AniZoom(this, 400, 102);
			m_pnlZunGui.setImageAni("module/viptiyan/quangui.png");
			m_pnlZunGui.setParam(0.9, 1.1, 7, 33, 22, true);
			m_pnlZunGui.begin();
			
			m_pnlTeQuan = new AniZoom(this, 400, 152);
			m_pnlTeQuan.setImageAni("module/viptiyan/tequan.png");
			m_pnlTeQuan.setParam(0.9, 1.1, 7, 33, 22, true);
			m_pnlTeQuan.begin();
			
			m_pnlLiBao = new AniZoom(this, 400, 202);
			m_pnlLiBao.setImageAni("module/viptiyan/libao.png");
			m_pnlLiBao.setParam(0.9, 1.1, 7, 33, 22, true);
			m_pnlLiBao.begin();
			
			m_btnTY = new PushButton(this, 413, 233, onBtnTY);
			m_btnTY.setPanelImageSkin("module/viptiyan/viptiyanbtn2.swf");
			
			m_btnCZ = new PushButton(this, 615, 233, onBtnCZ);
			m_btnCZ.setPanelImageSkin("module/viptiyan/viptiyanbtn1.swf");
			
			m_JLLst = new JLLst(m_gkcontext, this, 175, 308);
			m_JLLst.m_form = this;
			m_JLLst.setData(m_gkcontext.m_rechargeRebateMgr.getJLLstByYuanBao(1000))
			
			updateBtnEnbale(m_gkcontext.m_vipTY.canEnableTY());
		}
		
		private function onBtnTY(event:MouseEvent):void
		{
			var cmd:reqPracticeVipUserCmd = new reqPracticeVipUserCmd();
			m_gkcontext.sendMsg(cmd);
			
			exit();
		}

		private function onBtnCZ(event:MouseEvent):void
		{
			m_gkcontext.m_context.m_platformMgr.openRechargeWeb();
			//var param:Object = new Object();
			//param.state = 1;
			//update(param);
		}
		
		public function update(param:Object = null):void 
		{
			if (param.type == 1)
			{
				if (UtilCommon.isSetUint((param.state as uint), 1))
				{
					m_JLLst.updateNoReceiveBtn();
				}
			}
			else
			{
				if (param.state == 1)		// 只有 vip3 的需要更新
				{
					m_JLLst.updateBtnToReceive();
					
					// 玩家如果领取体验后，3小时倒计时结束，那么活动图标消失
					//m_gkcontext.m_vipTY.clearDJS();
					//m_gkcontext.m_vipTY.clearActiveIcon();
					//exit();
				}
			}
		}
		
		public function updateBtnEnbale(benable:Boolean):void
		{
			m_btnTY.enabled = benable;
		}
		
		// 收到这个消息，就说明领取过消息了
		public function psgetVip3PracticeRewardCmd(msg:ByteArray):void
		{
			//var cmd:getVip3PracticeRewardCmd = new getVip3PracticeRewardCmd();
			//cmd.deserialize(byte);
			
			m_JLLst.updateBtnToReceive();
		}
	}
}