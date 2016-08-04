package modulecommon.net.msg.activityCmd 
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 */
	public class notifyWelfareDataCmd extends stActivityCmd 
	{
		public var m_beginTime:Number;
		public var m_endTime:Number;
		public var m_NowTime:Number;
		public var m_welFareList:Dictionary;
		public function notifyWelfareDataCmd() 
		{
			super();
			byParam = NOTIFY_WELFARE_DATA_CMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_welFareList = new Dictionary();
			m_beginTime = byte.readUnsignedInt();
			m_endTime = byte.readUnsignedInt();
			m_NowTime = byte.readUnsignedInt();
			for (var i:uint = 0; i < 2; i++ )
			{
				var welFareItem:Object = new Object();
				welFareItem.m_buyTime = byte.readUnsignedInt();
				welFareItem.m_buyback = byte.readUnsignedByte();
				m_welFareList[i] = welFareItem;
			}
		}
		
	}

}
/*struct WelFare{
        DWORD buyTime;
        //BYTE type; //0:1000元宝投资 , 1:5000元宝投资
        BYTE buyback; //今日是否领取过 为1表示领过
    };  
    //投资福利回购 s->c 上线或活动开启时发送此消息
    const BYTE NOTIFY_WELFARE_DATA_CMD = 15; 
    struct notifyWelfareDataCmd : public stActivityCmd
    {   
        notifyWelfareDataCmd()
        {   
            byParam = NOTIFY_WELFARE_DATA_CMD;
        }   
        DWORD beginTime;
        DWORD endTime;
        WelFare data[2];
    };  */