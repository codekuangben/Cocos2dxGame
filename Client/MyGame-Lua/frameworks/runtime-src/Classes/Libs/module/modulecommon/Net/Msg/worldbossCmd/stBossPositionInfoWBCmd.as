package modulecommon.net.msg.worldbossCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stBossPositionInfoWBCmd extends stWorldBossCmd
	{
		public var m_vecBossPos:Vector.<stBossPosInfo>;
		
		public function stBossPositionInfoWBCmd() 
		{
			byParam = PARA_BOSS_POSITION_INFO_WBCMD;
			m_vecBossPos = new Vector.<stBossPosInfo>();
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			var num:int = byte.readUnsignedShort();
			var posinfo:stBossPosInfo;
			for (var i:int = 0; i < num; i++)
			{
				posinfo = new stBossPosInfo();
				posinfo.deserialize(byte);
				
				m_vecBossPos.push(posinfo);
			}
		}
	}

}
/*
//boss位置信息
    const BYTE PARA_BOSS_POSITION_INFO_WBCMD = 17; 
    struct stBossPositionInfoWBCmd : public stWorldBossCmd
    {   
        stBossPositionInfoWBCmd()
        {   
            byParam = PARA_BOSS_POSITION_INFO_WBCMD;
            num = 0;
        }   
        WORD num;
        stBossPosInfo bosspos[0];
        WORD getSize()
        {
            return (sizeof(*this) + num*sizeof(stBossPosInfo));
        }
    };
*/