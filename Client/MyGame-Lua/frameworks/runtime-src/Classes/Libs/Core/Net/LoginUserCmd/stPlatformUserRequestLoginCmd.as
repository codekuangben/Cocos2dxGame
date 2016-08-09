package net.loginUserCmd 
{
	import flash.utils.ByteArray;
	import com.util.UtilTools;
	/**
	 * ...
	 * @author ...
	 */
	public class stPlatformUserRequestLoginCmd extends stLoginUserCmd 
	{
		public var ticket:String;
		public var subType:String;
		public var plattype:int;
		public var zone:int;
		public function stPlatformUserRequestLoginCmd() 
		{
			super();
			byParam = PLATFORM_USER_REQUEST_LOGIN_PARA;
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			UtilTools.writeStr(byte, ticket, 128);
			UtilTools.writeStr(byte, subType, 20);
			byte.writeShort(plattype);
			byte.writeShort(zone);
		}
		
	}

}

/// 客户端请求登陆登陆服务器
    /*const BYTE PLATFORM_USER_REQUEST_LOGIN_PARA = 11; 
    struct stPlatformUserRequestLoginCmd : public stLogonUserCmd
    {   
        stPlatformUserRequestLoginCmd()
        {   
            byParam = PLATFORM_USER_REQUEST_LOGIN_PARA;
            bzero(ticket, MAX_TICKET_LEN);
            bzero(subType, MAX_SPID_LEN);
            plattype = zone = 0;
        }   
        char ticket[MAX_TICKET_LEN]; //128
        char subType[MAX_SPID_LEN]; //20 
        WORD plattype;
        WORD zone;
    };  */
