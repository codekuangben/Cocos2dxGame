package modulecommon.net.msg.worldbossCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stBossPosInfo 
	{
		public var bossId:uint;
		public var x:int;
		public var y:int;
		
		public function stBossPosInfo() 
		{
			bossId = 0;
			x = 0;
			y = 0;
		}
		
		public function deserialize(byte:ByteArray):void
		{
			bossId = byte.readUnsignedInt();
			x = byte.readUnsignedShort();
			y = byte.readUnsignedShort();
		}
	}

}
/*
//boss位置信息
    struct stBossPosInfo
    {   
        DWORD bossid;
        WORD x;
        WORD y;
        stBossPosInfo()
        {   
            bossid = 0;
            x = y = 0;
        }   
    };  
*/