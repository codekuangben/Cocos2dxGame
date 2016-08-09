package app.login.netmsg.loginmsg 
{
	import flash.utils.ByteArray;
	import net.loginUserCmd.stLoginUserCmd;
	
	/**
	 * ...
	 * @author ...
	 */
	public class synLandZoneUserCmd extends stLoginUserCmd 
	{
		public var zoneid_houduan:uint;
		public var plattype:uint;
		public var number:uint;
		public function synLandZoneUserCmd() 
		{
			super();
			byParam = SYN_LAND_ZONE_PARA;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			zoneid_houduan = byte.readUnsignedShort();
			plattype = byte.readUnsignedByte();
			number = byte.readUnsignedInt();
		}
		
	}

}

// 通知客户端登陆其他区
    /*const BYTE SYN_LAND_ZONE_PARA = 10;
    struct synLandZoneUserCmd  : public stLogonUserCmd
    {
        synLandZoneUserCmd()
        {
            byParam = SYN_LAND_ZONE_PARA;
            zoneid = 0;
            plattype = 0;
            number = 0;
        }
        WORD zoneid; //区id
        BYTE plattype; //平台类型
        DWORD number;
    };*/
