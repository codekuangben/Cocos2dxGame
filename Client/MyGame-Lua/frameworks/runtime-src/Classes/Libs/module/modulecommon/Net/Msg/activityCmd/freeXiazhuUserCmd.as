package modulecommon.net.msg.activityCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class freeXiazhuUserCmd extends stActivityCmd
	{
		public var maxFree:uint;
		public var leftFrees:uint;
		
		public function freeXiazhuUserCmd() 
		{
			byParam = FREE_XIAZHU_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			maxFree = byte.readUnsignedByte();
			leftFrees = byte.readUnsignedByte();
		}
	}

}
/*
//免费下注次数
    const BYTE FREE_XIAZHU_USERCMD = 7;
    struct freeXiazhuUserCmd : public stActivityCmd
    {   
        freeXiazhuUserCmd()
        {   
            byParam = FREE_XIAZHU_USERCMD;
            maxFree = leftFree = 0;
        }   
        BYTE maxFree;
        BYTE leftFree;
    }; 
*/