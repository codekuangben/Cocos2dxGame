package modulecommon.net.msg.questUserCmd 
{
	import common.net.msg.basemsg.stNullUserCmd;
	import common.net.endata.EnNet;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class stQuestUserCmd extends stNullUserCmd 
	{
		public var id:uint;
		public function stQuestUserCmd() 
		{
			super();
			byCmd = TASK_USERCMD;
		}
		
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeUnsignedInt(id);
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			id = byte.readUnsignedInt();
		}
		
	}

}