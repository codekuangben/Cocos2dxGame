package modulecommon.net.msg.corpscmd 
{
	/**
	 * ...
	 * @author ...
	 */
	public class reqBeginCorpsFireUserCmd extends stCorpsCmd
	{
		
		public function reqBeginCorpsFireUserCmd() 
		{
			byParam = REQ_BEGIN_CORPS_FIRE_USERCMD;
		}
		
	}

}
/*
//请求开启军团烤火
    const BYTE REQ_BEGIN_CORPS_FIRE_USERCMD = 63;
    struct reqBeginCorpsFireUserCmd : public stCorpsCmd
    {    
        reqBeginCorpsFireUserCmd()
        {    
            byParam = REQ_BEGIN_CORPS_FIRE_USERCMD;
        }    
    };  
*/