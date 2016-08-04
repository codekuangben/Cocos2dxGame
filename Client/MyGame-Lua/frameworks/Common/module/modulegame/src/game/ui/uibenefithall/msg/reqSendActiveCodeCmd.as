package game.ui.uibenefithall.msg 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.activityCmd.stActivityCmd;
	import com.util.UtilTools;
	import common.net.endata.EnNet;
	/**
	 * ...
	 * @author 
	 */
	public class reqSendActiveCodeCmd extends stActivityCmd 
	{
		public var code:String;
		public function reqSendActiveCodeCmd() 
		{
			super();
			byParam = REQ_SEND_ACTIVE_CODE_CMD;
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			UtilTools.writeStr(byte, code, EnNet.MAX_NAMESIZE);
		}
	}

}

//客户端发送激活码 c->s
    /*const BYTE REQ_SEND_ACTIVE_CODE_CMD = 13; 
    struct reqSendActiveCodeCmd : public stActivityCmd
    {   
        reqSendActiveCodeCmd()
        {   
            byParam = REQ_SEND_ACTIVE_CODE_CMD;
            bzero(code, MAX_NAMESIZE);
        }   
        char code[MAX_NAMESIZE];
    }; */