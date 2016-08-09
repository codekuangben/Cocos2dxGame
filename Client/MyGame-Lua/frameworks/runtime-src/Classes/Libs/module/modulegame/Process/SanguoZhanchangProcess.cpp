package game.process 
{
	import game.netmsg.stResRobCmd.TitleItem;
	import game.netmsg.stResRobCmd.updateResRobBufferUserCmd;
	import game.netmsg.stResRobCmd.updateTitleNineUserCmd;
	import game.ui.collectProgress.notifyBeginPlayProgressUserCmd;
	import game.ui.collectProgress.UICollectProgress;
	import modulecommon.GkContext;
	import flash.utils.ByteArray;
	import modulecommon.net.msg.stResRobCmd.stResRobCmd;
	import modulecommon.scene.beings.Player;
	import modulecommon.scene.hero.AttrBufferMgr;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUISanguoZhangchang;
	/**
	 * ...
	 * @author ...
	 */
	public class SanguoZhanchangProcess extends ProcessBase 
	{		
		public function SanguoZhanchangProcess(gk:GkContext) 
		{
			super(gk);
			dicFun[stResRobCmd.SYN_RES_ROB_TIMES_USERCMD] = m_gkContext.m_sanguozhanchangMgr.process_synResRobTimesUserCmd;
			dicFun[stResRobCmd.SYN_INTO_ROB_RES_DATA_USERCMD] = m_gkContext.m_sanguozhanchangMgr.process_synIntoRobResDataUserCmd;
			dicFun[stResRobCmd.UPDATE_JIFEN_USERCMD] = transferToUI;
			dicFun[stResRobCmd.RET_GE_REN_PAI_HANG_BANG_USERCMD] = transferToUI;
			dicFun[stResRobCmd.RET_ZHEN_YING_PAI_HANG_BANG_USERCMD] = transferToUI;
			dicFun[stResRobCmd.NOTIFY_BEGIN_PLAY_PROGRESS_USERCMD] = process_notifyBeginPlayProgressUserCmd;
			dicFun[stResRobCmd.RET_GE_REN_TOTAL_PAI_HANG_BANG_USERCMD] = transferToUI;
			dicFun[stResRobCmd.UPDATE_TITLE_NINE_USERCMD] = process_updateTitleNineUserCmd;
			dicFun[stResRobCmd.UPDATE_RES_ROB_BUFFER_USERCMD] = process_updateResRobBufferUserCmd;
			dicFun[stResRobCmd.UPDATE_RES_ROB_WIN_TIME_DOWN_COUNT_USERCMD] = m_gkContext.m_sanguozhanchangMgr.process_updateResRobWinTimeDownCountUserCmd;
		}
		
		private function transferToUI(msg:ByteArray, param:uint):void
		{
			var ui:IUISanguoZhangchang = m_gkContext.m_UIMgr.getForm(UIFormID.UISanguoZhangchang) as IUISanguoZhangchang;
			if (ui)
			{
				ui.processCmd(msg, param);
			}
			else
			{
				if (param == stResRobCmd.UPDATE_JIFEN_USERCMD)
				{
					m_gkContext.m_contentBuffer.addContent("uiSanguoZhangchang_Updatejifen",msg);
				}
				else if (param == stResRobCmd.RET_GE_REN_PAI_HANG_BANG_USERCMD)
				{
					m_gkContext.m_contentBuffer.addContent("uiSanguoZhangchang_RetGeRenPaiHangBang",msg);
				}
				else if (param == stResRobCmd.RET_ZHEN_YING_PAI_HANG_BANG_USERCMD)
				{
					m_gkContext.m_contentBuffer.addContent("uiSanguoZhangchang_RetZhenYingPaiHangBang",msg);
				}
			}
		}
		
		private function process_notifyBeginPlayProgressUserCmd(msg:ByteArray, param:uint):void
		{
			var rev:notifyBeginPlayProgressUserCmd = new notifyBeginPlayProgressUserCmd();
			var form:UICollectProgress = m_gkContext.m_UIMgr.createFormInGame(UIFormID.UICollectProgress) as UICollectProgress;
			form.process_notifyBeginPlayProgressUserCmd(rev);
		}
		private function process_updateTitleNineUserCmd(msg:ByteArray, param:uint):void
		{
			var rev:updateTitleNineUserCmd = new updateTitleNineUserCmd();
			rev.deserialize(msg);
			
			var item:TitleItem;
			var player:Player;
			for each(item in rev.list)
			{
				player = m_gkContext.m_playerManager.getBeingByTmpID(item.tempid) as Player;
				if (player)
				{
					player.m_titileInSanguozhanchang = item.title;
					if (player.m_zhenying != item.zhengying)
					{						
						player.m_zhenying = item.zhengying;
					}
					m_gkContext.addLog("updateTitleNineUserCmd：["+player.name+"]的阵营是"+item.zhengying);
					player.updateNameDesc();
				}
				else
				{
					m_gkContext.addLog("updateTitleNineUserCmd：不存在玩家"+item.tempid);
				}
			}
			
		}
		private function process_updateResRobBufferUserCmd(msg:ByteArray, param:uint):void
		{
			var rev:updateResRobBufferUserCmd = new updateResRobBufferUserCmd();
			rev.deserialize(msg);
			m_gkContext.m_sanguozhanchangMgr.m_woxinchangdanLevel = rev.level;
			if (m_gkContext.m_UIs.hero)
			{
				if (rev.level)
				{
					m_gkContext.m_UIs.hero.addBufferIcon(AttrBufferMgr.TYPE_SANGGUOZHANCHANG, AttrBufferMgr.BufferID_Woxinchangdan);
				}
				else
				{
					m_gkContext.m_UIs.hero.removeBufferIcon(AttrBufferMgr.BufferID_Woxinchangdan);
				}
			}
		}
		
	}

}