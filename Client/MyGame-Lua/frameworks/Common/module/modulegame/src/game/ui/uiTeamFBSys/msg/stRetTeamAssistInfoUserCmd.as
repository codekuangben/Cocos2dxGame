package game.ui.uiTeamFBSys.msg 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stRetTeamAssistInfoUserCmd extends stCopyUserCmd
	{
		public var assistv:uint;
		public var gainflag:uint;
		public var boxid:uint;
		
		public function stRetTeamAssistInfoUserCmd() 
		{
			super();
			byParam = stCopyUserCmd.PARA_RET_TEAM_ASSIST_INFO_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			assistv = byte.readUnsignedInt();
			gainflag = byte.readUnsignedInt();
			boxid = byte.readUnsignedInt();
		}
	}
}

//const BYTE PARA_RET_TEAM_ASSIST_INFO_USERCMD = 66; 
//struct stRetTeamAssistInfoUserCmd : public stCopyUserCmd
//{   
	//stRetTeamAssistInfoUserCmd()
	//{   
		//byParam = PARA_RET_TEAM_ASSIST_INFO_USERCMD;
		//assistv = gainflag = 0;
	//}
	//DWORD assistv;  //助人值
	//DWORD gainflag; //奖励领取标记
	//DWORD boxid;	// 宝箱的 id，用于显示提示
//};