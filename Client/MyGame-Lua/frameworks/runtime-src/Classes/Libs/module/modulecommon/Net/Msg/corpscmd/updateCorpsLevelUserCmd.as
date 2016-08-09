package modulecommon.net.msg.corpscmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class updateCorpsLevelUserCmd extends stCorpsCmd 
	{
		public var corpslevel:uint;	//团等级
		public function updateCorpsLevelUserCmd() 
		{
			super();
			byParam = UPDATE_CORPS_LEVEL_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			corpslevel = byte.readUnsignedByte();
		}
	}

}

//军团等级
    /*const BYTE UPDATE_CORPS_LEVEL_USERCMD = 65;
    struct updateCorpsLevelUserCmd : public stCorpsCmd
    {
        updateCorpsLevelUserCmd()
        {
            byParam = UPDATE_CORPS_LEVEL_USERCMD;
            corpslevel = 0;
        }
        BYTE corpslevel;
    };*/
