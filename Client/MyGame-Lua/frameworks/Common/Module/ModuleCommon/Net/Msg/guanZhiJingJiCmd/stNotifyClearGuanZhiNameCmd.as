package modulecommon.net.msg.guanZhiJingJiCmd 
{
	/**
	 * ...
	 * @author 
	 */
	public class stNotifyClearGuanZhiNameCmd extends stGuanZhiJingJiCmd
	{
		
		public function stNotifyClearGuanZhiNameCmd() 
		{
			byParam = NOTIFY_CLEAR_GUANZHI_NAME_USERCMD;
		}
		
	}

}

/*
    //清除官职名
    const BYTE NOTIFY_CLEAR_GUANZHI_NAME_USERCMD = 13; 
    struct stNotifyClearGuanZhiNameCmd : public stGuanZhiJingJiCmd
    {   
        stNotifyClearGuanZhiNameCmd()
        {   
            byParam = NOTIFY_CLEAR_GUANZHI_NAME_USERCMD;
        }   
    };  
*/