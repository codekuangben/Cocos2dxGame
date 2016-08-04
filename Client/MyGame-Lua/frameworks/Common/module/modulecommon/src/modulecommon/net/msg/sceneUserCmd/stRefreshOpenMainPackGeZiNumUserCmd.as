package modulecommon.net.msg.sceneUserCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.propertyUserCmd.stPropertyUserCmd;
	
	/**
	 * ...
	 * @author 
	 */
	public class stRefreshOpenMainPackGeZiNumUserCmd extends stPropertyUserCmd 
	{
		public var packageOpendSize1:int;
		public var packageOpendSize2:int;
		public var packageOpendSize3:int;
		public function stRefreshOpenMainPackGeZiNumUserCmd() 
		{
			byParam = REFRESH_OPEN_MAINPACK_GEZI_NUM_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			packageOpendSize1 = byte.readUnsignedByte();
			packageOpendSize2 = byte.readUnsignedByte();
			packageOpendSize3 = byte.readUnsignedByte();
		}
		
	}

}

//更新开启主包裹的格子数
    /*const BYTE REFRESH_OPEN_MAINPACK_GEZI_NUM_USERCMD = 15; 
    struct stRefreshOpenMainPackGeZiNumUserCmd : public stPropertyUserCmd
    {   
        stRefreshOpenMainPackGeZiNumUserCmd()
        {   
            byParam = REFRESH_OPEN_MAINPACK_GEZI_NUM_USERCMD;
        }
        BYTE opennum[3];
    };*/
