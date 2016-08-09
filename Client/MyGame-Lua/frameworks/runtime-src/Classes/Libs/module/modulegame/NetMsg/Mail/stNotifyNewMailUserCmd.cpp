package game.netmsg.mail
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.mailCmd.stMailCmd;

	public class stNotifyNewMailUserCmd extends stMailCmd
	{
		public var num:uint;

		public function stNotifyNewMailUserCmd()
		{
			byParam = stMailCmd.NOTIFY_NEW_MAIL_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			num = byte.readUnsignedByte();
		}
	}
}

//s->c通知有新邮件
/*
const BYTE NOTIFY_NEW_MAIL_USERCMD = 8;
struct stNotifyNewMailUserCmd : public stMailCmd
{   
	stNotifyNewMailUserCmd()
	{   
		byParam = NOTIFY_NEW_MAIL_USERCMD;
	}
	BYTE num;
}; 
*/