package modulecommon.net.msg.equip 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stRetEquipEnchanceColdCmd extends stRemakeEquipCmd
	{
		public var leftsec:uint;
		public var speedcost:uint;
		
		public function stRetEquipEnchanceColdCmd() 
		{
			byParam = RET_EQUIP_ENCHANCE_COLD_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			leftsec = byte.readUnsignedInt();
			speedcost = byte.readUnsignedShort();
		}
	}

}

/*
//装备强化冷却
    const BYTE RET_EQUIP_ENCHANCE_COLD_USERCMD = 10; 
    struct stRetEquipEnchanceColdCmd : public stRemakeEquipCmd
    {   
        stRetEquipEnchanceColdCmd()
        {   
            byParam = RET_EQUIP_ENCHANCE_COLD_USERCMD;
            leftsec = 0;
            speedcost = 0;
        }   
        DWORD leftsec;  //剩余时间秒数
        WORD  speedcost;    //加速花费元宝数
    };  
*/