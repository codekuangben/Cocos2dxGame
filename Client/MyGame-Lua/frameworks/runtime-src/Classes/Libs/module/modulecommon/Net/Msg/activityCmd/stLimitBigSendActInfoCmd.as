package modulecommon.net.msg.activityCmd 
{
	import adobe.utils.ProductManager;
	import flash.utils.ByteArray
	/**
	 * ...
	 * @author 
	 */
	public class stLimitBigSendActInfoCmd extends stActivityCmd 
	{
		public var m_starttime:Number;
		public var m_endtime:Number;
		public var m_delay:Number;
		public var m_list:Array;
		public function stLimitBigSendActInfoCmd() 
		{
			super();
			byParam = PARA_LIMIT_BIG_SEND_ACTINFO_CMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_list = new Array();
			m_starttime = byte.readUnsignedInt();
			m_endtime = byte.readUnsignedInt();
			m_delay = byte.readUnsignedInt();
			var num:uint = byte.readUnsignedShort();
			for (var i:int = 0; i < num; i++ )
			{
				var item:stLimitBigSendItem = new stLimitBigSendItem();
				item.deserialize(byte);
				m_list.push(item);
			}
		}
		
	}

}
/*	//限时大放送活动信息
    const BYTE PARA_LIMIT_BIG_SEND_ACTINFO_CMD = 8;
    struct stLimitBigSendActInfoCmd : public stActivityCmd
    {
        stLimitBigSendActInfoCmd()
        {
            byParam = PARA_LIMIT_BIG_SEND_ACTINFO_CMD;
            starttime = endtime = delay = 0;
            num = 0;
        }   
        DWORD starttime;             
        DWORD endtime;
        DWORD delay;
        WORD num;
        stLimitBigSendItem list[0];
        WORD getSize()
        {   
            return (sizeof(*this) + num*sizeof(stLimitBigSendItem));
        }   

    };*/