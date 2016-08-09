package modulecommon.net.msg.corpscmd 
{
	import flash.utils.ByteArray;
	/**
	 * 请求快速复活 c->s s->c
	 * @author 
	 */
	public class quickReliveUserCmd extends stCorpsCmd 
	{
		
		public function quickReliveUserCmd() 
		{
			super();
			byParam = QUICK_RELIVE_USERCMD;
		}
		
		
	}
	

}/*//请求快速复活 c->s s->c
    const BYTE QUICK_RELIVE_USERCMD = 115; 
    struct quickReliveUserCmd : public stCorpsCmd
    {    
        quickReliveUserCmd()
        {    
            byParam = QUICK_RELIVE_USERCMD;
        }    
    };*/