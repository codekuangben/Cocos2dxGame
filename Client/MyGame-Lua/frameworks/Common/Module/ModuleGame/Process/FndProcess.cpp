package game.process
{
	import com.util.DebugBox;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import game.netmsg.fndcmd.stFriendHelpQBTimesFriendCmd;
	import game.netmsg.fndcmd.stNotifyFriendRobbedFriendCmd;
	import modulecommon.net.msg.fndcmd.stHelpFriendIdFriendCmd;
	import modulecommon.net.msg.questUserCmd.stRequestQuestUserCmd;
	import modulecommon.scene.radar.RadarMgr;
	import modulecommon.ui.Form;
	import modulecommon.uiinterface.IForm;
	import modulecommon.uiinterface.IUIMailContent;
	
	import game.netmsg.fndcmd.stBlackListFriendCmd;
	import game.netmsg.fndcmd.stFriendApplyListFriendCmd;
	import game.netmsg.fndcmd.stFriendListFriendCmd;
	import game.netmsg.fndcmd.stFriendMooddiaryChangeFriendCmd;
	import game.netmsg.fndcmd.stNotifyFriendApplyFriendCmd;
	import game.netmsg.fndcmd.stNotifyFriendLevelChangeFriendCmd;
	import game.netmsg.fndcmd.stNotifyFriendOnlineFriendCmd;
	import game.netmsg.fndcmd.stRetFriendBaseInfoFriendCmd;
	import game.netmsg.fndcmd.stSelfInfoFriendCmd;
	
	import modulecommon.GkContext;
	import modulecommon.net.msg.fndcmd.stDeleteFriendFriendCmd;
	import modulecommon.net.msg.fndcmd.stFriendCmd;
	import modulecommon.net.msg.fndcmd.stReqAddFriendByCharIDFriendCmd;
	import modulecommon.scene.infotip.InfoTip;
	import modulecommon.scene.prop.relation.RelFriend;
	import modulecommon.scene.prop.relation.stUBaseInfo;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIFndLst;
	//import modulecommon.uiinterface.IUIInfoTip;
	import game.netmsg.fndcmd.stRetAddFriendByNameFriendCmd;
	import modulecommon.net.msg.fndcmd.stMoveFriendToBlackListFriendCmd;
	import modulecommon.uiinterface.IUIFndReq;
	import game.netmsg.fndcmd.stRetBlackBaseInfoFriendCmd;
	import modulecommon.uiinterface.IUIFndZhuFu;
	import game.netmsg.fndcmd.stFriendFocusChangeFriendCmd;
	import modulecommon.net.msg.fndcmd.stMoveUserToBlackListFriendCmd;

	public class FndProcess
	{	
		private var m_dicFun:Dictionary;
		private var m_gkcontext:GkContext;
		
		public function FndProcess(gk:GkContext)
		{
			m_gkcontext = gk;
			m_dicFun = new Dictionary();
			
			m_dicFun[stFriendCmd.PARA_FRIEND_LIST_FRIENDCMD] = psstFriendListFriendCmd;
			m_dicFun[stFriendCmd.PARA_BLACK_LIST_FRIENDCMD] = psstBlackListFriendCmd;
			m_dicFun[stFriendCmd.PARA_FRIEND_APPLY_LIST_FRIENDCMD] = psstFriendApplyListFriendCmd;
			m_dicFun[stFriendCmd.PARA_SELF_INFO_FRIENDCMD] = psstSelfInfoFriendCmd;
			m_dicFun[stFriendCmd.PARA_RET_FRIEND_BASEINFO_FRIENDCMD] = psstRetFriendBaseInfoFriendCmd;
			m_dicFun[stFriendCmd.PARA_NOTIFY_FRIEND_ONLINE_FRIENDCMD] = psstNotifyFriendOnlineFriendCmd;
			m_dicFun[stFriendCmd.PARA_NOTIFY_FRIEND_LEVEL_CHANGE_FRIENDCMD] = psstNotifyFriendLevelChangeFriendCmd;
			m_dicFun[stFriendCmd.PARA_FRIEND_MOODDIARY_CHANGE_FRIENDCMD] = psstFriendMooddiaryChangeFriendCmd;
			m_dicFun[stFriendCmd.PARA_REQ_ADD_FRIEND_BY_CHARID_FRIENDCMD] = psstReqAddFriendByCharIDFriendCmd;
			m_dicFun[stFriendCmd.PARA_NOTIFY_FRIEND_APPLY_FRIENDCMD] = psstNotifyFriendApplyFriendCmd;
			m_dicFun[stFriendCmd.PARA_RET_ADD_FRIEND_BY_NAME_FRIENDCMD] = psstRetAddFriendByNameFriendCmd;
			m_dicFun[stFriendCmd.PARA_DELETE_FRIEND_FRIENDCMD] = psstDeleteFriendFriendCmd;
			m_dicFun[stFriendCmd.PARA_MOVE_FRIEND_TO_BLACKLIST_FRIENDCMD] = psstMoveFriendToBlackListFriendCmd;
			m_dicFun[stFriendCmd.PARA_FRIENDBLESS_INFO_FRIENDCMD] = psstFriendBlessInfoFriendCmd;
			m_dicFun[stFriendCmd.PARA_FRIEND_FOCUS_CHANGE_FRIENDCMD] = psstFriendFocusChangeFriendCmd;
			m_dicFun[stFriendCmd.PARA_RET_BLACK_BASEINFO_FRIENDCMD] = psstRetBlackBaseInfoFriendCmd;
			m_dicFun[stFriendCmd.PARA_FRIEND_HELP_QBTIMES_FRIENDCMD] = process_stFriendHelpQBTimesFriendCmd;
			m_dicFun[stFriendCmd.PARA_RET_HELPME_QB_FRIENDLIST_FRIENDCMD] = process_stHelpMeQBFriendListFriendCmd;
			m_dicFun[stFriendCmd.PARA_RET_HAS_HELPSTATE_FRIENDLIST_FRIENDCMD] = process_stRetHasHelpStateFriendListFriendCmd;
			m_dicFun[stFriendCmd.PARA_HELP_FRIEND_QB_FRIENDCMD] = process_stHelpFriendQBFriendCmd;
			m_dicFun[stFriendCmd.PARA_HELP_FRIEND_ID_FRIENDCMD] = process_stHelpFriendIdFriendCmd;
			m_dicFun[stFriendCmd.PARA_NOTIFY_FRIEND_ROBBED_FRIENDCMD] = process_stNotifyFriendRobbedFriendCmd;
		}
		
		public function process(msg:ByteArray, param:uint):void
		{
			if (m_dicFun[param] != undefined)
			{
				m_dicFun[param](msg, param);
			}
		}
		
		// 好友列表
		public function psstFriendListFriendCmd(msg:ByteArray, param:int):void
		{
			var cmd:stFriendListFriendCmd = new stFriendListFriendCmd();
			cmd.deserialize(msg);
			m_gkcontext.m_beingProp.m_rela.m_relFnd.m_fndLst[RelFriend.eFndLst] = cmd.flist;
			// 更新界面
			var form:IUIFndLst = m_gkcontext.m_UIMgr.getForm(UIFormID.UIFndLst) as IUIFndLst;
			if(form)
			{
				form.updateLst(RelFriend.eFndLst);
			}
		}
		
		// 黑名单列表
		public function psstBlackListFriendCmd(msg:ByteArray, param:int):void
		{
			var cmd:stBlackListFriendCmd = new stBlackListFriendCmd();
			cmd.deserialize(msg);
			m_gkcontext.m_beingProp.m_rela.m_relFnd.m_fndLst[RelFriend.eBlackLst] = cmd.blist;
			// 更新界面
			var form:IUIFndLst = m_gkcontext.m_UIMgr.getForm(UIFormID.UIFndLst) as IUIFndLst;
			if(form)
			{
				form.updateLst(RelFriend.eBlackLst);
			}
		}
		
		//好友申请列表
		public function psstFriendApplyListFriendCmd(msg:ByteArray, param:int):void
		{
			var cmd:stFriendApplyListFriendCmd = new stFriendApplyListFriendCmd();
			cmd.deserialize(msg);
			m_gkcontext.m_beingProp.m_rela.m_relFnd.m_fndReqLst = cmd.applylist;
			
			m_gkcontext.m_commonProc.addInfoTip(InfoTip.ENfriend, cmd.num);
		}
		
		// 自己信息
		public function psstSelfInfoFriendCmd(msg:ByteArray, param:int):void
		{
			var cmd:stSelfInfoFriendCmd = new stSelfInfoFriendCmd();
			cmd.deserialize(msg);
			m_gkcontext.m_beingProp.m_mood = cmd.mood;
			// 更新好友列表界面自己的签名
			var form:IUIFndLst = m_gkcontext.m_UIMgr.getForm(UIFormID.UIFndLst) as IUIFndLst;
			if(form)
			{
				form.updateSelfMood();
			}
		}
		
		// 加好友成功返回好友基本信息
		public function psstRetFriendBaseInfoFriendCmd(msg:ByteArray, param:int):void
		{
			var cmd:stRetFriendBaseInfoFriendCmd = new stRetFriendBaseInfoFriendCmd();
			cmd.deserialize(msg);
			// 添加到离线好友之前
			//m_gkcontext.m_beingProp.m_rela.m_relFnd.m_fndLst[RelFriend.eFndLst].push(cmd.fbase);
			// 查找最后一个在线好友的位置
			var lstidx:int = 0;
			lstidx = m_gkcontext.m_beingProp.m_rela.m_relFnd.m_fndLst[RelFriend.eFndLst].length - 1;
			while(lstidx >= 0)
			{
				if((m_gkcontext.m_beingProp.m_rela.m_relFnd.m_fndLst[RelFriend.eFndLst][lstidx] as stUBaseInfo).online == 1)
				{
					break;
				}
				
				--lstidx;
			}
			// 插入正确的位置
			m_gkcontext.m_beingProp.m_rela.m_relFnd.m_fndLst[RelFriend.eFndLst].splice(lstidx + 1, 0, cmd.fbase);

			// 更新界面
			var form:IUIFndLst = m_gkcontext.m_UIMgr.getForm(UIFormID.UIFndLst) as IUIFndLst;
			if(form)
			{
				form.updateLst(RelFriend.eFndLst);
			}

			// 更新一下聊天框
			//if(m_gkcontext.m_UIs.chatSystem)
			if(m_gkcontext.m_UIs.chatSystem && m_gkcontext.m_UIs.chatSystem.isUIReady())
			{
				m_gkcontext.m_UIs.chatSystem.psnChat.updateByAddFnd(cmd.fbase.charid);
			}
			
			// 给一个提示
			m_gkcontext.m_systemPrompt.prompt("您添加" + cmd.fbase.name + "为好友!");
			
			//带好友打怪
			var uiaddfndfight:IForm = m_gkcontext.m_UIMgr.getForm(UIFormID.UIAddFriendFight) as IForm;
			if (uiaddfndfight)
			{
				uiaddfndfight.updateData();
			}
		}
		
		//将好友拉黑，如果不是好友,从聊天框直接拉黑，这个消息也返回，但是还要另外返回一个 stUBaseInfo  
		public function psstMoveFriendToBlackListFriendCmd(msg:ByteArray, param:int):void
		{
			var cmd:stMoveFriendToBlackListFriendCmd = new stMoveFriendToBlackListFriendCmd();
			cmd.deserialize(msg);
			if(cmd.result == 1)
			{
				// 删除
				var item:stUBaseInfo;
				var idx:int = -1;
				for each(item in m_gkcontext.m_beingProp.m_rela.m_relFnd.m_fndLst[RelFriend.eFndLst])
				{
					++idx;
					if(item.charid == cmd.charid)
					{
						break;
					}
				}
				if(idx >= 0)
				{
					m_gkcontext.m_beingProp.m_rela.m_relFnd.m_fndLst[RelFriend.eBlackLst].push(m_gkcontext.m_beingProp.m_rela.m_relFnd.m_fndLst[RelFriend.eFndLst][idx]);
					// 屏幕中央提示
					m_gkcontext.m_systemPrompt.prompt("您将" + m_gkcontext.m_beingProp.m_rela.m_relFnd.m_fndLst[RelFriend.eFndLst][idx].name + "拉入了黑名单!");
					m_gkcontext.m_beingProp.m_rela.m_relFnd.m_fndLst[RelFriend.eFndLst].splice(idx, 1);
				}
				
				// 更新界面
				var form:IUIFndLst = m_gkcontext.m_UIMgr.getForm(UIFormID.UIFndLst) as IUIFndLst;
				if(form)
				{
					if(idx >= 0)	// 从好友列表移动到黑名单
					{
						form.updateLst(RelFriend.eFndLst);
						form.updateLst(RelFriend.eBlackLst);
					}
					else		// 直接从聊天室拉黑
					{
						form.updateLst(RelFriend.eBlackLst);
					}
				}
			}
		}
		
		//删除好友或者黑名单
		public function psstDeleteFriendFriendCmd(msg:ByteArray, param:int):void
		{
			var cmd:stDeleteFriendFriendCmd = new stDeleteFriendFriendCmd();
			cmd.deserialize(msg);
			
			if(cmd.result == 1)		// 如果成功
			{
				var type:uint = 0;
				if(0 == cmd.type)
				{
					type = RelFriend.eFndLst;
				}
				else if(1 == cmd.type)
				{
					type = RelFriend.eBlackLst;
				}
				// 删除
				var item:stUBaseInfo;
				var idx:int = -1;
				for each(item in m_gkcontext.m_beingProp.m_rela.m_relFnd.m_fndLst[type])
				{
					++idx;
					if(item.charid == cmd.charid)
					{
						break;
					}
				}
				if(idx >= 0)
				{
					m_gkcontext.m_beingProp.m_rela.m_relFnd.m_fndLst[type].splice(idx, 1);
				}
				// 更新界面
				var form:IUIFndLst = m_gkcontext.m_UIMgr.getForm(UIFormID.UIFndLst) as IUIFndLst;
				if(form)
				{
					form.updateLst(type);
				}
			}
		}
		
		//好友上下线通知,上线放在已经上线的最后面,下线放在已经下线的最后面
		protected function psstNotifyFriendOnlineFriendCmd(msg:ByteArray, param:int):void
		{
			var cmd:stNotifyFriendOnlineFriendCmd = new stNotifyFriendOnlineFriendCmd();
			cmd.deserialize(msg);
			// 删除
			var item:stUBaseInfo;
			var idx:int = -1;
			var lstidx:int = 0;	// 在列表中插入的时候的索引
			for each(item in m_gkcontext.m_beingProp.m_rela.m_relFnd.m_fndLst[RelFriend.eFndLst])
			{
				++idx;
				if(item.charid == cmd.friendid)
				{
					item.online = cmd.online;
					break;
				}
			}
			
			if(idx >= 0)
			{
				var form:IUIFndLst = m_gkcontext.m_UIMgr.getForm(UIFormID.UIFndLst) as IUIFndLst;
				// 删除这个元素并且重新加入到最后
				//if(idx != m_gkcontext.m_beingProp.m_rela.m_relFnd.m_fndLst[RelFriend.eFndLst].length - 1)
				//{
					// 删除
					if(form)
					{
						form.delOne(RelFriend.eFndLst, idx);
					}
					m_gkcontext.m_beingProp.m_rela.m_relFnd.m_fndLst[RelFriend.eFndLst].splice(idx, 1);
					
					if(item.online == 1)		// 如果上线
					{
						// 添加
						lstidx = m_gkcontext.m_beingProp.m_rela.m_relFnd.m_fndLst[RelFriend.eFndLst].length - 1;
						while(lstidx >= 0)
						{
							if((m_gkcontext.m_beingProp.m_rela.m_relFnd.m_fndLst[RelFriend.eFndLst][lstidx] as stUBaseInfo).online == 1)
							{
								break;
							}
							
							--lstidx;
						}
						m_gkcontext.m_beingProp.m_rela.m_relFnd.m_fndLst[RelFriend.eFndLst].splice(lstidx + 1, 0, item);
						if(form)
						{
							form.addOne(RelFriend.eFndLst, lstidx + 1, item);
						}
					}
					else	// 如果下线
					{
						m_gkcontext.m_beingProp.m_rela.m_relFnd.m_fndLst[RelFriend.eFndLst].push(item);
						if(form)
						{
							form.addOne(RelFriend.eFndLst, -1, item);
						}
					}
				//}
				//else
				//{
					// 更新界面
					//if(form)
					//{
					//	form.updateItemFndOnline(RelFriend.eFndLst, idx);
					//}
				//}
			}
		}
		
		//好友等级变化通知
		protected function psstNotifyFriendLevelChangeFriendCmd(msg:ByteArray, param:int):void
		{
			var cmd:stNotifyFriendLevelChangeFriendCmd = new stNotifyFriendLevelChangeFriendCmd();
			cmd.deserialize(msg);
			// 删除
			var item:stUBaseInfo;
			var idx:int = -1;
			for each(item in m_gkcontext.m_beingProp.m_rela.m_relFnd.m_fndLst[RelFriend.eFndLst])
			{
				++idx;
				if(item.charid == cmd.friendid)
				{
					item.level = cmd.level;
					break;
				}
			}
			
			if(idx >= 0)
			{
				// 更新界面
				var form:IUIFndLst = m_gkcontext.m_UIMgr.getForm(UIFormID.UIFndLst) as IUIFndLst;
				if(form)
				{
					form.updateItemFndLvl(RelFriend.eFndLst, idx);
				}
			}
		}
		
		//通知好友心情变化
		protected function psstFriendMooddiaryChangeFriendCmd(msg:ByteArray, param:int):void
		{
			var cmd:stFriendMooddiaryChangeFriendCmd = new stFriendMooddiaryChangeFriendCmd();
			cmd.deserialize(msg);
			// 删除
			var item:stUBaseInfo;
			var idx:int = -1;
			for each(item in m_gkcontext.m_beingProp.m_rela.m_relFnd.m_fndLst[RelFriend.eFndLst])
			{
				++idx;
				if(item.charid == cmd.friendid)
				{
					item.mooddiary = cmd.mood;
					break;
				}
			}
			if(idx >= 0)
			{
				// 更新界面
				var form:IUIFndLst = m_gkcontext.m_UIMgr.getForm(UIFormID.UIFndLst) as IUIFndLst;
				if(form)
				{
					form.updateItemFndMood(RelFriend.eFndLst, idx);
				}
			}
		}
		
		// 加好友确认消息
		protected function psstReqAddFriendByCharIDFriendCmd(msg:ByteArray, param:int):void
		{
			var cmd:stReqAddFriendByCharIDFriendCmd = new stReqAddFriendByCharIDFriendCmd();
			cmd.deserialize(msg);
			
			// 注意这个时候客户端的好友具体的信息还没有发送过来
		}
		
		// 通知好友申请
		protected function psstNotifyFriendApplyFriendCmd(msg:ByteArray, param:int):void
		{
			var cmd:stNotifyFriendApplyFriendCmd = new stNotifyFriendApplyFriendCmd();
			cmd.deserialize(msg);
			m_gkcontext.m_beingProp.m_rela.m_relFnd.m_fndReqLst.push(cmd.applyinfo);
			
			// 如果可见
			var form:IUIFndReq = m_gkcontext.m_UIMgr.getForm(UIFormID.UIFndReq) as IUIFndReq;
			if(form)
			{
				form.updateLst();
			}
			else
			{
				// 有新人申请加入
				m_gkcontext.m_commonProc.addInfoTip(InfoTip.ENfriend, m_gkcontext.m_beingProp.m_rela.m_relFnd.m_fndReqLst.length);
			}
			
			// 屏幕中央提示
			m_gkcontext.m_systemPrompt.prompt(cmd.applyinfo.name + "成为了您的好友!");
		}
		
		//通过名字加好友反馈
		protected function psstRetAddFriendByNameFriendCmd(msg:ByteArray, param:int):void
		{
			var cmd:stRetAddFriendByNameFriendCmd = new stRetAddFriendByNameFriendCmd();
			cmd.deserialize(msg);
		}
		
		// 从聊天室直接拉黑
		protected function psstRetBlackBaseInfoFriendCmd(msg:ByteArray, param:int):void
		{
			var cmd:stRetBlackBaseInfoFriendCmd = new stRetBlackBaseInfoFriendCmd();
			cmd.deserialize(msg);
			
			m_gkcontext.m_beingProp.m_rela.m_relFnd.m_fndLst[RelFriend.eBlackLst].push(cmd.fbase);
			
			// 更新界面
			var form:IUIFndLst = m_gkcontext.m_UIMgr.getForm(UIFormID.UIFndLst) as IUIFndLst;
			if(form)
			{
				// 直接从聊天室拉黑
				form.updateLst(RelFriend.eBlackLst);
			}

			// 更新一下聊天框
			//if(m_gkcontext.m_UIs.chatSystem)
			if(m_gkcontext.m_UIs.chatSystem && m_gkcontext.m_UIs.chatSystem.isUIReady())
			{
				m_gkcontext.m_UIs.chatSystem.psnChat.updateByAddBlack(cmd.fbase.charid);
			}
			
			// 屏幕中央提示
			m_gkcontext.m_systemPrompt.prompt("您将" + cmd.fbase.name + "拉入了黑名单!");
		}
		
		protected function psstFriendBlessInfoFriendCmd(msg:ByteArray, param:int):void
		{
			var form:IUIFndZhuFu = m_gkcontext.m_UIMgr.getForm(UIFormID.UIFndZhuFu) as IUIFndZhuFu;
			if(form)
			{
				form.psstFriendBlessInfoFriendCmd(msg);
			}
			else
			{
				m_gkcontext.m_contentBuffer.addContent("uiFndZhuFu_msg", msg)
				m_gkcontext.m_UIMgr.loadForm(UIFormID.UIFndZhuFu);
			}
		}
		
		protected function psstFriendFocusChangeFriendCmd(msg:ByteArray, param:int):void
		{
			var cmd:stFriendFocusChangeFriendCmd = new stFriendFocusChangeFriendCmd();
			cmd.deserialize(msg);

			// 删除
			var item:stUBaseInfo;
			var idx:int = -1;
			for each(item in m_gkcontext.m_beingProp.m_rela.m_relFnd.m_fndLst[RelFriend.eFndLst])
			{
				++idx;
				if(item.charid == cmd.friendid)
				{
					item.focus = cmd.focus;
					break;
				}
			}
			if(idx >= 0)
			{
				// 更新界面
				var form:IUIFndLst = m_gkcontext.m_UIMgr.getForm(UIFormID.UIFndLst) as IUIFndLst;
				if(form)
				{
					form.updateItemFocus(RelFriend.eFndLst, idx);
				}
			}	
		}
		
		protected function psstMoveUserToBlackListFriendCmd(msg:ByteArray, param:int):void
		{
			var cmd:stMoveUserToBlackListFriendCmd = new stMoveUserToBlackListFriendCmd();
			cmd.deserialize(msg);
		}
		
		protected function process_stFriendHelpQBTimesFriendCmd(msg:ByteArray, param:int):void
		{
			var rev:stFriendHelpQBTimesFriendCmd = new stFriendHelpQBTimesFriendCmd();
			rev.deserialize(msg);
			m_gkcontext.m_beingProp.m_rela.m_relFnd.setTimeHelpByFrendsForBaowu(rev.times);
			var iuiMailContent:IUIMailContent = m_gkcontext.m_UIMgr.getForm(UIFormID.UIMailContent) as IUIMailContent;
			if (iuiMailContent)
			{
				iuiMailContent.updatebaowuRansomPanel();
			}
		}
		protected function process_stHelpMeQBFriendListFriendCmd(msg:ByteArray, param:int):void
		{			
			//stHelpMeQBFriendListFriendCmd
			// 更新界面
			var form:Form = m_gkcontext.m_UIMgr.getForm(UIFormID.UIFriendsForBaowu);
			if(form)
			{
				form.updateData(msg);
			}
			
			DebugBox.addLog("帮好友抢宝:UIFriendsForBaowu=" + form + " 收到消息stHelpMeQBFriendListFriendCmd");
		}
		protected function process_stRetHasHelpStateFriendListFriendCmd(msg:ByteArray, param:int):void
		{			
			//stHelpMeQBFriendListFriendCmd
			// 更新界面
			var form:IUIFndLst = m_gkcontext.m_UIMgr.getForm(UIFormID.UIFndLst) as IUIFndLst;
			if(form)
			{
				form.process_stRetHasHelpStateFriendListFriendCmd(msg);
			}
		}
		protected function process_stHelpFriendQBFriendCmd(msg:ByteArray, param:int):void
		{			
			//stHelpMeQBFriendListFriendCmd
			// 更新界面
			var form:IUIFndLst = m_gkcontext.m_UIMgr.getForm(UIFormID.UIFndLst) as IUIFndLst;
			if(form)
			{
				form.process_stHelpFriendQBFriendCmd(msg);
			}
		}
		
		//发送玩家选定的好友id（打井npc用) //服务器返回确认消息
		protected function process_stHelpFriendIdFriendCmd(msg:ByteArray, param:int):void
		{
			var rev:stHelpFriendIdFriendCmd = new stHelpFriendIdFriendCmd();
			rev.deserialize(msg);
			
			if (1 == rev.m_ret)//0:id可用  1:不可用
			{
				m_gkcontext.m_systemPrompt.prompt("选中好友已经帮助过夺宝");
				return;
			}
			
			m_gkcontext.m_beingProp.m_rela.m_relFnd.setExtraDataOfFriend(rev.m_fndIDs[0], RelFriend.ExtraHelp);
			m_gkcontext.m_beingProp.m_rela.m_relFnd.setExtraDataOfFriend(rev.m_fndIDs[1], RelFriend.ExtraHelp);
			
			var info:Object = m_gkcontext.m_contentBuffer.getContent("uiAddFriendFight_info", true);
			if (info)
			{
				var send:stRequestQuestUserCmd = new stRequestQuestUserCmd();
				send.id = info["questid"];
				send.target = info["eventid"];
				send.offset = info["embranchmentid"];
				m_gkcontext.sendMsg(send);
			}
			
			var form:Form = m_gkcontext.m_UIMgr.getForm(UIFormID.UIAddFriendFight);
			if (form)
			{
				form.exit();
			}
		}
		
		protected function process_stNotifyFriendRobbedFriendCmd(msg:ByteArray, param:int):void
		{
			var rev:stNotifyFriendRobbedFriendCmd = new stNotifyFriendRobbedFriendCmd();
			rev.deserialize(msg);
			m_gkcontext.addLog("stNotifyFriendRobbedFriendCmd 好友请求帮助="+rev.friendid);
			if (m_gkcontext.m_UIs.radar)
			{
				m_gkcontext.m_UIs.radar.showEffectAni(RadarMgr.RADARBTN_Friend);
			}
		}
	}
}