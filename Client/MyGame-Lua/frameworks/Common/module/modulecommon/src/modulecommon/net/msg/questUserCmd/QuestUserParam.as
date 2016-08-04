package modulecommon.net.msg.questUserCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class QuestUserParam 
	{		
		public static const QUEST_INFO_PARA:uint = 1;
		public static const QUEST_VARS_PARA:uint = 2;
		public static const REQUEST_QUEST_PARA:uint = 3;
		public static const ABANDON_QUEST_PARA:uint = 4;
		public static const SYN_QUEST_DATA_FIN_PARA:uint = 5;
		
		public static const REQ_OPEN_XUAN_SHANG_QUEST_PARA:uint = 6;		//请求打开悬赏任务界面
		public static const RET_OPEN_XUAN_SHANG_QUEST_PARA:uint = 7;		//返回数(打开悬赏界面后)
		public static const REQ_CLOSE_XUAN_SHANG_QUEST_PARA:uint = 8;		//请求关闭悬赏任务界面
		public static const REQ_REFRESH_XUAN_SHANG_QUEST_PARA:uint = 9;		//请求立即刷新
		public static const RET_REFRESH_XUAN_SHANG_QUEST_PARA:uint = 10;	//返回刷新的QuestItem
		public static const REQ_GET_XUAN_SHANG_QUEST_PARA:uint = 11;		//请求领取一个任务
		public static const RET_GET_XUAN_SHANG_QUEST_PARA:uint = 12;		//返回已接任务次数
		public static const REQ_ABANDON_XUAN_SHANG_QUEST_PARA:uint = 13;	//请求取消悬赏任务
		public static const REFRESH_XUAN_SHANG_QUEST_STATE_PARA:uint = 14;	//返回刷新某条的按钮状态(领任务后，或者条件满足后)
		public static const DIRECT_FINISH_QUEST_PARA:uint = 15;				//请求直接完成
		public static const REQ_XUAN_SHANG_QUEST_REWARD_PARA:uint = 16;		//请求领取奖励
		public static const NOTIFY_CYCLE_QUEST_NUM_PARA:uint = 17;		//循环任务次数
	}

}