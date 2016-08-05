package modulecommon.net.msg.sgQunYingCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stNotifyCrossServerIsReadyCmd extends stSGQunYingCmd 
	{
		public var m_bCrossserverReady:Boolean;
		public function stNotifyCrossServerIsReadyCmd() 
		{
			super();			
		}
		
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_bCrossserverReady = byte.readBoolean();
		}		
	}

}

//跨服服务器准备状态, 在synOnlineFinDataUserCmd之后收到
	/*const BYTE PARA_NOTIFY_CROSS_SERVER_ISREADY_CMD = 1;
	struct stNotifyCrossServerIsReadyCmd : public stSGQunYingCmd
	{
		stNotifyCrossServerIsReadyCmd()
		{
			byParam = PARA_NOTIFY_CROSS_SERVER_ISREADY_CMD;
			ready = 0;
		}
		BYTE ready;	//1:准备OK
	};*/