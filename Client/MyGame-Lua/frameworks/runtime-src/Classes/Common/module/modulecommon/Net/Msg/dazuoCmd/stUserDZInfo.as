package modulecommon.net.msg.dazuoCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stUserDZInfo 
	{
		public var userid:uint;
		public var fuyoutime:uint;
		
		public function stUserDZInfo() 
		{
			userid = 0;
			fuyoutime = 0;
		}
		
		public function deserialize(byte:ByteArray):void
		{
			userid = byte.readUnsignedInt();
			fuyoutime = byte.readUnsignedInt();
		}
	}

}

/*
struct stUserDZInfo
    {   
        DWORD userid;
        DWORD fuyoutime;
        stUserDZInfo
        {   
            userid = fuyoutime = 0;
        }
        stUserDZInfo(const DWORD _userid,const DWORD _fuyoutime):userid(_userid),fuyoutime(_fuyoutime)
        {
        }
    };
*/