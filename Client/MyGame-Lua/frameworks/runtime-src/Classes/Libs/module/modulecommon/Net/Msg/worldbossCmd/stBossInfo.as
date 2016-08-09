package modulecommon.net.msg.worldbossCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stBossInfo 
	{
		public var bossid:uint;
		public var killNum:uint;
		public var killreward:stKillReward;
		
		public function stBossInfo()
		{
			killreward = new stKillReward();
		}
		
		public function deserialize(byte:ByteArray):void
		{
			bossid = byte.readUnsignedInt();
			killNum = byte.readUnsignedShort();
			killreward.deserialize(byte);
		}
		
	}

}
/*	//boss信息
	struct stBossInfo
	{
		DWORD bossid;	//bossid
		WORD killnum;	//当前击杀数量
		stKillReward killreward;	//当前击杀奖励
	};
*/