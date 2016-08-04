package game.ui.collectProgress 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.stResRobCmd.stResRobCmd;
	
	/**
	 * ...
	 * @author ...
	 */
	public class notifyBeginPlayProgressUserCmd extends stResRobCmd 
	{
		public static const PROCESS_RESROB:int = 0;
		public static const PROCESS_CORPSTREASURE:int = 1;
		public var m_type:int;
		public function notifyBeginPlayProgressUserCmd() 
		{
			super();
			byParam = NOTIFY_BEGIN_PLAY_PROGRESS_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_type = byte.readUnsignedByte();
		}
	}

}

//通知客户端开始播进度条 s->c
	/*const BYTE NOTIFY_BEGIN_PLAY_PROGRESS_USERCMD = 8;
	struct notifyBeginPlayProgressUserCmd : public stResRobCmd
	{
		notifyBeginPlayProgressUserCmd()
		{
			byParam = NOTIFY_BEGIN_PLAY_PROGRESS_USERCMD;
		}
		BYTE type;
	};*/