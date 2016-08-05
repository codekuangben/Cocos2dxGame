package modulecommon.net.msg.activityCmd
{
	/**
	 * @author ...
	 */
	public class getVip3PracticeRewardCmd extends stActivityCmd
	{
		public function getVip3PracticeRewardCmd()
		{
			super();
			byParam = stActivityCmd.GET_VIP3_PRACTICE_REWARD_CMD;
		}
	}
}

//请求领取vip体验冲vip3奖励 c<->s
//const BYTE GET_VIP3_PRACTICE_REWARD_CMD = 34;
//struct getVip3PracticeRewardCmd : public stActivityCmd
//{
	//getVip3PracticeRewardCmd()
	//{
		//byParam = GET_VIP3_PRACTICE_REWARD_CMD;
	//}
//};