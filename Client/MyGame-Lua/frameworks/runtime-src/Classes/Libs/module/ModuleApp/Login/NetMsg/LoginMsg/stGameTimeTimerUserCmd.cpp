package app.login.netmsg.loginmsg
{
	import flash.utils.ByteArray;
	import net.timemsg.stTimerUserCmd;
	
	/**
	 * ...
	 * @author 
	 */
	// 网关向用户发送游戏时间
	public class  stGameTimeTimerUserCmd  extends stTimerUserCmd 
	{
		public function stGameTimeTimerUserCmd()
		{
			super();
			byParam = GAMETIME_TIMER_USERCMD_PARA;
		}
		
		override public function deserialize (byte:ByteArray) : void
		{
			super.deserialize(byte);
			qwGameTime = byte.readUnsignedInt();
			openservertime = byte.readUnsignedInt();
		}

		public var qwGameTime : Number;
		public var openservertime : Number;
	}
}

/// 网关向用户发送游戏时间
   /* const BYTE GAMETIME_TIMER_USERCMD_PARA = 1;
    struct stGameTimeTimerUserCmd : public stTimerUserCmd 
    {   
        stGameTimeTimerUserCmd()
        {   
            byParam = GAMETIME_TIMER_USERCMD_PARA;
            qwGameTime = 0;
        }   

        DWORD qwGameTime;      /**< 游戏时间 
        DWORD openservertime;   //开服时间
    };  */