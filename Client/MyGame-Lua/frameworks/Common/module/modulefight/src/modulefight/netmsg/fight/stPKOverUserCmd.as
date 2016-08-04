package modulefight.netmsg.fight
{
	import modulecommon.net.msg.fight.stScenePkCmd;
	import modulefight.FightEn;
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	
	public class stPKOverUserCmd extends stScenePkCmd
	{
		public var questid:uint;
		public var target:String;
		public var offset:uint;
		
		public function stPKOverUserCmd()
		{
			super();
			byParam = PARA_PK_OVER_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			questid = byte.readUnsignedInt();
			target = byte.readMultiByte(16, EnNet.UTF8);
			offset = byte.readUnsignedByte();
		}
	}
}



//PK结束给客户端发送要执行的任务分支(客户端pk动画完后请求任务分支)
//const BYTE PARA_PK_OVER_USERCMD = 5;
//struct stPKOverUserCmd : public stScenePkCmd
//{   
//	stPKOverUserCmd()
//	{   
//		byParam = PARA_PK_OVER_USERCMD;
//	}   
//	DWORD questid;
//	char target[16];
//	BYTE offset;
//};