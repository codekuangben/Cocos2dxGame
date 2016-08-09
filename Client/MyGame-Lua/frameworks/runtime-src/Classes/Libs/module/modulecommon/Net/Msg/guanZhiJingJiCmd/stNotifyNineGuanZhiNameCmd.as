package modulecommon.net.msg.guanZhiJingJiCmd 
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	import com.util.UtilTools;
	/**
	 * ...
	 * @author ...
	 */
	public class stNotifyNineGuanZhiNameCmd extends stGuanZhiJingJiCmd
	{
		public var m_tempid:uint;
		public var m_guanzhi:String;
		
		public function stNotifyNineGuanZhiNameCmd() 
		{
			byParam = NOTIFY_NINE_GUANZHI_NAME_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			m_tempid = byte.readUnsignedInt();
			m_guanzhi = UtilTools.readStr(byte, EnNet.MAX_NAMESIZE);
		}
	}

}

/*
//发送官职名（领取附件后，上线时，若有官职发送)
    const BYTE NOTIFY_NINE_GUANZHI_NAME_USERCMD = 16; 
    struct stNotifyNineGuanZhiNameCmd : public stGuanZhiJingJiCmd
    {   
        stNotifyNineGuanZhiNameCmd()
        {   
            byParam = NOTIFY_NINE_GUANZHI_NAME_USERCMD;
            tempid = 0;
            bzero(guanzhi, MAX_NAMESIZE);
        }   
        DWORD tempid;
        char guanzhi[MAX_NAMESIZE];
    };  
*/