package app.login.netmsg.loginmsg
{
	import flash.utils.ByteArray;
	import net.loginUserCmd.stLoginUserCmd;
	/**
	 * ...
	 * @author zouzhiqiang
	 * //客户端选择职业 client->server
	 */
	public class stCreateCharUserCmd extends stLoginUserCmd
	{
		public var career:int;
		public var sex:int;
		public var minor:int;
		
		public function stCreateCharUserCmd() 
		{
			byParam = CREATE_CHAR_USERCMD_PARA;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeByte(career);
			byte.writeByte(sex);
			byte.writeByte(minor);
		}
	}
	
	/*
	const BYTE CREATE_CHAR_USERCMD_PARA = 8;
	struct stCreateCharUserCmd : public stLogonUserCmd
	{
		stCreateCharUserCmd()
		{
			byParam = CREATE_CHAR_USERCMD_PARA;
		}
		BYTE career;  
		BYTE sex;       //性别
		BYTE minor;  // 0 :成年人  1： 未成年
	};
	*/

}