package modulecommon.net.msg.worldbossCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stNotifyActStateWBCmd extends stWorldBossCmd
	{
		public var m_state:uint;
		
		public function stNotifyActStateWBCmd() 
		{
			byParam = PARA_NOTIFY_ACT_STATE_WBCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			m_state = byte.readUnsignedByte();
		}
	}

}
/*
	//通知活动状态
	const BYTE PARA_NOTIFY_ACT_STATE_WBCMD = 1;
	struct stNotifyActStateWBCmd : public stWorldBossCmd
	{
		stNotifyActStateWBCmd()
		{
			byParam = PARA_NOTIFY_ACT_STATE_WBCMD;
			state = 0;
		}
		BYTE state;	
	};
	
	//活动状态
	enum eActState
	{
		ACTSTATE_NONE = 0,
		ACTSTATE_PRE = 1,	//等待(活动即将开始，倒计时...)
		ACTSTATE_START = 2, //活动开始
		ACTSTATE_TIMER = 3, //活动中
		ACTSTATE_END   = 4, //活动结束
	};

*/