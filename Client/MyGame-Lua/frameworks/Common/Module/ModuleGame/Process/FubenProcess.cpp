package game.process
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	//import com.util.UtilCommon;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import modulecommon.scene.beings.NpcPlayerFake;
	import modulecommon.scene.benefithall.peoplerank.PeopleRankMgr;
	import modulecommon.scene.elitebarrier.EliteBarrierMgr;
	
	import game.netmsg.copycmd.st0ClockUserCmd;
	import game.netmsg.copycmd.st7ClockUserCmd;
	import game.netmsg.copycmd.stRetCreateCopyUserCmd;
	import game.netmsg.copycmd.synMultiUserCopyProfigCountUserCmd;
	import game.netmsg.copycmd.synTeamBossTodayCengUserCmd;
	import game.netmsg.copycmd.syncLeaveCopyUserCmd;
	import game.netmsg.teamcmd.inviteMeAddMultiCopyUserCmd;
	import game.netmsg.teamcmd.refuseInviteAddMultiCopyUserCmd;
	import game.netmsg.teamcmd.retUserProfitInCopyUserCmd;
	
	import modulecommon.GkContext;
	import modulecommon.commonfuntion.LocalDataMgr;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.net.msg.copyUserCmd.retQuickFinishSaoDangYuanBaoUserCmd;
	import modulecommon.net.msg.copyUserCmd.retYuanBaoCoolingTimeUserCmd;
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;
	import modulecommon.net.msg.copyUserCmd.stReqYuanBaoCoolingUserCmd;
	import modulecommon.net.msg.copyUserCmd.synSaoDangCopyUserCmd;
	import modulecommon.net.msg.teamUserCmd.reqAddMultiCopyUserCmd;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.scene.taskprompt.TaskPromptMgr;
	import com.util.UtilHtml;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IForm;
	import modulecommon.uiinterface.IUIAniGetGiftObj;
	import modulecommon.uiinterface.IUICangbaoku;
	import modulecommon.uiinterface.IUICopyCountDown;
	import modulecommon.uiinterface.IUIFuben;
	import modulecommon.uiinterface.IUISaoDangIngInfo;
	import modulecommon.uiinterface.IUIScreenBtn;
	import modulecommon.uiinterface.IUITeamFBSys;
	import modulecommon.uiinterface.IUITurnCard;
	import modulecommon.net.msg.copyUserCmd.notifyTouXiangData;
	
	public class FubenProcess
	{
		private var dicFun:Dictionary;
		private var m_gkcontext:GkContext;
		
		public function FubenProcess(gk:GkContext)
		{
			m_gkcontext = gk;
			dicFun = new Dictionary();
			dicFun[stCopyUserCmd.NOTIFY_AVAILABLE_COPY_USERCMD] = processNotifyAvailableCopyUserCmd;
			dicFun[stCopyUserCmd.NOTIFY_COPY_OVER_USERCMD] = processReNotifyCopyOverUserCmd;
			dicFun[stCopyUserCmd.PARA_REFRESH_CHECK_POINT_LIST_USERCMD] = processstRefreshCheckPointListUserCmd;
			
			dicFun[stCopyUserCmd.RET_CANG_BAO_KU_DATA_USERCMD] = m_gkcontext.m_cangbaokuMgr.processRetCangBaoKuDataUserCmd;
			dicFun[stCopyUserCmd.UPDATE_REMAINING_COUNT] = m_gkcontext.m_cangbaokuMgr.processUpdateRemainingCount;
			dicFun[stCopyUserCmd.UPDATE_CUR_LAYER] = m_gkcontext.m_cangbaokuMgr.processUpdateCurLayer;
			dicFun[stCopyUserCmd.UPDATE_BOX_LIST] = m_gkcontext.m_cangbaokuMgr.processUpdateBoxList;
			dicFun[stCopyUserCmd.RET_YUAN_BAO_COOLING_TIME_USERCMD] = processssYuanBaoCoolingTimeUserCmd;
			
			dicFun[stCopyUserCmd.SYNC_TIME_CLEAR_DATA_USERCMD] = processCountDownUserCmd;
			dicFun[stCopyUserCmd.st7_CLOCK_USERCMD] = process7ClockUserCmd;
			dicFun[stCopyUserCmd.RET_CREATE_COPY_USERCMD] = processRetCreateCopyUserCmd;
			dicFun[stCopyUserCmd.SYNC_LEAVE_COPY_USERCMD] = processsyncLeaveCopyUserCmd;
			
			
			dicFun[stCopyUserCmd.RET_BOX_TIP_CONTEXT_USERCMD] = processRetBoxTipContextUserCmd;
			dicFun[stCopyUserCmd.COPY_REWARD_USERCMD] = processCopyRewardUserCmd;
			dicFun[stCopyUserCmd.SYN_SAO_DANG_COPY_USERCMD] = processSynSaoDangUserCmd;
			dicFun[stCopyUserCmd.RET_QUICK_FINISH_SAO_DANG_YUAN_BAO_USERCMD] = processRetQuickFinishSaoDangUserCmd;
			dicFun[stCopyUserCmd.RET_SAO_DANG_COPY_REWARD_USERCMD] = ProcessRetSaoDangCopyRewardUserCmd;
			dicFun[stCopyUserCmd.SYN_SEND_BOX_OBJS_END_USERCMD] = processSynSendBoxObjs;
			
			dicFun[stCopyUserCmd.PARA_RET_REFRESH_CBK_DATA_USERCMD] = processRefreshCBKData;
			dicFun[stCopyUserCmd.RET_OPEN_MULTI_COPY_UI_USERCMD] = psretOpenMultiCopyUiUserCmd;
			dicFun[stCopyUserCmd.RET_CLICK_MULTI_COPY_UI_USERCMD] = psretClickMultiCopyUiUserCmd;
			
			dicFun[stCopyUserCmd.RET_INVITE_ADD_MULTI_COPY_UI_USERCMD] = psretInviteAddMultiCopyUiUserCmd;
			dicFun[stCopyUserCmd.INVITE_ME_ADD_MULTI_COPY_USERCMD] = psinviteMeAddMultiCopyUserCmd;
			dicFun[stCopyUserCmd.RET_USE_PROFIT_IN_COPY_USERCMD] = processRetUseProfitInCopyUserCmd;
			dicFun[stCopyUserCmd.RET_OPEN_ASSGIN_HERO_UI_USERCMD] = psretOpenAssginHeroUiCopyUserCmd;
			
			dicFun[stCopyUserCmd.RET_CHANGE_ASSGIN_HERO_USERCMD] = psretChangeAssginHeroUserCmd;
			dicFun[stCopyUserCmd.RET_CHANGE_USER_POS_USERCMD] = psretChangeUserPosUserCmd;
			dicFun[stCopyUserCmd.NOTIFY_BEST_COPY_PK_REVIEW_USERCMD] = processNotifyBestCopyPkReviewUserCmd;
			dicFun[stCopyUserCmd.RET_FIGHT_HERO_DATA_USERCMD] = psretFightHeroDataUserCmd;
			
			dicFun[stCopyUserCmd.SYN_COPY_REWARD_EXP_USERCMD] = pssynCopyRewardExpUserCmd;
			dicFun[stCopyUserCmd.st0_CLOCK_USERCMD] = process0ClockUserCmd;
			dicFun[stCopyUserCmd.SYN_MULTI_USER_COPY_PROFIG_COUNT_USERCMD] = processSynMultiUserCopyProfigCountUserCmd;
			dicFun[stCopyUserCmd.SYN_TEAM_BOSS_TODAY_CENG_USERCMD] = pssynTeamBossTodayCengUserCmd;
			dicFun[stCopyUserCmd.RET_TEAM_BOSS_RANK_USERCMD] = psretTeamBossRankUserCmd;
			
			dicFun[stCopyUserCmd.PARA_RET_TEAM_ASSIST_INFO_USERCMD] = psstRetTeamAssistInfoUserCmd;
			dicFun[stCopyUserCmd.PARA_GAIN_TEAM_ASSIST_GIFT_USERCMD] = psstGainTeamAssistGiftUserCmd;
			dicFun[stCopyUserCmd.NOTIFY_TOUXIANG_DATA] = psnotifyTouXiangData;
		}
		
		public function process(msg:ByteArray, param:uint):void
		{
			if (dicFun[param] != undefined)
			{
				dicFun[param](msg, param);
			}
		}
		
		protected function processNotifyAvailableCopyUserCmd(msg:ByteArray, param:int):void
		{
			var form:IUIFuben = m_gkcontext.m_UIMgr.getForm(UIFormID.UIFuben) as IUIFuben;
			if (form != null)
			{
				form.processMsg(msg, param);
			}
			else
			{
				m_gkcontext.m_contentBuffer.addContent("uiFuben_AVAILABLE_COPY", msg);
				m_gkcontext.m_UIMgr.loadForm(UIFormID.UIFuben);
			}
			
		}
		
		protected function processstRefreshCheckPointListUserCmd(msg:ByteArray, param:int):void
		{
			/*var rev:stRetMaxClearanceIdUserCmd = new stRetMaxClearanceIdUserCmd();
			rev.serialize(msg);
			m_gkcontext.m_beingProp.checkPoint = rev.id;*/
			var wform:Form = m_gkcontext.m_UIMgr.getForm(UIFormID.UIWorldMap) as Form;			
			if (wform != null)
			{
				wform.updateData(msg);
			}
		}
		
		protected function processReNotifyCopyOverUserCmd(msg:ByteArray, param:int):void
		{
			// 服务器通知客户端副本结束
			m_gkcontext.m_UIMgr.loadForm(UIFormID.UITurnCard);
		}
		
		// 处理倒计时
		protected function processCountDownUserCmd(msg:ByteArray, param:int):void
		{
			var icountdown:IUICopyCountDown = m_gkcontext.m_UIMgr.getForm(UIFormID.UICopyCountDown) as IUICopyCountDown;
			if(icountdown)
			{
				icountdown.processCountDownUserCmd(msg);
			}
			else
			{
				m_gkcontext.m_contentBuffer.addContent("uiCopyCountDown_time", msg);
				m_gkcontext.m_UIMgr.loadForm(UIFormID.UICopyCountDown);
			}
		}
		
		// 7 点重置数据
		public function process7ClockUserCmd(msg:ByteArray, param:int):void
		{
			var rev:st7ClockUserCmd = new st7ClockUserCmd();
			rev.deserialize(msg);
			
			// 处理重置数据
			m_gkcontext.m_context.m_timeMgr.process7ClockUserCmd();
			m_gkcontext.m_cangbaokuMgr.process7ClockUserCmd();
			m_gkcontext.m_marketMgr.process7ClockUserCmd();
			m_gkcontext.m_taskMgr.process7ClockUserCmd();			//悬赏任务
			m_gkcontext.m_beingProp.m_rela.m_relFnd.process7ClockUserCmd(); //好友相关
			m_gkcontext.m_ingotbefallMgr.process7ClockUserCmd();	//财神降临
			m_gkcontext.m_dailyActMgr.process7ClockUserCmd();		//每日必做，活跃度值、签到信息更新
			m_gkcontext.m_corpsMgr.process7ClockUserCmd();			//军团任务
			m_gkcontext.m_jiuguanMgr.process7ClockUserCmd();		//宝物抢夺
			m_gkcontext.m_worldBossMgr.process7ClockUserCmd();		//世界BOSS
			m_gkcontext.m_sanguozhanchangMgr.process7ClockUserCmd();//三国战场
			//m_gkcontext.m_elitebarrierMgr.process7ClockUserCmd();	//精英boss
			m_gkcontext.m_peopleRankMgr.process7ClockUserCmd();		//全民冲榜
			m_gkcontext.m_heroRallyMgr.process7ClockUserCmd();		//三国群英会
			m_gkcontext.m_LimitBagSendMgr.process7ClockUserCmd();	//限时放送
			m_gkcontext.m_godlyWeaponMgr.process7ClockUserCmd();	//神兵培养
			m_gkcontext.m_arenaMgr.dayRefresh();
			m_gkcontext.m_ggzjMgr.dayRefresh();
			
			process7ClockUserCmd_TeamFBSys(m_gkcontext.m_teamFBSys.maxCountsFight);	//组队副本
			
			//每日任务推荐数据重置
			if (m_gkcontext.m_UIs.taskPrompt)
			{
				m_gkcontext.m_taskpromptMgr.updateDatas();
				m_gkcontext.m_UIs.taskPrompt.updatePrompt();
				
				//宝物抢夺次数
				m_gkcontext.m_UIs.taskPrompt.updateLeftCountsAddTimes(TaskPromptMgr.TASKPROMPT_SnatchTreasure, -1, m_gkcontext.m_jiuguanMgr.m_robLeftTimes);
				
				//精英boss
				m_gkcontext.m_elitebarrierMgr.setLeftTimes(EliteBarrierMgr.JBOSS_MAXCOUNTS); 
				
				//军团任务
				m_gkcontext.m_UIs.taskPrompt.updateLeftCountsAddTimes(TaskPromptMgr.TASKPROMPT_CorpsTask, -1, m_gkcontext.m_corpsMgr.m_taskMaxCounts);
			}
			
			//“军团夺宝”活动按钮显示更新
			if (m_gkcontext.m_UIs.screenBtn)
			{
				m_gkcontext.m_UIs.screenBtn.updateBtnOfCorpsTreasure();
			}
		}
		
		//零点数据刷新(服务器时间此时00:00:00点)
		public function process0ClockUserCmd(msg:ByteArray, param:int):void
		{
			var rev:st0ClockUserCmd = new st0ClockUserCmd();
			//rev.deserialize(msg);	
			m_gkcontext.m_context.m_timeMgr.process0ClockUserCmd();
			m_gkcontext.m_qiridengluMgr.process0ClockUserCmd();
			m_gkcontext.m_welfarePackageMgr.dayRefresh();
			m_gkcontext.m_dailyActMgr.process0ClockuserCmd();		//签到
		}
		
		// 创建副本返回
		public function processRetCreateCopyUserCmd(msg:ByteArray, param:int):void
		{
			var cmd:stRetCreateCopyUserCmd = new stRetCreateCopyUserCmd();
			cmd.deserialize(msg);
			m_gkcontext.addLog("收到stRetCreateCopyUserCmd id=" + cmd.id);
			
			m_gkcontext.m_mapInfo.m_curCopyId = cmd.id;
			m_gkcontext.m_mapInfo.m_isInFuben = true;
			if(cmd.id == 10000)
			{
				m_gkcontext.m_cangbaokuMgr.processRetCreateCopyUserCmd(msg, param);
			}
			else if(cmd.id == 8888)
			{
				m_gkcontext.m_screenbtnMgr.hideUIScreenBtn();
				m_gkcontext.m_UIMgr.hideForm(UIFormID.UITaskPrompt);
				m_gkcontext.m_UIMgr.hideForm(UIFormID.UIRadar);
				m_gkcontext.m_taskMgr.hideUITaskTrace();
			}
		}
		
		// 离开副本消息
		public function processsyncLeaveCopyUserCmd(msg:ByteArray, param:int):void
		{
			var cmd:syncLeaveCopyUserCmd = new syncLeaveCopyUserCmd();
			cmd.deserialize(msg);
			m_gkcontext.addLog("收到syncLeaveCopyUserCmd id=" + cmd.id);
			
			m_gkcontext.m_mapInfo.m_isInFuben = false;
			
			var form:Form;
			
			if(cmd.id == 10000)
			{
				m_gkcontext.m_cangbaokuMgr.processsyncLeaveCopyUserCmd(msg, param);
			}
			else if(cmd.id == 8888)
			{
				m_gkcontext.m_screenbtnMgr.showUIScreenBtn();
				m_gkcontext.m_UIMgr.showForm(UIFormID.UITaskPrompt);
				m_gkcontext.m_UIMgr.showForm(UIFormID.UIRadar);
				m_gkcontext.m_taskMgr.showUITaskTrace();
				
				form = m_gkcontext.m_UIMgr.getForm(UIFormID.UICorpsCitySys);
				if(form)
				{
					form.exit();
				}
			}
			
			form = m_gkcontext.m_UIMgr.getForm(UIFormID.UIBestCopyPk);
			if (form)
			{
				form.exit();
			}
		}
		
		// 返回藏宝库 tips
		public function processRetBoxTipContextUserCmd(msg:ByteArray, param:int):void
		{
			var icangbaoku:IUICangbaoku = m_gkcontext.m_UIMgr.getForm(UIFormID.UICangbaoku) as IUICangbaoku;
			if(icangbaoku)
			{
				icangbaoku.processRetBoxTipContextUserCmd(msg, param);
			}
		}
		
		/*
		// 副本通关奖励
		protected function processCopyClearanceUserCmd(msg:ByteArray, param:int):void
		{
			if(m_gkcontext.inBattleIScene)
			{
				m_gkcontext.m_contentBuffer.addContent("uiCopiesAwards_end", msg);
			}
			else
			{
				var ui:IUICopiesAwards = m_gkcontext.m_UIMgr.getForm(UIFormID.UICopiesAwards) as IUICopiesAwards;
				if(ui)
				{
					ui.parseCopyClearance(m_gkcontext.m_contentBuffer.getContent("uiCopiesAwards_end", true) as ByteArray);
				}
				else
				{
					m_gkcontext.m_UIMgr.loadForm(UIFormID.UICopiesAwards);
					m_gkcontext.m_contentBuffer.addContent("uiCopiesAwards_end", msg);
				}
			}
		}
		*/
		
		// 翻牌奖励
		protected function processCopyRewardUserCmd(msg:ByteArray, param:int):void
		{
			m_gkcontext.m_localMgr.set(LocalDataMgr.LOCAL_HIDE_TurnCardState);
			if(m_gkcontext.m_mapInfo.inBattleIScene)
			{
				m_gkcontext.m_contentBuffer.addContent("uiCopyTurnCard_reward", msg);
			}
			else
			{
				var ui:IUITurnCard = m_gkcontext.m_UIMgr.getForm(UIFormID.UITurnCard) as IUITurnCard;
				if(ui)
				{
					ui.parseCopyReward(m_gkcontext.m_contentBuffer.getContent("uiCopyTurnCard_reward", true) as ByteArray);
				}
				else
				{
					m_gkcontext.m_UIMgr.loadForm(UIFormID.UITurnCard);
					m_gkcontext.m_contentBuffer.addContent("uiCopyTurnCard_reward", msg);
				}
			}
		}
		protected function processSynSaoDangUserCmd(msg:ByteArray, param:int):void
		{
			var rev:synSaoDangCopyUserCmd = new synSaoDangCopyUserCmd();
			rev.deserialize(msg);
			m_gkcontext.m_saodangMgr.setData(rev.type, rev.name, rev.cishu, rev.time);
			
			if (m_gkcontext.m_UIs.screenBtn)
			{
				var res:uint = m_gkcontext.m_UIs.screenBtn.saoDangBtnState();
				if(0 == res)
				{
					m_gkcontext.m_UIs.screenBtn.addBtnByID(ScreenBtnMgr.Btn_SaoDang);
				}
				else if(1 == res)
				{
					m_gkcontext.m_UIs.screenBtn.toggleBtnVisible(ScreenBtnMgr.Btn_SaoDang, true);
				}
			}
			
		}
		protected function processRetQuickFinishSaoDangUserCmd(msg:ByteArray, param:int):void
		{
			var rev:retQuickFinishSaoDangYuanBaoUserCmd = new retQuickFinishSaoDangYuanBaoUserCmd();
			rev.deserialize(msg);
			
			var ui:IUISaoDangIngInfo = m_gkcontext.m_UIMgr.getForm(UIFormID.UISaoDangIngInfo) as IUISaoDangIngInfo;
			if (ui != null)
			{
				ui.ensureQuickFinishYuanbao(rev.num);
			}
		}
		protected function ProcessRetSaoDangCopyRewardUserCmd(msg:ByteArray, param:int):void
		{
			var ui:IForm = m_gkcontext.m_UIMgr.getForm(UIFormID.UISaoDangReward) as IForm;
			if (ui != null)
			{
				ui.updateData(msg);
			}
		}
		
		protected function processssYuanBaoCoolingTimeUserCmd(msg:ByteArray, param:int):void
		{
			var time:uint;
			var type:uint;
			var rev:retYuanBaoCoolingTimeUserCmd = new retYuanBaoCoolingTimeUserCmd();
			rev.deserialize(msg);
			time = rev.time;
			type = rev.type;
			
			if (stReqYuanBaoCoolingUserCmd.CANGBAOKU_PK == type)
			{
				m_gkcontext.m_cangbaokuMgr.processssCangBaoKuPkCoolingTimeUserCmd(time);
			}
			else if (stReqYuanBaoCoolingUserCmd.GUANZHIJINGJI_PK == type)
			{
				m_gkcontext.m_arenaMgr.updateColdTimeDaojishi(time);
			}
		}
		
		// 藏宝库开完宝箱后,服务器发送的物品领取结束的消息
		public function processSynSendBoxObjs(msg:ByteArray, param:int):void
		{
			m_gkcontext.m_giftPackMgr.giftAniData.m_cbkState = 0;	// 不在领取状态
			var form:IUIAniGetGiftObj = m_gkcontext.m_UIMgr.getForm(UIFormID.UIAniGetGiftObj) as IUIAniGetGiftObj;
			if(form)
			{
				// 直接生成
				form.buildFly();
			}
			else
			{
				// 加载完成再飞行
				m_gkcontext.m_UIMgr.loadForm(UIFormID.UIAniGetGiftObj);
			}
		}
		
		public function processRefreshCBKData(msg:ByteArray, param:int):void
		{
			m_gkcontext.m_cangbaokuMgr.processRefreshCBKData(msg, param);
		}
		
		public function psretOpenMultiCopyUiUserCmd(msg:ByteArray, param:int):void
		{
			var form:IUITeamFBSys = m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBSys) as IUITeamFBSys;
			if(form && form.isUIReady())
			{
				form.psretOpenMultiCopyUiUserCmd(msg);
			}
		}
		
		public function psretClickMultiCopyUiUserCmd(msg:ByteArray, param:int):void
		{
			var form:IUITeamFBSys = m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBSys) as IUITeamFBSys;
			if(form && form.isUIReady())
			{
				form.psretClickMultiCopyUiUserCmd(msg);
			}
		}
		
		public function psinviteMeAddMultiCopyUserCmd(msg:ByteArray, param:int):void
		{
			var cmd:inviteMeAddMultiCopyUserCmd = new inviteMeAddMultiCopyUserCmd();
			cmd.deserialize(msg);
			
			//提示框只显示一个
			if (m_gkcontext.m_confirmDlgMgr.getFormID() == UIFormID.UITeamFBSys && m_gkcontext.m_confirmDlgMgr.isVisible())
			{
				return;
			}
			
			m_gkcontext.m_teamFBSys.inviterName = cmd.name;
			m_gkcontext.m_teamFBSys.copyname = cmd.copyname;
			m_gkcontext.m_teamFBSys.copytempid = cmd.copytempid;
			
			var desc:String;
			UtilHtml.beginCompose();
			var fblvl:int = 0;
			var leftcnt:int = m_gkcontext.m_teamFBSys.leftUseCnt;	// 剩余的使用次数
			if (cmd.copyname != "组队BOSS")		// 副本组队
			{
				fblvl = m_gkcontext.m_teamFBSys.getFBLevelByName(cmd.copyname);
				UtilHtml.addStringNoFormat(cmd.name + "邀请您进入[" + cmd.copyname + "]" + fblvl + "级副本中,请问您要加入吗?(今日您的领奖次数为" + leftcnt + ")");
			}
			else	// 组队 BOSS
			{
				UtilHtml.addStringNoFormat(cmd.name + "邀请您进入[" + cmd.copyname + "]副本中,请问您要加入吗?");
			}

			desc = UtilHtml.getComposedContent();
			m_gkcontext.m_confirmDlgMgr.showMode1(UIFormID.UITeamFBSys, desc, okCB, cancelCB, "拒绝", "果断加入", null, true, null);
		}

		public function okCB():Boolean
		{
			var ret:refuseInviteAddMultiCopyUserCmd = new refuseInviteAddMultiCopyUserCmd();
			ret.name = m_gkcontext.m_teamFBSys.inviterName;
			m_gkcontext.sendMsg(ret);
			return true;
		}

		public function cancelCB():Boolean
		{
			//组队副本功能未开启，不显示被邀请提示框
			if (!m_gkcontext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_TEAMCOPY))
			{
				m_gkcontext.m_systemPrompt.prompt("组队副本 功能还未开启");
			}
			else if (m_gkcontext.m_mapInfo.m_bInArean)
			{
				m_gkcontext.m_systemPrompt.prompt("请先退出竞技场");
			}
			else
			{
				var cmd:reqAddMultiCopyUserCmd = new reqAddMultiCopyUserCmd();
				cmd.copytempid = m_gkcontext.m_teamFBSys.copytempid;
				cmd.type = 1;
				m_gkcontext.sendMsg(cmd);
			}
			
			return true;
		}
		
		public function psretInviteAddMultiCopyUiUserCmd(msg:ByteArray, param:int):void
		{
			var form:IUITeamFBSys = m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBSys) as IUITeamFBSys;
			if(form && form.isUIReady())
			{
				form.psretInviteAddMultiCopyUiUserCmd(msg);
			}
		}
		
		public function processRetUseProfitInCopyUserCmd(msg:ByteArray, param:int):void
		{
			var ret:retUserProfitInCopyUserCmd = new retUserProfitInCopyUserCmd();
			ret.deserialize(msg);
			m_gkcontext.m_teamFBSys.psretUserProfitInCopyUserCmd(ret);
		}
		
		public function psretOpenAssginHeroUiCopyUserCmd(msg:ByteArray, param:int):void
		{
			var form:IUITeamFBSys = m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBSys) as IUITeamFBSys;
			if(form && form.isUIReady())
			{
				form.psretOpenAssginHeroUiCopyUserCmd(msg);
			}
		}
		
		public function psretChangeAssginHeroUserCmd(msg:ByteArray, param:int):void
		{
			var form:IUITeamFBSys = m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBSys) as IUITeamFBSys;
			if(form && form.isUIReady())
			{
				form.psretChangeAssginHeroUserCmd(msg);
			}
		}
		
		public function psretChangeUserPosUserCmd(msg:ByteArray, param:int):void
		{
			var form:IUITeamFBSys = m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBSys) as IUITeamFBSys;
			if(form && form.isUIReady())
			{
				form.psretChangeUserPosUserCmd(msg);
			}
		}
		
		//副本中，最佳闯关战斗过程
		public function processNotifyBestCopyPkReviewUserCmd(msg:ByteArray, param:int):void
		{
			m_gkcontext.m_contentBuffer.addContent("uibestcopypk_infor", msg);
			
			var form:Form = m_gkcontext.m_UIMgr.getForm(UIFormID.UIBestCopyPk);
			if (form)
			{
				form.updateData();
			}
			else
			{
				m_gkcontext.m_UIMgr.loadForm(UIFormID.UIBestCopyPk);
			}
		}
		
		// 返回数据
		public function psretFightHeroDataUserCmd(msg:ByteArray, param:int):void
		{	
			var form:IUITeamFBSys = m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBSys) as IUITeamFBSys;
			if(form)
			{
				if (form.isUIReady())
				{
					form.psretFightHeroDataUserCmd(msg);
				}
				else
				{
					m_gkcontext.m_contentBuffer.addContent("retFightHeroDataUserCmd", msg);
				}
			}
			else
			{
				//m_gkcontext.m_UIMgr.loadForm(UIFormID.UITeamFBSys);
				m_gkcontext.m_contentBuffer.addContent("retFightHeroDataUserCmd", msg);
				m_gkcontext.m_UIMgr.createFormInGame(UIFormID.UITeamFBSys);
			}
		}
		
		public function pssynCopyRewardExpUserCmd(msg:ByteArray, param:int):void
		{
			var form:IUITeamFBSys = m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBSys) as IUITeamFBSys;
			if(form)
			{
				if (form.isUIReady())
				{
					form.pssynCopyRewardExpUserCmd(msg);
				}
				else
				{
					m_gkcontext.m_contentBuffer.addContent("synCopyRewardExpUserCmd", msg);
				}
			}
			else
			{
				//m_gkcontext.m_UIMgr.loadForm(UIFormID.UITeamFBSys);
				m_gkcontext.m_contentBuffer.addContent("synCopyRewardExpUserCmd", msg);
				m_gkcontext.m_UIMgr.createFormInGame(UIFormID.UITeamFBSys);
			}
		}
		
		public function processSynMultiUserCopyProfigCountUserCmd(msg:ByteArray, param:int):void
		{
			var ret:synMultiUserCopyProfigCountUserCmd = new synMultiUserCopyProfigCountUserCmd();
			ret.deserialize(msg);
			
			m_gkcontext.m_teamFBSys.leftCounts = ret.m_count;
			process7ClockUserCmd_TeamFBSys(ret.m_count);
		}
		
		private function process7ClockUserCmd_TeamFBSys(count:uint):void
		{
			if (m_gkcontext.m_UIs.taskPrompt)
			{
				m_gkcontext.m_UIs.taskPrompt.updateLeftCountsAddTimes(TaskPromptMgr.TASKPROMPT_TeamFBSys, -1, count);
			}
			
			if (m_gkcontext.m_UIs.screenBtn)
			{
				m_gkcontext.m_UIs.screenBtn.updateLblCnt(count, ScreenBtnMgr.Btn_TeamFB);
			}
		}
		
		private function pssynTeamBossTodayCengUserCmd(msg:ByteArray, param:int):void
		{
			var cmd:synTeamBossTodayCengUserCmd = new synTeamBossTodayCengUserCmd();
			cmd.deserialize(msg);
			
			var oldHistoryLay:int = m_gkcontext.m_teamFBSys.count;
			m_gkcontext.m_teamFBSys.count = cmd.count;
			m_gkcontext.m_teamFBSys.historyLayer_TeamBoss = cmd.max;
			if (oldHistoryLay != m_gkcontext.m_teamFBSys.count )
			{
				m_gkcontext.m_peopleRankMgr.onValueUp(PeopleRankMgr.RANKTYPE_TeamGuoguan);
			}
		}
		
		private function psretTeamBossRankUserCmd(msg:ByteArray, param:int):void
		{
			var form:IUITeamFBSys = m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBSys) as IUITeamFBSys;
			if(form)
			{
				if (form.isUIReady())
				{
					form.psretTeamBossRankUserCmd(msg);
				}
				else
				{
					m_gkcontext.m_contentBuffer.addContent("retTeamBossRankUserCmd", msg);
				}
			}
			else
			{
				//m_gkcontext.m_UIMgr.loadForm(UIFormID.UITeamFBSys);
				m_gkcontext.m_contentBuffer.addContent("retTeamBossRankUserCmd", msg);
				m_gkcontext.m_UIMgr.createFormInGame(UIFormID.UITeamFBSys);
			}	
		}
		
		protected function psstRetTeamAssistInfoUserCmd(msg:ByteArray, param:uint):void
		{
			var form:IUITeamFBSys = m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBSys) as IUITeamFBSys;
			if (form)
			{
				if (form.isUIReady())
				{
					form.psstRetTeamAssistInfoUserCmd(msg);
				}
				else
				{
					m_gkcontext.m_contentBuffer.addContent("stRetTeamAssistInfoUserCmd", msg);
				}
			}
			else
			{
				//m_gkcontext.m_UIMgr.loadForm(UIFormID.UITeamFBSys);
				m_gkcontext.m_contentBuffer.addContent("stRetTeamAssistInfoUserCmd", msg);
				m_gkcontext.m_UIMgr.createFormInGame(UIFormID.UITeamFBSys);
			}
		}
		
		protected function psstGainTeamAssistGiftUserCmd(msg:ByteArray, param:uint):void
		{
			var form:IUITeamFBSys = m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBSys) as IUITeamFBSys;
			if (form)
			{
				if (form.isUIReady())
				{
					form.psstGainTeamAssistGiftUserCmd(msg);
				}
				else
				{
					m_gkcontext.m_contentBuffer.addContent("stGainTeamAssistGiftUserCmd", msg);
				}
			}
			else
			{
				//m_gkcontext.m_UIMgr.loadForm(UIFormID.UITeamFBSys);
				m_gkcontext.m_contentBuffer.addContent("stGainTeamAssistGiftUserCmd", msg);
				m_gkcontext.m_UIMgr.createFormInGame(UIFormID.UITeamFBSys);
			}
		}
		
		protected function psnotifyTouXiangData(msg:ByteArray, param:uint):void
		{
			var cmd:notifyTouXiangData = new notifyTouXiangData();
			cmd.deserialize(msg);
			var npcfake:NpcPlayerFake = m_gkcontext.m_playerFakeMgr.getBeingByTempID(cmd.tempid);
			if (npcfake)
			{
				npcfake.showTouXiangBtn();
				npcfake.cmd = cmd;
				//m_gkcontext.m_contentBuffer.addContent("notifyTouXiangData", cmd);
			}
		}
	}
}