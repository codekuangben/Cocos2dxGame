package modulecommon.net.msg.worldbossCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stNotifyBossInfoWBCmd extends stWorldBossCmd
	{
		public var m_bossList:Array;
		
		public function stNotifyBossInfoWBCmd() 
		{
			byParam = PARA_NOTIFY_BOSS_INFO_WBCMD;
			
			m_bossList = new Array();
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			var num:int = byte.readUnsignedShort();
			var i:int;
			var itemboss:stBossInfo;
			
			for (i = 0; i < num; i++)
			{
				itemboss = new stBossInfo();
				itemboss.deserialize(byte);
				
				m_bossList.push(itemboss);
			}
		}
	}

}
/*
	//通知boss信息
	const BYTE PARA_NOTIFY_BOSS_INFO_WBCMD = 5;
	struct stNotifyBossInfoWBCmd : public stWorldBossCmd
	{
		stNotifyBossInfoWBCmd()
		{
			byParam = PARA_NOTIFY_BOSS_INFO_WBCMD;
			num = 0;
		}
		WORD num;
		stBossInfo boss[0];
		WORD getSize()
		{
			return (sizeof(*this) + num*sizeof(stBossInfo));
		}
	};
*/