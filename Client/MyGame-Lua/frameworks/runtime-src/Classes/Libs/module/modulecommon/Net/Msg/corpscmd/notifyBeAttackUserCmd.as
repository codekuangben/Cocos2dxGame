package modulecommon.net.msg.corpscmd
{
	import modulecommon.net.msg.corpscmd.stCorpsCmd;
	import flash.utils.ByteArray;

	public class notifyBeAttackUserCmd extends stCorpsCmd
	{
		public var size:uint;

		public function notifyBeAttackUserCmd()
		{
			super();
			byParam = stCorpsCmd.NOTIFY_BE_ATTACK_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			size = byte.readUnsignedByte();
		}
	}
}

//防守者受到攻击时收到此消息
//const BYTE NOTIFY_BE_ATTACK_USERCMD = 88;
//struct notifyBeAttackUserCmd : public stCorpsCmd
//{
//	notifyBeAttackUserCmd()
//	{
//		byParam = NOTIFY_BE_ATTACK_USERCMD;
//	}
//	BYTE size;  //被攻击了几次（每次被攻击都有回看）
//};