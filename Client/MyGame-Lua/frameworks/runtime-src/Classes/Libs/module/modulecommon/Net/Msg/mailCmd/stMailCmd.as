package modulecommon.net.msg.mailCmd 
{
	import common.net.msg.basemsg.stNullUserCmd;
	import common.net.endata.EnNet;
	/**
	 * ...
	 * @author 
	 */
	public class stMailCmd extends stNullUserCmd 
	{
		public static const REQ_MAIL_LIST_USERCMD:uint = 1;
		public static const RET_MAIL_LIST_USERCMD:uint = 2;
		public static const REQ_READ_MAIL_USERCMD:uint = 3;
		public static const RET_READ_MAIL_USERCMD:uint = 4;
		public static const REQ_WRITE_MAIL_USERCMD:uint = 5;
		public static const GET_MAIL_FUJIAN_USERCMD:uint = 6;
		public static const DEL_MAIL_FUJIAN_USERCMD:uint = 7;
		public static const NOTIFY_NEW_MAIL_USERCMD:uint = 8;	//s->c通知有新邮件,此消息没有定义
		public static const RET_WRITE_MAIL_USERCMD:uint = 9;
		public static const REQ_RANSOM_BAOWU_USERCMD:uint = 10;
		public function stMailCmd()
		{
			byCmd = MAIL_USERCMD; //14
		}
		
	}

}