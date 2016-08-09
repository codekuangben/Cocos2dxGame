package modulecommon.scene.radar 
{
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.GkContext;
	import modulecommon.net.msg.copyUserCmd.stReqLeaveCopyUserCmd;
	import modulecommon.net.msg.mailCmd.stReqMailListCmd;
	import modulecommon.net.msg.sceneHeroCmd.reqDetailRobInfoUserCmd;
	/**
	 * ...
	 * @author ...
	 * 雷达界面功能
	 */
	public class RadarMgr 
	{
		public static const RADARBTN_System:int = 0;	//系统设置
		public static const RADARBTN_Fight:int = 1;		//战报
		public static const RADARBTN_Mail:int = 2;		//邮件
		public static const RADARBTN_Talk:int = 3;		//论坛
		public static const RADARBTN_Friend:int = 4;	//好友
		public static const RADARBTN_Ranks:int = 5;		//排名信息
		public static const RADARBTN_Count:int = 6;
		
		private var m_gkContext:GkContext;
		
		public function RadarMgr(gk:GkContext) 
		{
			m_gkContext = gk;
		}
		
		// 请求邮件消息
		public function reqMail():void
		{
			var reqMail:stReqMailListCmd = new stReqMailListCmd();
			m_gkContext.sendMsg(reqMail);
		}
		
		//请求战报信息
		public function reqDetailRobInfo():void
		{
			var cmd:reqDetailRobInfoUserCmd = new reqDetailRobInfoUserCmd();
			m_gkContext.sendMsg(cmd);
		}
		
		//退出副本
		public function reqLeaveCopy():void
		{
			var cmd:stReqLeaveCopyUserCmd = new stReqLeaveCopyUserCmd();
			m_gkContext.sendMsg(cmd);
		}
		
		//根据功能type获得功能按钮id
		public static function getBtnId(type:uint):int
		{
			var id:int = -1;
			
			switch(type)
			{
				case SysNewFeatures.NFT_FRIENDSYS:
					id = RADARBTN_Friend;
					break;
				case SysNewFeatures.NFT_RANK:
					id = RADARBTN_Ranks;
					break;
			}
			
			return id;
		}
	}

}