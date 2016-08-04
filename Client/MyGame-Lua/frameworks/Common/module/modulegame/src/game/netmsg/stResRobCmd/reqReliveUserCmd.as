package game.netmsg.stResRobCmd 
{
	import modulecommon.net.msg.stResRobCmd.stResRobCmd;
	
	/**
	 * ...
	 * @author ...
	 */
	public class reqReliveUserCmd extends stResRobCmd 
	{
		
		public function reqReliveUserCmd() 
		{
			super();
			byParam = REQ_RELIVE_USERCMD;
		}
		
	}

}

//客户端请求复活 c->s
    /*const BYTE REQ_RELIVE_USERCMD = 10; 
    struct reqReliveUserCmd : public stResRobCmd
    {   
        reqReliveUserCmd()
        {   
            byParam = REQ_RELIVE_USERCMD;
        }   
    }; */