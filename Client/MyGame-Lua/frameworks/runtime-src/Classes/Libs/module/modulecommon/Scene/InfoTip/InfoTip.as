package modulecommon.scene.infotip
{
	/**
	 * @ 信息提示时候的对象
	 * */
	public class InfoTip
	{
		public static const ENbeiatt:uint = 0;	// 被攻击
		public static const ENfriend:uint = 1;	// 加好友
		public static const ENmail:uint = 2;		// 邮件
		public static const ENzhufu:uint = 3;		// 祝福
		public static const ENShenqingCorps:uint = 4;		// 有人申请加入团
		public static const ENPrivChat:uint = 5; 			// 私聊
		public static const ENCorpsAttLst:uint = 6; 		// 军团城市争夺战被击列表
		public static const ENBNotify:uint = 7; 		// 战报-被抢夺宝物 – 被抢分为被抢成功和没成功
		
		public var m_type:uint;		// 类型
		public var m_num:uint;			// 数量
		public var m_bshowEff:Boolean;	// 是否显示特效
	}
}