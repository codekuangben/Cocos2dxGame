package modulecommon.net.msg.shoppingCmd 
{

	import flash.utils.ByteArray;
	import modulecommon.scene.market.stBuyLimitObjInfo;
	/**
	 * ...
	 * @author 
	 */
	public class stRetObjBuyLimitNumCmd extends stShoppingCmd 
	{
		public var list:Vector.<stBuyLimitObjInfo>
		public function stRetObjBuyLimitNumCmd() 
		{
			byParam = PARA_RET_OBJ_BUYLIMITNUM_CMD;			
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			
			var size:uint = byte.readUnsignedShort();
			if (size)
			{
				list = new Vector.<stBuyLimitObjInfo>();
				var i:int;
				var item:stBuyLimitObjInfo;
				for (i = 0; i < size; i++)
				{
					item = new stBuyLimitObjInfo();
					item.deserialize(byte);
					list.push(item);
				}
			}
		}
		
	}

}

//返回已购买限购物品的数量
   /* const BYTE PARA_RET_OBJ_BUYLIMITNUM_CMD = 6;
    struct stRetObjBuyLimitNumCmd : public stShoppingCmd
    {
        stRetObjBuyLimitNumCmd()
        {
            byParam = PARA_RET_OBJ_BUYLIMITNUM_CMD;
            num = 0;
        }
        WORD num;
        stBuyLimitObjInfo list[0];
        WORD getSize()
        {
            return (sizeof(*this) + num*sizeof(stBuyLimitObjInfo));
        }
    };*/
