package modulecommon.scene.market 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	public class stBuyLimitObjInfo 
	{
		
		public var objid:uint;
		public var buynum:uint;
		public function deserialize(byte:ByteArray):void 
		{
			objid = byte.readUnsignedInt();
			buynum = byte.readUnsignedShort();
		}
	}

}
//限购物品信息
    /*struct stBuyLimitObjInfo
    {   
        DWORD objid;
        WORD buynum;    //已购买数据
        stBuyLimitObjInfo()
        {   
            objid = 0;
            buynum = 0;
        }
    };*/