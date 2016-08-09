package modulecommon.net.msg.guanZhiJingJiCmd 
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	import com.util.UtilTools;
	/**
	 * ...
	 * @author 
	 */
	public class stNotifyGuanZhiNameCmd extends stGuanZhiJingJiCmd
	{
		private var m_guanzhi:String;
		private var m_yinbi:uint;
		private var m_jianghun:uint;
		
		public function stNotifyGuanZhiNameCmd() 
		{
			byParam = NOTIFY_GUANZHI_NAME_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			m_guanzhi = UtilTools.readStr(byte, EnNet.MAX_NAMESIZE);
			m_yinbi = byte.readUnsignedInt();
			m_jianghun = byte.readUnsignedInt();
		}
		
		public function get guanzhi():String
		{
			return m_guanzhi;
		}
		
		public function get yinbi():uint
		{
			return m_yinbi;
		}
		
		public function get jianghun():uint
		{
			return m_jianghun;
		}
	}

}

/*
//发送官职名（领取附件后，上线时，若有官职发送)
    const BYTE NOTIFY_GUANZHI_NAME_USERCMD = 12; 
    struct stNotifyGuanZhiNameCmd : public stGuanZhiJingJiCmd
    {   
        stNotifyGuanZhiNameCmd()
        {   
            byParam = NOTIFY_GUANZHI_NAME_USERCMD;
            bzero(name, MAX_NAMESIZE);
        }   
        char guanzhi[MAX_NAMESIZE];
		DWORD yinbi;
		DWORD jianghun;
    };
*/