package game.ui.collectProgress 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.stResRobCmd.stResRobCmd;
	
	/**
	 * ...
	 * @author ...
	 */
	public class reqEndPlayProgressUserCmd extends stResRobCmd 
	{
		public var m_type:int;
		public function reqEndPlayProgressUserCmd() 
		{
			super();
			byParam = REQ_END_PLAY_PROGRESS_USERCMD;
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeByte(m_type);
		}
	}

}

//客户端请播放进度条完成 c->s
	/*const BYTE REQ_END_PLAY_PROGRESS_USERCMD = 9;
	struct reqEndPlayProgressUserCmd : public stResRobCmd
	{
		reqEndPlayProgressUserCmd()
		{
			byParam = REQ_END_PLAY_PROGRESS_USERCMD;
		}
		BYTE type
	};*/