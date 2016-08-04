package game.ui.uiTeamFBSys.msg 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stGainTeamAssistGiftUserCmd extends stCopyUserCmd
	{
		public var giftno:uint;
		public var boxid:uint;

		public function stGainTeamAssistGiftUserCmd() 
		{
			super();
			byParam = stCopyUserCmd.PARA_GAIN_TEAM_ASSIST_GIFT_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			giftno = byte.readUnsignedShort();
			boxid = byte.readUnsignedInt();
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeShort(giftno);
			byte.writeUnsignedInt(boxid);
		}
	}
}

//领取助人礼
//const BYTE PARA_GAIN_TEAM_ASSIST_GIFT_USERCMD = 67;
//struct stGainTeamAssistGiftUserCmd : public stCopyUserCmd
//{
	//stGainTeamAssistGiftUserCmd()
	//{
		//byParam = PARA_GAIN_TEAM_ASSIST_GIFT_USERCMD;
		//giftno = 0;
	//}
	//WORD giftno;    //助人礼编号
	//DWORD boxid;		// 
//};