package modulecommon.net.msg.shoppingCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.scene.market.stMarketBaseObj;
	/**
	 * ...
	 * @author ...
	 */
	public class stRetCorpsMallObjListCmd extends stShoppingCmd 
	{
		public var m_list:Array;
		public function stRetCorpsMallObjListCmd() 
		{
			super();
			byParam = PARA_RET_CORPSMALL_OBJLIST_CMD;
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

//返回军团商城物品
    /*const BYTE PARA_RET_CORPSMALL_OBJLIST_CMD = 11; 
    struct stRetCorpsMallObjListCmd : public stShoppingCmd
    {
        stRetCorpsMallObjListCmd()
        {
            byParam = PARA_RET_CORPSMALL_OBJLIST_CMD;
            size = 0;
        }
        WORD size;
        stMarketBaseObj objlist[0];
        WORD getSize()
        {
            return (sizeof(*this) + size*sizeof(stMarketBaseObj));
        }
    };*/