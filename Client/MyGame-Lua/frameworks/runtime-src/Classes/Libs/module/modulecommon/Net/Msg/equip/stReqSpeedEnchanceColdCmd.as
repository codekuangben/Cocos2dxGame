package modulecommon.net.msg.equip 
{
	import modulecommon.net.msg.equip.stRemakeEquipCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stReqSpeedEnchanceColdCmd extends stRemakeEquipCmd
	{
		
		public function stReqSpeedEnchanceColdCmd() 
		{
			byParam = REQ_SPEED_ENCHANCE_COLD_USERCMD;
		}
		
	}

}

/*
//请求加速冷却
    const BYTE REQ_SPEED_ENCHANCE_COLD_USERCMD = 11; 
    struct stReqSpeedEnchanceColdCmd : public stRemakeEquipCmd
    {   
        stReqSpeedEnchanceColdCmd()
        {   
            byParam = REQ_SPEED_ENCHANCE_COLD_USERCMD;
        }   
    };
*/