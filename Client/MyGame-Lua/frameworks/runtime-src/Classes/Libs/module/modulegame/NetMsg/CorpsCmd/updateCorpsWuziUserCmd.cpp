package game.netmsg.corpscmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.corpscmd.stCorpsCmd;
	
	/**
	 * ...
	 * @author 
	 */
	public class updateCorpsWuziUserCmd extends stCorpsCmd 
	{
		public var wuzi:uint;
		public function updateCorpsWuziUserCmd() 
		{
			byParam = UPDATE_CORPS_WUZI_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			wuzi = byte.readUnsignedInt();
		}
	}

}

//更新军团物资 s->c
    /*const BYTE UPDATE_CORPS_WUZI_USERCMD = 36; 
    struct updateCorpsWuziUserCmd : public stCorpsCmd
    {   
        updateCorpsWuziUserCmd()
        {   
            byParam = UPDATE_CORPS_WUZI_USERCMD;
            wuzi = 0;
        }   
        DWORD wuzi;
    };  */