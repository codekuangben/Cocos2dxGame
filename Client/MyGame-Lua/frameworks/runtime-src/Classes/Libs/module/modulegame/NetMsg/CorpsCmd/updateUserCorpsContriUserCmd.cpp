package game.netmsg.corpscmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.corpscmd.stCorpsCmd;
	
	/**
	 * ...
	 * @author 
	 */
	public class updateUserCorpsContriUserCmd extends stCorpsCmd 
	{
		public var contri:uint;
		public function updateUserCorpsContriUserCmd() 
		{
			byParam = UPDATE_USER_CORPS_CONTRI_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			contri = byte.readUnsignedInt();
		}
	}

}

//更新个人团贡献 s->c
    /*const BYTE UPDATE_USER_CORPS_CONTRI_USERCMD = 37; 
    struct updateUserCorpsContriUserCmd : public stCorpsCmd
    {   
        updateUserCorpsContriUserCmd()
        {   
            byParam = UPDATE_USER_CORPS_CONTRI_USERCMD;
            contri = 0;
        }   
        DWORD contri;
    }; */ 