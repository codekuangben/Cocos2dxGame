package modulecommon.net.msg.corpscmd 
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.corpscmd.stCorpsCmd;
	/**
	 * ...
	 * @author 
	 */
	public class notifyCorpsNpcIDUserCmd extends stCorpsCmd
	{
		public var npcid:uint;
		public var x:uint;
		public var y:uint;

		public function notifyCorpsNpcIDUserCmd() 
		{
			super();
			byParam = stCorpsCmd.NOTIFY_CORPS_NPC_ID_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			npcid = byte.readUnsignedInt();
			x = byte.readUnsignedShort();
			y = byte.readUnsignedShort();
		}
	}
}

//const BYTE NOTIFY_CORPS_NPC_ID_USERCMD = 80; 
//struct notifyCorpsNpcIDUserCmd : public stCorpsCmd
//{   
//	notifyCorpsNpcIDUserCmd()
//	{   
//		byParam = NOTIFY_CORPS_NPC_ID_USERCMD;
//		npcid = 0;
//		x = y = 0;
//	}   
//	DWORD npcid;
//	WORD x;
//	WORD y;
//};