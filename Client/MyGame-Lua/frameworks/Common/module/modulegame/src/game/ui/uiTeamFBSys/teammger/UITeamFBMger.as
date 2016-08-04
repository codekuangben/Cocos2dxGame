package game.ui.uiTeamFBSys.teammger
{
	import com.bit101.components.ButtonText;
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	
	import flash.events.MouseEvent;
	
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUITeamFBSys;
	
	import game.ui.uiTeamFBSys.UITFBSysData;
	import game.ui.uiTeamFBSys.msg.quickInviteOtherAddMultiCopyUserCmd;
	import game.ui.uiTeamFBSys.msg.reqLeaderTakeOffTeamMemberUserCmd;
	import game.ui.uiTeamFBSys.msg.setTeamMemberToLeaderUserCmd;

	/**
	 * @brief 组队成员管理信息
	 * */
	public class UITeamFBMger extends Form
	{
		public var m_TFBSysData:UITFBSysData;
		protected var m_rootCnter:Component;
		
		protected var m_btnTC:PushButton;		// 踢出队伍
		protected var m_btnYQ:PushButton;		// 快捷邀请
		protected var m_btnTZ:PushButton;		// 召唤队友
		protected var m_btnRM:PushButton;		// 任命队长
		
		protected var m_bgPanel:Panel;
		
		protected var m_menLst:Vector.<FBMgerItem>;	// 队员
		protected var m_exitBtn:PushButton;

		public function UITeamFBMger()
		{
			this.id = UIFormID.UITeamFBMger;
		}
		
		override public function onReady():void
		{
			super.onReady();
			m_bCloseOnSwitchMap = false;
			
			this.setSize(558, 401);
			//this.setFormSkin("form1", 250);
			//this.title = "副本成员管理功能";
			
			m_rootCnter = new Component(this);
			m_btnTC = new ButtonText(m_rootCnter, 60, 250, "", onBtnClickTC);
			m_btnTC.setSkinButton1ImageBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsyszx.btntichuduiwu");
			
			m_btnYQ = new ButtonText(m_rootCnter, 60 + 110, 250, "", onBtnClickYQ);
			m_btnYQ.setSkinButton1ImageBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsyszx.btnkuaijieyaoqing");
			
			m_btnTZ = new ButtonText(m_rootCnter, 60 + 2 * 110, 250, "", onBtnClickTZ);
			//m_btnTZ.setSkinButton1ImageBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsyszx.btnzhaohuanduiyou");
			m_btnTZ.setSkinButton1ImageBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsyszx.btntianjiachengyuan");
			
			m_btnRM = new ButtonText(m_rootCnter, 60 + 3 * 110, 250, "", onBtnClickRM);
			m_btnRM.setSkinButton1ImageBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsyszx.btnrenmingduizhang");
			
			m_menLst = new Vector.<FBMgerItem>(3, true);
			var idx:uint = 0;
			while(idx < 3)
			{
				m_menLst[idx] = new FBMgerItem(m_TFBSysData, idx, m_rootCnter, 30 + 176 * idx, 30);
				m_menLst[idx].addEventListener(MouseEvent.CLICK, onItemClkCB);
				++idx;
			}
			
			m_bgPanel = new Panel(null, 0, -80);
			this.addBackgroundChild(m_bgPanel);
			m_bgPanel.setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsyszx.bgduiwuguanli");
			
			m_exitBtn = new PushButton(this, this.width - 30, -14);
			m_exitBtn.m_musicType = PushButton.BNMClose;
			m_exitBtn.setSkinButton1Image("commoncontrol/button/closebtn1.png");
			m_exitBtn.addEventListener(MouseEvent.CLICK, onExitBtnClick);
		}
		
		override public function dispose():void
		{
			var idx:uint = 0;
			while(idx < 3)
			{
				m_menLst[idx].removeEventListener(MouseEvent.CLICK, onItemClkCB);
				++idx;
			}
			
			super.dispose();
		}
		
		protected function onBtnClickTC(e:MouseEvent):void
		{
			if(m_TFBSysData.m_curFBMgerItemIdx >= 0)
			{
				if(m_TFBSysData.isSelfLeader())
				{
					if(!m_TFBSysData.isSelf(m_TFBSysData.m_curFBMgerItemIdx))
					{
						var cmd:reqLeaderTakeOffTeamMemberUserCmd = new reqLeaderTakeOffTeamMemberUserCmd();
						cmd.id = m_TFBSysData.m_teamMemInfo.data[m_TFBSysData.m_curFBMgerItemIdx].id;
						cmd.teamid = m_TFBSysData.m_gkcontext.m_teamFBSys.teamid;
						m_TFBSysData.m_gkcontext.sendMsg(cmd);
					}
				}
				else
				{
					m_gkcontext.m_systemPrompt.prompt("队长才能够使用该功能");
				}
			}
		}
		
		protected function onBtnClickYQ(e:MouseEvent):void
		{
			/*
			var form:IUITeamFBSys = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBSys) as IUITeamFBSys;
			if(form)
			{
				form.openUI(UIFormID.UITeamFBInvite);
			}
			
			exit();
			*/
			var uT:Number = 30 - (m_TFBSysData.m_gkcontext.m_context.m_timeMgr.getCalendarTimeSecond() - m_TFBSysData.m_preClickTime);
			if (m_TFBSysData.m_preClickTime > 0 && uT > 0)
			{
				m_TFBSysData.m_gkcontext.m_systemPrompt.prompt("请在 " + Math.ceil(uT) + "秒 后再进行邀请");
			}
			else
			{
				var cmd:quickInviteOtherAddMultiCopyUserCmd = new quickInviteOtherAddMultiCopyUserCmd();
				m_TFBSysData.m_gkcontext.sendMsg(cmd);
				
				m_TFBSysData.m_preClickTime = m_TFBSysData.m_gkcontext.m_context.m_timeMgr.getCalendarTimeSecond();
			}
		}
		
		protected function onBtnClickTZ(e:MouseEvent):void
		{
			/*
			var form:IUITeamFBSys = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBSys) as IUITeamFBSys;
			if(form)
			{
				form.openUI(UIFormID.UITeamFBZX);
			}
			
			exit();
			*/
			
			/*
			var cmd:quickInviteOtherAddMultiCopyUserCmd = new quickInviteOtherAddMultiCopyUserCmd();
			m_TFBSysData.m_gkcontext.sendMsg(cmd);
			*/
			
			var form:IUITeamFBSys = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBSys) as IUITeamFBSys;
			if(form && form.isUIReady())
			{
				form.openUI(UIFormID.UITeamFBInvite);
			}
			
			exit();
		}
		
		protected function onBtnClickRM(e:MouseEvent):void
		{
			if(m_TFBSysData.m_curFBMgerItemIdx >= 0)
			{
				if(m_TFBSysData.isSelfLeader())
				{
					if(!m_TFBSysData.isSelf(m_TFBSysData.m_curFBMgerItemIdx))
					{
						var cmd:setTeamMemberToLeaderUserCmd = new setTeamMemberToLeaderUserCmd();
						cmd.teamid = m_TFBSysData.m_gkcontext.m_teamFBSys.teamid;
						cmd.id = m_TFBSysData.m_teamMemInfo.data[m_TFBSysData.m_curFBMgerItemIdx].id;;
						m_TFBSysData.m_gkcontext.sendMsg(cmd)
					}
				}
				else
				{
					m_gkcontext.m_systemPrompt.prompt("队长才能够使用该功能");
				}
			}
			else
			{
				m_gkcontext.m_systemPrompt.prompt("请先选中一个接任者");
			}
		}
		
		override public function exit():void
		{
			m_TFBSysData.m_onUIClose(this.id);
			super.exit();
		}
		
		public function psstNotifyTeamMemberListUserCmd():void
		{
			var item:FBMgerItem;
			for each(item in m_menLst)
			{
				item.updateUI();
			}
		}
		
		public function psnotifyTeamMemberLeaderChangeUserCmd():void
		{
			psstNotifyTeamMemberListUserCmd();
		}
		
		public function onItemClkCB(e:MouseEvent):void
		{
			var item:FBMgerItem;
			var idx:uint = 0;
			for each(item in m_menLst)
			{
				if(item == e.target)
				{
					break;
				}
				
				++idx;
			}
			
			if(idx < m_menLst.length)
			{
				if(m_TFBSysData.m_teamMemInfo.data && idx < m_TFBSysData.m_teamMemInfo.data.length)	// 如果这个格子有数据
				{
					if(m_TFBSysData.m_curFBMgerItemIdx >= 0)
					{
						m_menLst[m_TFBSysData.m_curFBMgerItemIdx].hideSel();
					}
					
					m_TFBSysData.m_curFBMgerItemIdx = idx;
					
					m_menLst[m_TFBSysData.m_curFBMgerItemIdx].showSel();
				}
			}
		}
		
		public function pstakeOffTeamMemberUserCmd():void
		{
			psstNotifyTeamMemberListUserCmd();
			
			// 如果当前选中,就去掉选中
			if(m_TFBSysData.m_curFBMgerItemIdx >= 0)
			{
				m_menLst[m_TFBSysData.m_curFBMgerItemIdx].hideSel();
			}
			
			m_TFBSysData.m_curFBMgerItemIdx = -1;
		}
	}
}