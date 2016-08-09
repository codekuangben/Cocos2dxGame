package modulecommon.net.msg.trialTowerCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stNotifyUserStateCmd extends stTrialTowerCmd 
	{
		public var state:int;	//数据类型
		public function stNotifyUserStateCmd() 
		{
			byParam = NOTIFY_USER_STATE_PARA;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			state = byte.readUnsignedByte();
		}
	}

}

/*
enum eUserState
	{
		STATE_NORMAL = 0;	//正常状态
		STATE_DIE = 1;		//死亡状态
	};
	///通知玩家状态
	const BYTE NOTIFY_USER_STATE_PARA = 8;
	struct stNotifyUserStateCmd : public
	{
		stNotifyUserStateCmd()
		{
			byParam = NOTIFY_USER_STATE_PARA;
		}
		BYTE state;
	};
	*/