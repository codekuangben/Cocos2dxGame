package modulecommon.net.msg.rankcmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class st7DayRechargeRankListCmd extends stRankCmd 
	{
		public var m_dataList:Array;
		public function st7DayRechargeRankListCmd() 
		{
			super();
			byParam = stRankCmd.PARA_7DAY_RECHARGE_RANK_LIST_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_dataList = new Array();
			var num:uint;
			num = byte.readUnsignedShort();
			var item:stRechargeRankItem;
			for (var i:uint = 1; i <= num; i++)
			{
				item = new stRechargeRankItem();
				item.deserialize(byte);
				item.m_index = i;
				m_dataList.push(item);
			}
			
		}
	}

}
/*//7日充值榜信息
    const BYTE PARA_7DAY_RECHARGE_RANK_LIST_USERCMD = 6;
    struct st7DayRechargeRankListCmd : public stRankCmd
    {
        st7DayRechargeRankListCmd()
        {
            byParam = PARA_7DAY_RECHARGE_RANK_LIST_USERCMD;
            num = 0;
        }
        WORD num;
        stRechargeRankItem list[0];
        WORD getSize()
        {
            return (sizeof(*this) + num*sizeof(stRechargeRankItem));
        }
    };*/