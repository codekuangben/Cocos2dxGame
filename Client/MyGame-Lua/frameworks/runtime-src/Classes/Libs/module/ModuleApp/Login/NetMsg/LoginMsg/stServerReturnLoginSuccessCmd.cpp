package app.login.netmsg.loginmsg
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import login.UserID;
	
	import common.net.endata.EnNet;
	import net.loginUserCmd.stLoginUserCmd;

	/**
	 * ...
	 * @author 
	 * /// 登陆成功，返回网关服务器地址端口以及密钥等信息
	const BYTE SERVER_RETURN_LOGIN_OK = 5;
	struct stServerReturnLoginSuccessCmd : public stLogonUserCmd 
	{
		stServerReturnLoginSuccessCmd()
		{
			byParam = SERVER_RETURN_LOGIN_OK;
		}

		DWORD accid;
		DWORD loginTempID;
		char pstrIP[MAX_IP_LENGTH];
		WORD wdPort;
		char key[256];	// 58 下标处指定 key 的起始索引， key 总共 8 个  key[key[58]] -- key[key[58]]
		char uid[MAX_UID_LEN]; //#define MAX_UID_LEN 80
	};
	 */
	public class stServerReturnLoginSuccessCmd extends stLoginUserCmd 
	{
		public var accid:uint;
		public var loginTempID:uint;
		public var pstrIP:String;
		public var wdPort:int;
		public var key:ByteArray;
		//public var buff:ByteArray;	// 测试加解密字段的内容
		public var m_userID:UserID;
		
		public function stServerReturnLoginSuccessCmd() 
		{
			byParam = SERVER_RETURN_LOGIN_OK;
			super();
		}
		
		override public function deserialize (byte:ByteArray) : void
		{
			super.deserialize(byte);
			accid = byte.readUnsignedInt();
			loginTempID = byte.readUnsignedInt();
			
			pstrIP = byte.readMultiByte(EnNet.MAX_IP_LENGTH, EnNet.UTF8);
			wdPort = byte.readShort();
			//return;
			// 计算  key 值
			var tmp:ByteArray = new ByteArray();
			tmp.endian = Endian.LITTLE_ENDIAN;
			byte.readBytes(tmp, 0, 256);
			tmp.position = 58;
			tmp.position = tmp.readUnsignedByte();
			key = new ByteArray();
			key.endian = Endian.LITTLE_ENDIAN;
			tmp.readBytes(key, 0, 8);
			
			key.position = 0;
			
			m_userID = new UserID();
			m_userID.deserialize(byte);
			
			//var idx:int = 0;
			//while(idx < key.length)
			//{
			//	trace(key.readUnsignedByte());
			//	++idx;
			//}
			
			//buff = new ByteArray();
			//buff.endian = Endian.LITTLE_ENDIAN;
			//byte.readBytes(buff, 0, 8);
		}
	}
}