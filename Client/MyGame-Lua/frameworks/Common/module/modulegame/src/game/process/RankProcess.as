package game.process
{
	import flash.utils.ByteArray;
	import game.ui.uichargerank.UIChargeRank;
	import modulecommon.GkContext;
	import modulecommon.net.msg.rankcmd.CorpsLevelRankItem;
	import modulecommon.net.msg.rankcmd.stPersonalZhanLiRankListCmd;
	import modulecommon.net.msg.rankcmd.stPersonlLevelRankListCmd;
	import modulecommon.net.msg.rankcmd.stRankCmd;
	import modulecommon.net.msg.rankcmd.stRetCorpsCombatPowerRankListUserCmd;
	import modulecommon.net.msg.rankcmd.stRetCorpsLevelRankListUserCmd;
	import modulecommon.scene.wu.WuMainProperty;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIRanklist;
	import modulecommon.net.msg.rankcmd.stPersonalRankItem;

	/**
	 * @brief 排行榜处理
	 */
	public class RankProcess extends ProcessBase
	{
		public function RankProcess(gk:GkContext) 
		{
			super(gk);
			dicFun[stRankCmd.RET_CORPS_LEVEL_RANK_LIST_USERCMD] = psstRetCorpsLevelRankListUserCmd;		
			dicFun[stRankCmd.RET_CORPS_COMBAT_POWER_RANK_LIST_USERCMD] = psstRetCorpsCombatPowerRankListUserCmd;		
			dicFun[stRankCmd.PARA_PERSONAL_LEVEL_RANK_LIST_USERCMD] = psstPersonlLevelRankListCmd;		
			dicFun[stRankCmd.PARA_PERSONAL_ZHANLI_RANK_LIST_USERCMD] = psstPersonalZhanLiRankListCmd;	
			dicFun[stRankCmd.PARA_7DAY_RECHARGE_RANK_LIST_USERCMD] = psst7DayRechargeRankListCmd;	
		}
		protected function psst7DayRechargeRankListCmd(msg:ByteArray, param:uint):void
		{
			var form:UIChargeRank = m_gkContext.m_UIMgr.createFormInGame(UIFormID.UIChargeRank) as UIChargeRank;
			if (form)
			{
				form.process_st7DayRechargeRankListCmd(msg);
			}
		}
		protected function psstRetCorpsLevelRankListUserCmd(msg:ByteArray, param:uint):void
		{
			var cmd:stRetCorpsLevelRankListUserCmd = new stRetCorpsLevelRankListUserCmd();
			cmd.deserialize(msg);

			m_gkContext.m_rankSys.corpsLevelRank = cmd;
			var uirank:IUIRanklist = m_gkContext.m_UIMgr.getForm(UIFormID.UIRanklist) as IUIRanklist;
			if (uirank && uirank.isResReady())
			{
				uirank.psstRetCorpsLevelRankListUserCmd(cmd);
			}
		}
		
		// 解析军团等级排名消息的时候的回调
		//protected function cbCorpsLevelRank(item:CorpsLevelRankItem):void
		//{
		//	if (m_gkContext.m_corpsMgr.m_corpsName == item.name)
		//	{
		//		m_gkContext.m_rankSys.selfCorpsLevel = item.level;
		//		m_gkContext.m_rankSys.selfCorpsRank = item.mNo;
		//	}
		//}
		
		protected function psstRetCorpsCombatPowerRankListUserCmd(msg:ByteArray, param:uint):void
		{
			var cmd:stRetCorpsCombatPowerRankListUserCmd = new stRetCorpsCombatPowerRankListUserCmd();
			cmd.deserialize(msg);

			m_gkContext.m_rankSys.corpsCombatRank = cmd;
			var uirank:IUIRanklist = m_gkContext.m_UIMgr.getForm(UIFormID.UIRanklist) as IUIRanklist;
			if (uirank && uirank.isResReady())
			{
				uirank.psstRetCorpsCombatPowerRankListUserCmd(cmd);
			}
		}
		
		protected function psstPersonlLevelRankListCmd(msg:ByteArray, param:uint):void
		{
			var cmd:stPersonlLevelRankListCmd = new stPersonlLevelRankListCmd();
			cmd.mfCB = personlLevelRankListCB;
			cmd.deserialize(msg);

			m_gkContext.m_rankSys.personLevelRank = cmd;
			var uirank:IUIRanklist = m_gkContext.m_UIMgr.getForm(UIFormID.UIRanklist) as IUIRanklist;
			if (uirank && uirank.isResReady())
			{
				uirank.psstPersonlLevelRankListCmd(cmd);
			}
		}
		
		protected function psstPersonalZhanLiRankListCmd(msg:ByteArray, param:uint):void
		{
			var cmd:stPersonalZhanLiRankListCmd = new stPersonalZhanLiRankListCmd();
			cmd.mfCB = personlLevelRankListCB;
			cmd.deserialize(msg);

			m_gkContext.m_rankSys.personCombatRank = cmd;
			var uirank:IUIRanklist = m_gkContext.m_UIMgr.getForm(UIFormID.UIRanklist) as IUIRanklist;
			if (uirank && uirank.isResReady())
			{
				uirank.psstPersonalZhanLiRankListCmd(cmd);
			}
		}
		
		// 回调检查是否是自己的信息
		protected function personlLevelRankListCB(item:stPersonalRankItem):Boolean
		{
			if (item.charid == m_gkContext.m_playerManager.hero.charID)		// 如果是主角自己
			{
				// 需要填写主角的信息
				var wu:WuMainProperty = this.m_gkContext.m_wuMgr.getMainWu();
				item.name = m_gkContext.playerMain.name;
				item.job = m_gkContext.playerMain.job;
				if (wu)
				{
					item.level = wu.m_uLevel;
					item.zhanli = wu.m_uZongZhanli;
				}
				item.corpsname = m_gkContext.m_corpsMgr.m_corpsName;
				
				return true;
			}
			
			return false;
		}
	}
}