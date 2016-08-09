package game.process 
{
	/**
	 * ...
	 * @author 
	 */	
	import flash.utils.ByteArray;
	
	import game.netmsg.mail.stNotifyNewMailUserCmd;
	
	import modulecommon.GkContext;
	import modulecommon.net.msg.mailCmd.MailHead;
	import modulecommon.net.msg.mailCmd.stMailCmd;
	import modulecommon.net.msg.mailCmd.stRetMailListCmd;
	import modulecommon.scene.infotip.InfoTip;
	import modulecommon.ui.UIFormID;
	//import modulecommon.uiinterface.IUIInfoTip;
	import modulecommon.uiinterface.IUIMail;
	//import uiMail.msg.stReqReadMailUserCmd;
	
	public class MailProcess extends ProcessBase
	{		
		public function MailProcess(gk:GkContext) 
		{
			super(gk);
			dicFun[stMailCmd.RET_MAIL_LIST_USERCMD] = processMailListCmd;
			dicFun[stMailCmd.RET_READ_MAIL_USERCMD] = processMailByUIMail;
			dicFun[stMailCmd.GET_MAIL_FUJIAN_USERCMD] = processMailByUIMail;
			dicFun[stMailCmd.RET_WRITE_MAIL_USERCMD] = processMailByUIMail;
			dicFun[stMailCmd.REQ_RANSOM_BAOWU_USERCMD] = processMailByUIMail;
			dicFun[stMailCmd.NOTIFY_NEW_MAIL_USERCMD] = processNotifyNewMailUserCmd;
		}
		
		private function processMailListCmd(msg:ByteArray, param:uint):void
		{			
			m_gkContext.m_contentBuffer.addContent("uiMail_mailList", msg);
			
			var ui:IUIMail = m_gkContext.m_UIMgr.getForm(UIFormID.UIMail) as IUIMail;
			if(!m_gkContext.m_mapInfo.m_bInArean || isAreanMail(msg))	// 如果不在竞技场,或在在竞技场并且有竞技场邮件
			{
				if (ui)
				{
					ui.processMailListCmd();
					ui.show();
				}
				else
				{
					m_gkContext.m_UIMgr.loadForm(UIFormID.UIMail);
				}
			}
		}
		
		// 是否是竞技场中的邮件,并且有竞技场邮件
		private function isAreanMail(msg:ByteArray):Boolean
		{
			var listCmd:stRetMailListCmd = new stRetMailListCmd();
			listCmd.deserialize(msg);
			msg.position = 0;

			// 如果在竞技场
			if(m_gkContext.m_mapInfo.m_bInArean)
			{
				// 竞技场中如果收到主题是 "武举擂台积分奖励" 并且没有阅读的邮件，就主动打开这个邮件
				for each(var item:MailHead in listCmd.m_systemList)
				{
					if(!item.readed && item.type&0x4)	// 武举擂台
					{
						// 主动打开邮件
						return true;
					}
				}
			}

			return false;
		}
		
		private function processMailByUIMail(msg:ByteArray, param:uint):void
		{
			var ui:IUIMail = m_gkContext.m_UIMgr.getForm(UIFormID.UIMail) as IUIMail;
			if (ui)
			{
				ui.processMsg(msg, param);
			}
		}
		
		//通知有新邮件
		private function processNotifyNewMailUserCmd(msg:ByteArray, param:uint):void
		{
			var cmd:stNotifyNewMailUserCmd = new stNotifyNewMailUserCmd();
			cmd.deserialize(msg);
			m_gkContext.m_commonProc.addInfoTip(InfoTip.ENmail, cmd.num);			
		}
	}
}