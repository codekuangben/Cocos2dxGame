package modulecommon.net.msg.corpscmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class reqQuickCoolDownCorpsUserCmd extends stCorpsCmd 
	{
		public var type:uint;
		public function reqQuickCoolDownCorpsUserCmd() 
		{
			byParam = REQ_QUICK_COOL_DOWN_CORPS_USERCMD;
			
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeByte(type);
		}
		
	}

}

//请求快速冷却
    /*const BYTE REQ_QUICK_COOL_DOWN_CORPS_USERCMD = 62;
    struct reqQuickCoolDownCorpsUserCmd : public stCorpsCmd
    {
        reqQuickCoolDownCorpsUserCmd()
        {
            byParam = REQ_QUICK_COOL_DOWN_CORPS_USERCMD;
            type = 0;
        }
        BYTE type; // 0:主基地  1：科技
    };*/