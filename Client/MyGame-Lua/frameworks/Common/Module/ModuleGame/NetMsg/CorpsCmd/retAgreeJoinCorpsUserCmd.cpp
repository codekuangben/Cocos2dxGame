package game.netmsg.corpscmd
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.corpscmd.stCorpsCmd;
	import com.util.UtilTools;
	import common.net.endata.EnNet;

	public class retAgreeJoinCorpsUserCmd extends stCorpsCmd
	{
		public var retcode:uint;
		public var name:String;

		public function retAgreeJoinCorpsUserCmd()
		{
			super();
			byParam = stCorpsCmd.RET_AGREE_JOIN_CORPS_USERCMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeByte(retcode);
			UtilTools.writeStr(byte, name, EnNet.MAX_NAMESIZE);
		}
	}
}

//返回请求加入军团 c->s
//const BYTE RET_AGREE_JOIN_CORPS_USERCMD = 52; 
//struct retAgreeJoinCorpsUserCmd : public stCorpsCmd
//{
//	retAgreeJoinCorpsUserCmd()
//	{
//		byParam = RET_AGREE_JOIN_CORPS_USERCMD;
//		retcode = 1;
//		bzero(name, MAX_NAMESIZE);
//	}
//	BYTE retcode; // 1：同意加入 2：拒绝
//	char name[MAX_NAMESIZE]; //邀请者名字
//};