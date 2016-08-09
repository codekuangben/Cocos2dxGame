package modulecommon.net.msg.corpscmd 
{
	import flash.utils.ByteArray;
	
	import common.net.endata.EnNet;
	import com.util.UtilTools;
	/**
	 * ...
	 * @author 
	 */
	public class notifyCorpsNameUserCmd extends stCorpsCmd 
	{
		public var corpsid:uint;
		public var name:String;
		public var priv:uint;
		public var cishu:uint;
		public var reg:uint;
		public var corpslevel:uint;
		public var contr:uint;

		public function notifyCorpsNameUserCmd() 
		{
			byParam = NOTIFY_CORPS_NAME_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			corpsid = byte.readUnsignedInt();
			name = UtilTools.readStr(byte, EnNet.MAX_NAMESIZE);
			priv = byte.readUnsignedByte();
			cishu = byte.readUnsignedByte();
			reg = byte.readUnsignedByte();
			corpslevel = byte.readUnsignedByte();
			contr = byte.readUnsignedInt();
		}
	}

}

//通知军团名称 s->c
//const BYTE NOTIFY_CORPS_NAME_USERCMD = 10;
//struct notifyCorpsNameUserCmd : public stCorpsCmd
//{
//	notifyCorpsNameUserCmd()
//	{
//		byParam = NOTIFY_CORPS_NAME_USERCMD;
//		corpsid = 0;
//		bzero(name, MAX_NAMESIZE);
//		priv = 0;
//		cishu = 0;
//		lotterytimes = 0;
//		reg = 0;
//	}
//	DWORD corpsid;
//	char name[MAX_NAMESIZE];
//	BYTE priv;
//	BYTE cishu;
//	BYTE reg; // 0:没有报名 1:已报名军团争霸战
//	BYTE corpslevel; //军团等级
//	DWORD contr; //贡献
//};