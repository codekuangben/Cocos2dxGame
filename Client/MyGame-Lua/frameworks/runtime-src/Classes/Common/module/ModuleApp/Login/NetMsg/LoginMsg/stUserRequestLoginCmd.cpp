package app.login.netmsg.loginmsg
{
	import flash.utils.ByteArray;
	import login.UserID;
	import net.loginUserCmd.stLoginUserCmd;
	//import com.util.UtilTools;
	/**
	 * ...
	 * @author 
	 */
	/*
	  /// 客户端请求登陆登陆服务器
    const BYTE USER_REQUEST_LOGIN_PARA = 3;
    struct stUserRequestLoginCmd : public stLogonUserCmd
    {   
        stUserRequestLoginCmd()
        {   
            byParam = USER_REQUEST_LOGIN_PARA;
            platformid = 0;
            zoneid = char_zoneid = 0;
            platformType = char_platformType = 0;
        }   
        char uid[MAX_UID_LEN];               //平台唯一id,网站平台唯一标识一个玩家身份的id
        WORD zoneid;                //玩家要进入的游戏区id
        BYTE platformType;         //平台类型 eg: 91wan.com/31wan.com
        WORD char_zoneid;           //玩家原区区id
        BYTE char_platformType;         //平台类型 eg: 91wan.com/31wan.com
        DWORD number; //跨服需要填写， 由服务器告诉的
    }; 

	 */	
	public class stUserRequestLoginCmd extends stLoginUserCmd
	{
		public var m_userID:UserID;
		public var zoneid:int = 10;	//玩家选择的游戏区id
		public var platformType:int = 0;  //平台类型 eg: 91wan.com/31wan.com	
		public var char_zoneid: int = 0;           //玩家原区区id
		public var char_platformType: int = 0;           //玩家原区区id
		public var number:uint;
			
		
		public function stUserRequestLoginCmd()
		{
			byParam = USER_REQUEST_LOGIN_PARA;
		}
		
		override public function serialize (byte:ByteArray) : void
		{
			super.serialize(byte);
			m_userID.serialize(byte);			
			byte.writeShort(zoneid);	
			byte.writeByte(platformType);
			byte.writeShort(char_zoneid);
			byte.writeByte(char_platformType);
			byte.writeUnsignedInt(number);
			
		}
	}
}