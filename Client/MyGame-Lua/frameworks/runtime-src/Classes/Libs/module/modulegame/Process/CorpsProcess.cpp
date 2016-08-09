package game.process
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import game.netmsg.corpscmd.notifyOneReqJoinCorpsUserCmd;
	import game.netmsg.corpscmd.retAgreeJoinCorpsUserCmd;
	import game.netmsg.corpscmd.retCorpsQuestInfoUserCmd;
	import game.netmsg.corpscmd.retCreateCorpsUserCmd;
	import game.netmsg.corpscmd.retDonateCorpsUserCmd;
	import game.netmsg.corpscmd.retInviteUserJoinCorpsUserCmd;
	import game.netmsg.corpscmd.retJoinCorpsUserCmd;
	import game.netmsg.corpscmd.updateCorpsWuziUserCmd;
	import game.netmsg.corpscmd.updateRegJoinCorpsFightStateUserCmd;
	import game.netmsg.corpscmd.updateUserCorpsContriUserCmd;
	
	import modulecommon.GkContext;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.net.msg.corpscmd.notifyBeAttackUserCmd;
	import modulecommon.net.msg.corpscmd.notifyCorpsNpcIDUserCmd;
	import modulecommon.net.msg.corpscmd.stCorpsCmd;
	import modulecommon.scene.infotip.InfoTip;
	import com.util.UtilHtml;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IForm;
	import modulecommon.uiinterface.IUICorpsCitySys;

	public class CorpsProcess  extends ProcessBase 
	{
		public function CorpsProcess(gk:GkContext)
		{
			super(gk);
			dicFun = new Dictionary();
			
			dicFun[stCorpsCmd.RET_CORPS_LIST_USERCMD] = processretCorpsListUserCmd;
			dicFun[stCorpsCmd.RET_CREATE_CORPS_USERCMD] = processretCreateCorpsUserCmd;
			dicFun[stCorpsCmd.NOTIFY_CORPS_KEJI_PROP_VALUE_USERCMD] = m_gkContext.m_corpsMgr.processCorpsKejiPropValueUserCmd;
			dicFun[stCorpsCmd.UPDATE_CORPS_LEVEL_USERCMD] = m_gkContext.m_corpsMgr.process_updateCorpsLevelUserCmd;
			dicFun[stCorpsCmd.RET_JOIN_CORPS_USERCMD] = processretJoinCorpsUserCmd;
			dicFun[stCorpsCmd.NOTIFY_ONE_REQ_JOIN_CORPS_USERCMD] = processnotifyOneReqJoinCorpsUserCmd;
			dicFun[stCorpsCmd.RET_CORPS_DYNAMIC_INFO_USERCMD] = transmitToUICorpsInfo;
			dicFun[stCorpsCmd.NOTIFY_CORPS_NAME_USERCMD] = m_gkContext.m_corpsMgr.processNotifyCorpsNameUserCmd;
			dicFun[stCorpsCmd.RET_CORPS_INFO_USERCMD] = transmitToUICorpsInfo;
			dicFun[stCorpsCmd.RET_CORPS_MEMBER_LIST_USERCMD] = transmitToUICorpsInfo;
			dicFun[stCorpsCmd.PRIV_CHANGE_USERCMD] = transmitToUICorpsInfo;
			dicFun[stCorpsCmd.RET_DONATE_CORPS_USERCMD] = processretDonateCorpsUserCmd;
			dicFun[stCorpsCmd.RET_CORPS_BUILDING_USERCMD] = transmitToUICorpsInfo;
			dicFun[stCorpsCmd.RET_OEPEN_CORPS_XUEXI_UI_INFO_USERCMD] = transmitToUICorpsKejiLearn;
			dicFun[stCorpsCmd.RET_CORPS_XUEXI_KEJI_USERCMD] = transmitToUICorpsKejiLearn;
			dicFun[stCorpsCmd.UPDATE_CORPS_WUZI_USERCMD] = processUpdateCorpsWuziUserCmd;
			dicFun[stCorpsCmd.RET_LEVELUP_CORPS_MAIN_BUILDING_USERCMD] = transmitToUICorpsInfo;
			dicFun[stCorpsCmd.EXPEL_CORPS_USERCMD] = transmitToUICorpsInfo;
			dicFun[stCorpsCmd.REQ_EDIT_CORPS_GONGGAO_USERCMD] = transmitToUICorpsInfo;
			dicFun[stCorpsCmd.RET_CORPS_KEJI_YAN_JIU_LEVEL_USERCMD] = transmitToUICorpsKejiYanjiu;
			dicFun[stCorpsCmd.REQ_CORPS_INCREASE_KEJI_USERCMD] = transmitToUICorpsKejiYanjiu;
			dicFun[stCorpsCmd.UPDATE_USER_CORPS_CONTRI_USERCMD] = processUpdateUserCorpsContriUserCmd;
			dicFun[stCorpsCmd.RET_CORPS_QUEST_INFO_USERCMD] = processCorpsQuestInfoUserCmd;
			dicFun[stCorpsCmd.RET_CORPS_QUEST_SET_UI_USERCMD] = transmitToUICorpsTaskPublish;
			dicFun[stCorpsCmd.RET_SET_IMPORT_CORPS_QUEST_USERCMD] = transmitToUICorpsTaskPublish;
			
			dicFun[stCorpsCmd.RET_OPEN_CORPS_QUEST_UI_USERCMD] = transmitToUITaskJiequ;
			dicFun[stCorpsCmd.RET_GET_CORPS_QUEST_USERCMD] = transmitToUITaskJiequ;
			dicFun[stCorpsCmd.RET_SET_ALL_IMPORT_QUEST_USERCMD] = transmitToUITaskJiequ;
			dicFun[stCorpsCmd.RET_INVITE_USER_JOIN_CORPS_USERCMD] = psretInviteUserJoinCorpsUserCmd;
			
			dicFun[stCorpsCmd.UPDATE_CORPS_BOX_NUMBER_USERCMD] = m_gkContext.m_corpsMgr.processUpdateCorpsBoxNumberUsercmd;
			dicFun[stCorpsCmd.RET_ASSIGN_BOX_UI_CORPS_MEMBER_LIST_USERCMD] = m_gkContext.m_corpsMgr.processAssignBoxUICorpsMemberListUserCmd;
			dicFun[stCorpsCmd.NOTIFY_MAX_QUEST_TIMES_USERCMD] = m_gkContext.m_corpsMgr.processNotifyMaxQuestTimesUserCmd;
			dicFun[stCorpsCmd.UPDATE_COOL_DOWN_TIME_CORPS_USERCMD] = m_gkContext.m_corpsMgr.process_updateCoolDownTimeCorpsUserCmd;
			dicFun[stCorpsCmd.NOTIFY_CORPS_FIRE_POS_USERCMD] = m_gkContext.m_corpsMgr.processNotifyCorpsFirePosUserCmd;
			
			dicFun[stCorpsCmd.NOTIFY_CORPS_NPC_ID_USERCMD] = psnotifyCorpsNpcIDUserCmd;
			dicFun[stCorpsCmd.NOTIFY_BIG_MAP_DATA_USERCMD] = psnotifyBigMapDataUserCmd;
			dicFun[stCorpsCmd.UPDATE_FIGHT_JI_FEN_DATA_USERCMD] = psupdateFightJiFenDataUserCmd;
			dicFun[stCorpsCmd.UPDATE_CITY_DATA_USERCMD] = psupdateCityDataUserCmd;
			dicFun[stCorpsCmd.NOTIFY_ZHAN_BAO_USERCMD] = psnotifyZhanBaoUserCmd;
			dicFun[stCorpsCmd.NOTIFY_BE_ATTACK_USERCMD] = psnotifyBeAttackUserCmd;
			dicFun[stCorpsCmd.RET_ATTACK_REVIEW_LIST_USERCMD] = psretAttackReviewListUserCmd;
			dicFun[stCorpsCmd.RET_OPEN_CITY_USERCMD] = psretOpenCityUserCmd;
			dicFun[stCorpsCmd.PARA_RET_LOTTERY_RESULT_USERCMD] = m_gkContext.m_corpsMgr.processRetLotteryResultUserCmd;
			
			dicFun[stCorpsCmd.NOTIFY_CORPS_FIGHT_LAST_TIME_USERCMD] = psnotifyCorpsFightLastTimeUserCmd;
			dicFun[stCorpsCmd.NOTIFY_REG_CORPS_FIGHT_USERCMD] = psnotifyRegCorpsFightUserCmd;
			dicFun[stCorpsCmd.UPDATE_REG_JOIN_CORPS_FIGHT_STATE_USERCMD] = psupdateRegJoinCorpsFightStateUserCmd;
			dicFun[stCorpsCmd.VIEW_USER_CORPS_KEJI_PROP_VALUE_USERCMD] = m_gkContext.m_corpsMgr.processViewUserCorpsKejiPropValueUserCmd;
			dicFun[stCorpsCmd.GM_VIEW_USER_CORPS_KEJI_PROP_VALUE_USERCMD] = m_gkContext.m_gmWatchMgr.processgmViewUserCorpsKejiPropValueUserCmd;
			dicFun[stCorpsCmd.PARA_NOTIFY_CORPS_LOTTERY_TIMES_USERCMD] = m_gkContext.m_corpsMgr.processNotifyCorpsLotteryTimesUserCmd;
			dicFun[stCorpsCmd.RET_CORPS_TREASURE_UI_HISTORY_USERCMD] = transmitToUICorpsInfo;
		}
		
		// 军团数据
		public function processretCorpsListUserCmd(msg:ByteArray, param:uint):void
		{			
			//m_gkContext.m_beingProp.m_rela.m_relArmy.m_lstCorps = rev.data;		// 保存军团数据
			// 更新数据
			var form:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UICorpsLst);
			if(form)
			{
				form.updateData(msg);
			}
		}
		
		public function processretCreateCorpsUserCmd(msg:ByteArray, param:uint):void
		{
			var rev:retCreateCorpsUserCmd = new retCreateCorpsUserCmd();
			rev.deserialize(msg);			
			
			if (rev.ret == 1)
			{
				//创建兵团成功
				var ui:Form = m_gkContext.m_UIMgr.getForm(UIFormID.UICorpsCreate);
				if (ui)
				{
					ui.exit();
				}
				m_gkContext.m_UIMgr.exitForm(UIFormID.UICorpsLst);
				m_gkContext.m_corpsMgr.openPage();
			}
		}
		
		// 返回请求加入军团
		public function processretJoinCorpsUserCmd(msg:ByteArray, param:uint):void
		{
			var cmd:retJoinCorpsUserCmd = new retJoinCorpsUserCmd();
			cmd.deserialize(msg);
			
		}
		
		//通知有人申请入团
		public function processnotifyOneReqJoinCorpsUserCmd(msg:ByteArray, param:uint):void
		{
			var rev:notifyOneReqJoinCorpsUserCmd = new notifyOneReqJoinCorpsUserCmd();
			rev.deserialize(msg);
			m_gkContext.m_commonProc.addInfoTip(InfoTip.ENShenqingCorps, rev.reqNum);
		}
		
		public function transmitToUICorpsInfo(msg:ByteArray, param:uint):void
		{
			if (m_gkContext.m_corpsMgr.m_ui)
			{
				m_gkContext.m_corpsMgr.m_ui.processCmd(msg, param);
			}			
			
		}
		
		//消息转发到科技研究界面
		public function transmitToUICorpsKejiYanjiu(msg:ByteArray, param:uint):void
		{
			var ui:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UICorpsKejiYanjiu);
			if (ui)
			{
				var obj:Object = new Object();
				obj["msg"] = msg;
				obj["param"] = param;
				ui.updateData(obj);
			}
		}
		//消息转发到科技学习界面
		public function transmitToUICorpsKejiLearn(msg:ByteArray, param:uint):void
		{
			var ui:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UICorpsKejiLearn);
			if (ui)
			{
				var obj:Object = new Object();
				obj["msg"] = msg;
				obj["param"] = param;
				ui.updateData(obj);
			}
		}
		//更新团物资
		public  function processUpdateCorpsWuziUserCmd(msg:ByteArray, param:uint):void
		{
			var revUpdateCorpsWuziUserCmd:updateCorpsWuziUserCmd = new updateCorpsWuziUserCmd();
			revUpdateCorpsWuziUserCmd.deserialize(msg);
			m_gkContext.m_corpsMgr.m_corpsInfo.wuzi = revUpdateCorpsWuziUserCmd.wuzi;
			if (m_gkContext.m_corpsMgr.m_ui)
			{
				m_gkContext.m_corpsMgr.m_ui.onWuziChange();
			}
			
			var ui:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UICorpsKejiYanjiu);
			if (ui)
			{
				var obj:Object = new Object();
				obj["msg"] = msg;
				obj["param"] = param;
				ui.updateData(obj);
			}			
		}
		//更新个人贡献值
		public  function processUpdateUserCorpsContriUserCmd(msg:ByteArray, param:uint):void
		{
			var rev:updateUserCorpsContriUserCmd = new updateUserCorpsContriUserCmd();
			rev.deserialize(msg);
			m_gkContext.m_corpsMgr.m_corpsInfo.gongxian = rev.contri;
			if (m_gkContext.m_corpsMgr.m_ui)
			{
				//更新物资的时候也会更新贡献的
				m_gkContext.m_corpsMgr.m_ui.onWuziChange();
			}
			var ui:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UICorpsKejiLearn);
			if (ui)
			{
				var obj:Object = new Object();
				obj["msg"] = msg;
				obj["param"] = param;
				ui.updateData(obj);
			}
			
			if (m_gkContext.m_marketMgr.m_uiCorpsMarketForm && m_gkContext.m_marketMgr.m_uiCorpsMarketForm.isVisible())
			{
				m_gkContext.m_marketMgr.m_uiCorpsMarketForm.updateGongxian();
			}		
		}
		public  function processretDonateCorpsUserCmd(msg:ByteArray, param:uint):void
		{
			var rev:retDonateCorpsUserCmd = new retDonateCorpsUserCmd();
			rev.deserialize(msg);
			
			m_gkContext.m_corpsMgr.m_corpsInfo.wuzi = rev.wuzi;
			m_gkContext.m_corpsMgr.m_corpsInfo.gongxian = rev.contri;
			
			if (m_gkContext.m_corpsMgr.m_ui)
			{
				//更新物资的时候也会更新贡献的
				m_gkContext.m_corpsMgr.m_ui.onWuziChange();
			}
			
			var ui:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UICorpsDonate);
			if (ui)
			{
				ui.updateData();
			}
			if (m_gkContext.m_marketMgr.m_uiCorpsMarketForm && m_gkContext.m_marketMgr.m_uiCorpsMarketForm.isVisible())
			{
				m_gkContext.m_marketMgr.m_uiCorpsMarketForm.updateGongxian();
			}		
		}
		public  function processCorpsQuestInfoUserCmd(msg:ByteArray, param:uint):void
		{
			var rev:retCorpsQuestInfoUserCmd = new retCorpsQuestInfoUserCmd();
			rev.deserialize(msg);
			m_gkContext.m_corpsMgr.m_taskInfoList = rev.m_taskInfoList;
		}
		public function transmitToUICorpsTaskPublish(msg:ByteArray, param:uint):void
		{
			var ui:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UICorpsTaskPublish);
			if (ui)
			{
				var obj:Object = new Object();
				obj["msg"] = msg;
				obj["param"] = param;
				ui.updateData(obj);
			}
		}
		public function transmitToUITaskJiequ(msg:ByteArray, param:uint):void
		{
			var ui:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UITaskJiequ);
			if (ui)
			{
				var obj:Object = new Object();
				obj["msg"] = msg;
				obj["param"] = param;
				ui.updateData(obj);
			}
		}
		
		// 邀请加入军团
		public function psretInviteUserJoinCorpsUserCmd(msg:ByteArray, param:uint):void
		{
			var cmd:retInviteUserJoinCorpsUserCmd = new retInviteUserJoinCorpsUserCmd();
			cmd.deserialize(msg);
			
			m_gkContext.m_contentBuffer.addContent("retInviteUserJoinCorpsUserCmd", cmd);
			
			UtilHtml.beginCompose();
			UtilHtml.addStringNoFormat(cmd.corpsname + "军团的" + cmd.name + "邀请你加入军团");
			var desc:String = UtilHtml.getComposedContent();
			m_gkContext.m_confirmDlgMgr.showMode1(0, desc, okCB, cancelCB, "确认", "取消", null, true);
		}
		
		public function okCB():Boolean
		{
			var msg:retInviteUserJoinCorpsUserCmd = m_gkContext.m_contentBuffer.getContent("retInviteUserJoinCorpsUserCmd", true) as retInviteUserJoinCorpsUserCmd;
			var cmd:retAgreeJoinCorpsUserCmd = new retAgreeJoinCorpsUserCmd();
			cmd.retcode = 1;
			cmd.name = msg.name;
			m_gkContext.sendMsg(cmd);
			return true;
		}
		
		public function cancelCB():Boolean
		{
			var msg:retInviteUserJoinCorpsUserCmd = m_gkContext.m_contentBuffer.getContent("retInviteUserJoinCorpsUserCmd", true) as retInviteUserJoinCorpsUserCmd;
			var cmd:retAgreeJoinCorpsUserCmd = new retAgreeJoinCorpsUserCmd();
			cmd.retcode = 2;
			cmd.name = msg.name;
			m_gkContext.sendMsg(cmd);
			return true;
		}
		
		protected function psnotifyCorpsNpcIDUserCmd(msg:ByteArray, param:uint):void
		{
			var cmd:notifyCorpsNpcIDUserCmd = new notifyCorpsNpcIDUserCmd();
			cmd.deserialize(msg);
			
			// 存储这个消息
			m_gkContext.m_contentBuffer.addContent("notifyCorpsNpcIDUserCmd", cmd);
		}
		
		// 正式进入城市
		protected function psnotifyBigMapDataUserCmd(msg:ByteArray, param:uint):void
		{
			var ui:IUICorpsCitySys = m_gkContext.m_UIMgr.getForm(UIFormID.UICorpsCitySys) as IUICorpsCitySys;
			if (ui && ui.bReady)
			{
				ui.psnotifyBigMapDataUserCmd(msg);
			}
			else
			{
				m_gkContext.m_UIMgr.loadForm(UIFormID.UICorpsCitySys);
				m_gkContext.m_contentBuffer.addContent("notifyBigMapDataUserCmd", msg);
			}
		}
		
		protected function psupdateFightJiFenDataUserCmd(msg:ByteArray, param:uint):void
		{
			// 界面存在更新
			var ui:IUICorpsCitySys = m_gkContext.m_UIMgr.getForm(UIFormID.UICorpsCitySys) as IUICorpsCitySys;
			if (ui && ui.bReady)
			{
				ui.psupdateFightJiFenDataUserCmd(msg);
			}
			else	// 保存
			{
				m_gkContext.m_contentBuffer.addContent("updateFightJiFenDataUserCmd", msg);
			}
		}
		
		protected function psupdateCityDataUserCmd(msg:ByteArray, param:uint):void
		{
			// 界面存在更新
			var ui:IUICorpsCitySys = m_gkContext.m_UIMgr.getForm(UIFormID.UICorpsCitySys) as IUICorpsCitySys;
			if (ui && ui.bReady)
			{
				ui.psupdateCityDataUserCmd(msg);
			}
			else
			{
				m_gkContext.m_contentBuffer.addContent("updateCityDataUserCmd", msg);
			}
		}
		
		protected function psretOpenCityUserCmd(msg:ByteArray, param:uint):void
		{
			// 界面存在更新
			var ui:IUICorpsCitySys = m_gkContext.m_UIMgr.getForm(UIFormID.UICorpsCitySys) as IUICorpsCitySys;
			if (ui && ui.bReady)
			{
				ui.psretOpenCityUserCmd(msg);
			}
		}
		
		// 战报列表
		protected function psnotifyZhanBaoUserCmd(msg:ByteArray, param:uint):void
		{
			// 界面存在更新
			var ui:IUICorpsCitySys = m_gkContext.m_UIMgr.getForm(UIFormID.UICorpsCitySys) as IUICorpsCitySys;
			if (ui && ui.bReady)
			{
				ui.psnotifyZhanBaoUserCmd(msg);
			}
			else
			{
				m_gkContext.m_contentBuffer.addContent("notifyZhanBaoUserCmd", msg);			// 存储消息
			}
		}
		
		// 防守者受到攻击时收到此消息
		protected function psnotifyBeAttackUserCmd(msg:ByteArray, param:uint):void
		{
			var cmd:notifyBeAttackUserCmd = new notifyBeAttackUserCmd();
			cmd.deserialize(msg);
			
			// 这个需要保存一下,直到城市争夺战结束
			m_gkContext.m_contentBuffer.addContent("notifyBeAttackUserCmd", cmd);
			m_gkContext.m_commonProc.addInfoTip(InfoTip.ENCorpsAttLst, cmd.size);
		}
		
		//返回回看战斗玩家列表
		protected function psretAttackReviewListUserCmd(msg:ByteArray, param:uint):void
		{
			// 界面存在更新
			var ui:IUICorpsCitySys = m_gkContext.m_UIMgr.getForm(UIFormID.UICorpsCitySys) as IUICorpsCitySys;
			if (ui && ui.bReady)
			{
				ui.psretAttackReviewListUserCmd(msg);
			}
			else
			{
				m_gkContext.m_contentBuffer.addContent("retAttackReviewListUserCmd", msg);
				m_gkContext.m_UIMgr.loadForm(UIFormID.UICorpsCitySys);
			}
		}
		
		protected function psnotifyCorpsFightLastTimeUserCmd(msg:ByteArray, param:uint):void
		{
			// 界面存在更新
			var ui:IUICorpsCitySys = m_gkContext.m_UIMgr.getForm(UIFormID.UICorpsCitySys) as IUICorpsCitySys;
			if (ui && ui.bReady)
			{
				ui.psnotifyCorpsFightLastTimeUserCmd(msg);
			}
			else
			{
				m_gkContext.m_contentBuffer.addContent("notifyCorpsFightLastTimeUserCmd", msg);
				m_gkContext.m_UIMgr.loadForm(UIFormID.UICorpsCitySys);
			}
		}
		
		// 通知军团副军团报名
		protected function psnotifyRegCorpsFightUserCmd(msg:ByteArray, param:uint):void
		{
			// 只有开启的时候才会弹出来
			if (m_gkContext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_CITYBATTLE))
			{
				// 界面存在更新
				var ui:IUICorpsCitySys = m_gkContext.m_UIMgr.getForm(UIFormID.UICorpsCitySys) as IUICorpsCitySys;
				if (ui && ui.bReady)
				{
					ui.psnotifyRegCorpsFightUserCmd(msg);
				}
				else
				{
					m_gkContext.m_contentBuffer.addContent("notifyRegCorpsFightUserCmd", msg);
					m_gkContext.m_UIMgr.loadForm(UIFormID.UICorpsCitySys);
				}
			}
		}
		
		protected function psupdateRegJoinCorpsFightStateUserCmd(msg:ByteArray, param:uint):void
		{
			var cmd:updateRegJoinCorpsFightStateUserCmd = new updateRegJoinCorpsFightStateUserCmd();
			cmd.deserialize(msg);
			
			m_gkContext.m_corpsMgr.m_reg = cmd.reg;

			// 显示对话框
			if (m_gkContext.m_corpsCitySys.inActive)		// 如果已经报名了
			{
				// 只有开启的时候才会弹出来
				if (m_gkContext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_CITYBATTLE))
				{
					// 界面存在更新
					var uicorps:IUICorpsCitySys = m_gkContext.m_UIMgr.getForm(UIFormID.UICorpsCitySys) as IUICorpsCitySys;
					if (uicorps && uicorps.bReady)
					{
						uicorps.psnotifyRegCorpsFightUserCmd(null);
					}
					else
					{
						m_gkContext.m_contentBuffer.addContent("notifyRegCorpsFightUserCmd", m_gkContext.m_context.m_SObjectMgr.m_nullByteArray);
						m_gkContext.m_UIMgr.loadForm(UIFormID.UICorpsCitySys);
					}
				}
			}
		}
	}
}