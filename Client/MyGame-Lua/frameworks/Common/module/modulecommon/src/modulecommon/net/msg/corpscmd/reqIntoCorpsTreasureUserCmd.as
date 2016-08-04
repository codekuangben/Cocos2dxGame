package modulecommon.net.msg.corpscmd 
{
	/**
	 * ...
	 * @author 
	 */
	public class reqIntoCorpsTreasureUserCmd extends stCorpsCmd 
	{
		
		public function reqIntoCorpsTreasureUserCmd() 
		{
			super();
			byParam = REQ_INTO_CORPS_TREASURE_USERCMD;
		}
		
	}

}

//请求进入军团夺宝活动 c->s
   /* const BYTE REQ_INTO_CORPS_TREASURE_USERCMD = 110; 
    struct reqIntoCorpsTreasureUserCmd : public stCorpsCmd
    {    
        reqIntoCorpsTreasureUserCmd()
        {    
            byParam = REQ_INTO_CORPS_TREASURE_USERCMD;
        }    
    };   
*/