package modulecommon.net.msg.worldbossCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stKillReward 
	{
		public var objID:uint;
		public var num:uint;
		
		public function deserialize(byte:ByteArray):void 
		{
			objID = byte.readUnsignedInt();
			num = byte.readUnsignedShort();
		}
		
	}

}
/*	//奖励道具
	struct stKillReward
	{
		DWORD objid;
		WORD num;
	};
*/