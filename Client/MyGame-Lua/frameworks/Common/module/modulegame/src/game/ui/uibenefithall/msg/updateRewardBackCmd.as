package game.ui.uibenefithall.msg
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.activityCmd.stActivityCmd;
	
	/**
	 * @brief
	 */
	public class updateRewardBackCmd extends stActivityCmd
	{
		public var size:uint;
		public var data:Array;
		
		public function updateRewardBackCmd()
		{
			super();
			byParam = stActivityCmd.UPDATE_REWARD_BACK_CMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			size = byte.readUnsignedByte();
			
			data = [];
			var item:RewardBackItem;
			var idx:uint;
			while (idx < size)
			{
				item = new RewardBackItem();
				item.deserialize(byte);
				data[data.length] = item;
				
				++idx;
			}
		}
	}
}

//奖励找回上线信息 s->c
//const BYTE UPDATE_REWARD_BACK_CMD = 29;
//struct updateRewardBackCmd : public stActivityCmd
//{
	//updateRewardBackCmd()
	//{
		//byParam = UPDATE_REWARD_BACK_CMD;
		//size = 0;
	//}
	//BYTE size;
	//RewardBackItem data[0];
//};