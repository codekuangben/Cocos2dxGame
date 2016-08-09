package game.netmsg.sceneUserCmd
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class practiceVipTimeUserCmd extends stSceneUserCmd
	{
		public var time:uint;

		public function practiceVipTimeUserCmd() 
		{
			super();
			byParam = SceneUserParam.PRACTICE_VIP_TIME_USERCMD_PARA;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			time = byte.readUnsignedInt();
		}
	}
}

//同步剩余vip体验时间
//const BYTE PRACTICE_VIP_TIME_USERCMD_PARA = 78;
//struct practiceVipTimeUserCmd : public stSceneUserCmd
//{
	//practiceVipTimeUserCmd()
	//{
		//byParam = PRACTICE_VIP_TIME_USERCMD_PARA;
		//time = 0;
	//}
	//DWORD time; //0:表示vip体验倒计时结束 3600*2+1 表示玩家还没有体验vip
//};