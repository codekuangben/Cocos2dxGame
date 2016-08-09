package game.process
{
	import flash.utils.ByteArray;
	
	import game.netmsg.teamcmd.notifyTeamMemberLeaderChangeUserCmd;
	import game.netmsg.teamcmd.takeOffTeamMemberUserCmd;
	
	import modulecommon.GkContext;
	import modulecommon.net.msg.teamUserCmd.stNotifyTeamMemberListUserCmd;
	import modulecommon.net.msg.teamUserCmd.stTeamCmd;
	import modulecommon.net.msg.teamUserCmd.synUserTeamStateCmd;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUITeamFBSys;

	/**
	 * @brief 组队副本处理
	 * */
	public class TeamProcess extends ProcessBase
	{	
		public function TeamProcess(gk:GkContext) 
		{
			super(gk);
			dicFun[stTeamCmd.NOTIFY_TEAM_MEMBER_LIST_USERCMD] = psstNotifyTeamMemberListUserCmd;
			dicFun[stTeamCmd.TAKE_OFF_TEAM_MEMBER_USERCMD] = pstakeOffTeamMemberUserCmd;
			dicFun[stTeamCmd.SYN_USER_TEAM_STATE_USERCMD] = pssynUserTeamStateCmd;
			dicFun[stTeamCmd.NOTIFY_MEMBER_LEADER_CHANGE_USERCMD] = psnotifyTeamMemberLeaderChangeUserCmd;
		}
		
		private function psstNotifyTeamMemberListUserCmd(msg:ByteArray, param:uint):void
		{
			/*
			var form:IUITeamFBSys = m_gkContext.m_UIMgr.getForm(UIFormID.UITeamFBSys) as IUITeamFBSys;
			if(form)
			{
				form.psstNotifyTeamMemberListUserCmd(msg);
			}
			else	// 打开界面
			{
				m_gkContext.m_contentBuffer.addContent("stNotifyTeamMemberListUserCmd", msg);
				m_gkContext.m_UIMgr.loadForm(UIFormID.UITeamFBSys);
			}
			*/
			
			var cmd:stNotifyTeamMemberListUserCmd = new stNotifyTeamMemberListUserCmd();
			cmd.deserialize(msg);
			
			if(!m_gkContext.m_teamFBSys.teamMemInfo)
			{
				m_gkContext.m_teamFBSys.teamMemInfo = cmd;	// 这个地方是不断增加的
			}
			else
			{
				(m_gkContext.m_teamFBSys.teamMemInfo as stNotifyTeamMemberListUserCmd).size += cmd.size;
				(m_gkContext.m_teamFBSys.teamMemInfo as stNotifyTeamMemberListUserCmd).data = (m_gkContext.m_teamFBSys.teamMemInfo as stNotifyTeamMemberListUserCmd).data.concat(cmd.data);
			}
			
			var form:IUITeamFBSys = m_gkContext.m_UIMgr.getForm(UIFormID.UITeamFBSys) as IUITeamFBSys;
			if(form && form.isUIReady())
			{
				form.psstNotifyTeamMemberListUserCmd();
			}
			else
			{
				// 缓存消息
				m_gkContext.m_contentBuffer.addContent("stNotifyTeamMemberListUserCmd", cmd);
			}
		}

		public function pstakeOffTeamMemberUserCmd(msg:ByteArray, param:int):void
		{
			var cmd:takeOffTeamMemberUserCmd = new takeOffTeamMemberUserCmd();
			cmd.deserialize(msg);
			m_gkContext.m_teamFBSys.delMemID = cmd.id;
			
			if(m_gkContext.m_teamFBSys.teamMemInfo)	// 如果不存在，就说明已经推出副本了，就不用再更新这些消息了
			{
				// 删除一个
				var idx:uint = 0;
				while(idx < (m_gkContext.m_teamFBSys.teamMemInfo as stNotifyTeamMemberListUserCmd).size)
				{
					if(cmd.id == (m_gkContext.m_teamFBSys.teamMemInfo as stNotifyTeamMemberListUserCmd).data[idx].id)
					{
						break;
					}
					++idx;
				}
				
				if(idx != (m_gkContext.m_teamFBSys.teamMemInfo as stNotifyTeamMemberListUserCmd).size)
				{
					// 删除用户数据
					(m_gkContext.m_teamFBSys.teamMemInfo as stNotifyTeamMemberListUserCmd).data.splice(idx, 1);
					(m_gkContext.m_teamFBSys.teamMemInfo as stNotifyTeamMemberListUserCmd).size -= 1;
				}
				
				var form:IUITeamFBSys = m_gkContext.m_UIMgr.getForm(UIFormID.UITeamFBSys) as IUITeamFBSys;
				if(form && form.isUIReady())
				{
					form.pstakeOffTeamMemberUserCmd();
				}
			}
		}
		
		public function pssynUserTeamStateCmd(msg:ByteArray, param:int):void
		{
			var cmd:synUserTeamStateCmd = new synUserTeamStateCmd();
			cmd.deserialize(msg);
			
			m_gkContext.m_teamFBSys.teamid = cmd.teamid;
			
			var form:IUITeamFBSys;
			if(0 == cmd.type)
			{
				form = m_gkContext.m_UIMgr.getForm(UIFormID.UITeamFBSys) as IUITeamFBSys;
				if(form)
				{
					if (form.isUIReady())
					{
						form.pssynUserTeamStateCmd(cmd);
					}
					else
					{
						m_gkContext.m_contentBuffer.addContent("synUserTeamStateCmd", cmd);
					}
				}
				else	// 打开界面
				{
					m_gkContext.m_contentBuffer.addContent("synUserTeamStateCmd", cmd);
					//m_gkContext.m_UIMgr.loadForm(UIFormID.UITeamFBSys);
					m_gkContext.m_UIMgr.createFormInGame(UIFormID.UITeamFBSys);
				}
			}
			else	// 退出
			{
				//var formMeminfo:Form = m_gkContext.m_UIMgr.getForm(UIFormID.UITeamFBMemInfo);
				//if(formMeminfo)
				//{
				//	formMeminfo.exit();
				//}
				
				//var formFBMger:Form = m_gkContext.m_UIMgr.getForm(UIFormID.UITeamFBMger);
				//if(formFBMger)
				//{
				//	formFBMger.exit();
				//}
				
				form = m_gkContext.m_UIMgr.getForm(UIFormID.UITeamFBSys) as IUITeamFBSys;
				if(form)
				{
					form.exit();
				}
				
				// 退出清理数据
				m_gkContext.m_teamFBSys.teamMemInfo = null;
			}
		}
		
		public function psnotifyTeamMemberLeaderChangeUserCmd(msg:ByteArray, param:int):void
		{
			var cmd:notifyTeamMemberLeaderChangeUserCmd = new notifyTeamMemberLeaderChangeUserCmd();
			cmd.deserialize(msg);
			
			if (m_gkContext.m_teamFBSys && m_gkContext.m_teamFBSys.teamMemInfo)
			{
				(m_gkContext.m_teamFBSys.teamMemInfo as stNotifyTeamMemberListUserCmd).leader = cmd.id;
			}
			
			var form:IUITeamFBSys;
			form = m_gkContext.m_UIMgr.getForm(UIFormID.UITeamFBSys) as IUITeamFBSys;
			if(form && form.isUIReady())
			{
				form.psnotifyTeamMemberLeaderChangeUserCmd();
			}
		}
	}
}