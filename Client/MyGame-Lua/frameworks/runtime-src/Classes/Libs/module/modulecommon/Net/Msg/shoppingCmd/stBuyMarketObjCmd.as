package modulecommon.net.msg.shoppingCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stBuyMarketObjCmd extends stShoppingCmd 
	{
		public static const MARKETTYPE_GOLD:int = 1;
		public static const MARKETTYPE_HONOR:int = 2;
		public static const MARKETTYPE_CorpsGongxian:int = 3;
		
		public var markettype:uint;
		public var objtype:uint;
		public var objid:uint;
		public var num:uint;
		public function stBuyMarketObjCmd() 
		{
			byParam = PARA_BUY_MARKETOBJ_CMD;
			
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeByte(markettype);
			byte.writeByte(objtype);
			byte.writeUnsignedInt(objid);
			byte.writeShort(num);
		}
		
	}

}
//请求购买商城物品
	/*const BYTE PARA_BUY_MARKETOBJ_CMD = 4;
	struct stBuyMarketObjCmd : public stShoppingCmd
	{
		stBuyMarketObjCmd()
		{
			byParam = PARA_BUY_MARKETOBJ_CMD;
			markettype = objtype = 0;
			objid = 0;
			num = 0;
		}
		BYTE markettype;
		BYTE objtype;	//0-道具 1-热卖 2-宝石 3-特价
		DWORD objid;
		WORD num;
	};
	enum eMarketType
{
    MARKETTYPE_GOLD = 1,    //元宝商城
	MARKETTYPE_HONOR = 2,   //荣誉商城
    MARKETTYPE_MAX,
};

	*/