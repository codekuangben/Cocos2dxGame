package modulecommon.net.msg.dazuoCmd 
{
	import modulecommon.net.msg.propertyUserCmd.stPropertyUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stEndDaZuoPropertyUserCmd extends stPropertyUserCmd
	{
		
		public function stEndDaZuoPropertyUserCmd() 
		{
			byParam = PARA_END_DAZUO_PROPERTY_USERCMD;
		}
		
	}

}

/*
	//结束打坐领取奖励
    const BYTE PARA_END_DAZUO_PROPERTY_USERCMD = 24;
    struct stEndDaZuoPropertyUserCmd : public stPropertyUserCmd
    {
        stEndDaZuoPropertyUserCmd()
        {
            byParam = PARA_END_DAZUO_PROPERTY_USERCMD;
        }
    };
*/