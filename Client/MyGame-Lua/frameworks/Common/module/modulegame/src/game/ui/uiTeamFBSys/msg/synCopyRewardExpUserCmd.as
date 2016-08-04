package game.ui.uiTeamFBSys.msg
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;

	public class synCopyRewardExpUserCmd extends stCopyUserCmd
	{
		public var exp:uint;
		public function synCopyRewardExpUserCmd()
		{
			super();
			byParam = stCopyUserCmd.SYN_COPY_REWARD_EXP_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			exp = byte.readUnsignedInt();
		}
	}
}

//同步副本经验奖励信息 s->c 
//const BYTE SYN_COPY_REWARD_EXP_USERCMD = 58; 
//struct synCopyRewardExpUserCmd : public stCopyUserCmd
//{   
//	synCopyRewardExpUserCmd()
//	{   
//		byParam = SYN_COPY_REWARD_EXP_USERCMD;
//		exp = 0;
//	}   
//	DWORD exp;
//};