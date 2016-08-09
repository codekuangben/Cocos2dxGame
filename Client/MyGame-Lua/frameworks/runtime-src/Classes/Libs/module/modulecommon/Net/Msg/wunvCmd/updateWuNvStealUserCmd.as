package modulecommon.net.msg.wunvCmd 
{
	import flash.utils.ByteArray
	import common.net.endata.EnNet;
	/**
	 * ...
	 * @author 
	 */
	public class updateWuNvStealUserCmd extends stWuNvCmd 
	{
		public var m_tempid:uint;
		public var m_name:String;
		public function updateWuNvStealUserCmd() 
		{
			super();
			byParam = UPDATE_WUNV_STEAL_DATA_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_tempid = byte.readUnsignedInt();
			m_name = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
		}
		
	}

}
/*//更新自身舞女被偷信息 s->c
    const BYTE UPDATE_WUNV_STEAL_DATA_USERCMD = 18;
    struct updateWuNvStealUserCmd : public stWuNvCmd
    {                  
        updateWuNvStealUserCmd()
        {              
            byParam = UPDATE_WUNV_STEAL_DATA_USERCMD;
            tempid = 0;
            bzero(name, MAX_NAMESIZE);
        }   
        DWORD tempid; //被偷舞女临时id
        char name[MAX_NAMESIZE]; //偷窃者名子
    };  
*/