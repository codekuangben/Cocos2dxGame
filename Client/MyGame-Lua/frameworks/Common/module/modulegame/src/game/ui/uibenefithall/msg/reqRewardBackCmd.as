package game.ui.uibenefithall.msg
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.activityCmd.stActivityCmd;
	/**
	 * @brief
	 */
	public class reqRewardBackCmd extends stActivityCmd
	{
		public var type:uint;
		public var gtype:uint;
		
		public function reqRewardBackCmd()
		{
			super();
			byParam = stActivityCmd.REQ_REWARD_BACK_CMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeByte(type);
			byte.writeByte(gtype);
		}
	}
}

//请求领取奖励找回 c->s //返回29号消息
//const BYTE REQ_REWARD_BACK_CMD = 30;
//struct reqRewardBackCmd : public stActivityCmd
//{
	//reqRewardBackCmd()
	//{
		//byParam = REQ_REWARD_BACK_CMD;
		//type = gtype = 0;
	//}
	//BYTE type; //0:免费 1：元宝
	//BYTE gtype; //功能类型
//};