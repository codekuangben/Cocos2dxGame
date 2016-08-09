package modulecommon.net.msg.stResRobCmd 
{
	/**
	 * ...
	 * @author ...
	 */
	public class reqFinishFightUserCmd extends stResRobCmd 
	{
		
		public function reqFinishFightUserCmd() 
		{
			super();
			byParam = REQ_FINISH_FIGHT_USERCMD;
		}
		
	}

}

//战斗结束 c->s
    /*const BYTE REQ_FINISH_FIGHT_USERCMD = 12; 
    struct reqFinishFightUserCmd : public stResRobCmd
    {   
        reqFinishFightUserCmd()
        {   
            byParam = REQ_FINISH_FIGHT_USERCMD;
        }   
    };  
*/