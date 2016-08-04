package modulecommon.net.msg.shoppingCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.scene.market.stMarketBaseObj;
	/**
	 * ...
	 * @author ...
	 */
	public class stRetHonorMallDataCmd extends stShoppingCmd 
	{
		public var m_list:Array;
		public function stRetHonorMallDataCmd() 
		{
			super();
			byParam = PARA_RET_HONORMALL_DATA_CMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			var size:int = byte.readUnsignedShort();
			var marketItem:stMarketBaseObj;
			m_list = new Array();
			var i:int;
			for (i = 0; i < size; i++)
			{
				marketItem = new stMarketBaseObj();				
				marketItem.deserialize(byte);				
				m_list.push(marketItem);
			}
		}
		
	}

}

//返回荣誉商城数据
    /*const BYTE PARA_RET_HONORMALL_DATA_CMD = 9;
    struct stRetHonorMallDataCmd : public stShoppingCmd
    {   
        stRetHonorMallDataCmd()
        {   
            byParam = PARA_RET_HONORMALL_DATA_CMD;
            size = 0;
        }   
        WORD size;
        stMarketBaseObj objlist[0];
        WORD getSize()
        {   
            return (sizeof(*this) + size*sizeof(stMarketBaseObj));
        }   
    };*/  