package game.netmsg.corpscmd
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.corpscmd.stCorpsCmd;
	import common.net.endata.EnNet;
	import com.util.UtilTools;
	public class retCreateCorpsUserCmd extends stCorpsCmd
	{
		public var name:String;
		public var corpsid:uint;
		public var ret:uint;
		
		public function retCreateCorpsUserCmd()
		{
			super();
			byParam = stCorpsCmd.RET_CREATE_CORPS_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			name=UtilTools.readStr(byte, EnNet.MAX_NAMESIZE);
			corpsid = byte.readUnsignedInt();
			ret = byte.readUnsignedByte();
		}
	}
}

//返回创建军团 s->c
//const BYTE RET_CREATE_CORPS_USERCMD = 4;
//struct retCreateCorpsUserCmd : public stCorpsCmd
//{
//	retCreateCorpsUserCmd()
//	{
//		byParam = RET_CREATE_CORPS_USERCMD;
//		//bzero(name, MAX_NAMESIZE);
//		ret = 0;
//		corpsid = 0;
//	}
//	//char name[MAX_NAMESIZE]; //军团名
//	DWORD corpsid; 
//	BYTE ret;  //成功 :1 , 失败 :0 , 名字重复 :2
//};