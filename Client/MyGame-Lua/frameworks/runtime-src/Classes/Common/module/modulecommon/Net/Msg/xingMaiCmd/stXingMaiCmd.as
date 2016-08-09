package modulecommon.net.msg.xingMaiCmd 
{
	import common.net.msg.basemsg.stNullUserCmd;
	/**
	 * ...
	 * @author 
	 */
	
	public class stXingMaiCmd extends stNullUserCmd 
	{
		public static const PARA_XINGMAI_UIINFO_XMCMD:uint = 1;			//上线发送觉醒界面数据
		public static const PARA_LEVELUP_XMATTR_XMCMD:uint = 2;			//请求升级属性
		public static const PARA_NOTIFY_XMSKILL_ACTIVE_XMCMD:uint = 3;	//星脉技能激活 s->c
		public static const PARA_CHANGE_USERSKILL_XMCMD:uint = 4;		//更换技能
		public static const PARA_LEVELUP_XMSKILL_XMCMD:uint = 5;		//星脉技能升级
		public static const PARA_XINGLI_CHANGE_XMCMD:uint = 6;			//星力变化
		
		public function stXingMaiCmd() 
		{
			super();
			byCmd = XINGMAI_USERCMD;
		}
		
	}

}

///星脉相关指令
/*	struct stXingMaiCmd : public stNullUserCmd
	{
		stXingMaiCmd()
		{
			byCmd = XINGMAI_USERCMD; //10
		}
	};
*/