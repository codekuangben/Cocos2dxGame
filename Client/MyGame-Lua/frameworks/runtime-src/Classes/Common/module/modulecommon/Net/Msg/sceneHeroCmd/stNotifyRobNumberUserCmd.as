package modulecommon.net.msg.sceneHeroCmd
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.sceneHeroCmd.stSceneHeroCmd;

	public class stNotifyRobNumberUserCmd extends stSceneHeroCmd
	{
		public var count:uint;

		public function stNotifyRobNumberUserCmd()
		{
			super();
			byParam = stSceneHeroCmd.NOTIFY_ROB_NUMBER_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			count = byte.readUnsignedByte();
		}
	}
}

//抢夺宝物后给予被抢方战斗回放提示
//const BYTE NOTIFY_ROB_NUMBER_USERCMD = 36;
//struct stNotifyRobNumberUserCmd : public stSceneHeroCmd
//{
//	stNotifyRobNumberUserCmd()
//	{
//		byParam = NOTIFY_ROB_NUMBER_USERCMD;
//	}
//	BYTE count;	//：抢夺战斗次数
//};