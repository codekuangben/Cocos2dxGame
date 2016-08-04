package modulecommon.net.msg.eliteBarrierCmd 
{
	/**
	 * 请求进入精英BOSS副本
	 * @author 
	 */
	public class stReqIntoEliteBossCopy extends stEliteBarrierCmd 
	{
		
		public function stReqIntoEliteBossCopy() 
		{
			super();
			byParam = PARA_REQ_INTO_ELITE_BOSS_COPY_CMD;
		}
		
	}

}/*//请求进入精英BOSS副本
    const BYTE PARA_REQ_INTO_ELITE_BOSS_COPY_CMD = 15; 
    struct stReqIntoEliteBossCopy : public stEliteBarrierCmd
    {   
        stReqIntoEliteBossCopy()
        {   
            byParam = PARA_REQ_INTO_ELITE_BOSS_COPY_CMD;
        }   
    };  
*/