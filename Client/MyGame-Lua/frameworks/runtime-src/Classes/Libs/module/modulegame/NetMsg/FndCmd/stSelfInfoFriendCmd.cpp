package game.netmsg.fndcmd
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	import modulecommon.net.msg.fndcmd.stFriendCmd;

	public class stSelfInfoFriendCmd extends stFriendCmd
	{
		public var mood:String;

		public function stSelfInfoFriendCmd()
		{
			super();
			byParam = stFriendCmd.PARA_SELF_INFO_FRIENDCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			mood = byte.readMultiByte(EnNet.MAX_MOODDIARY_LEN, EnNet.UTF8);
		}
	}
}

//自己信息                         
//const BYTE PARA_SELF_INFO_FRIENDCMD = 18;
//struct stSelfInfoFriendCmd : public stFriendCmd
//{
//	stSelfInfoFriendCmd()
//	{
//		byParam = PARA_SELF_INFO_FRIENDCMD;
//		bzero(mood,sizeof(mood));
//	}
//	char mood[MAX_MOODDIARY_LEN];
//};