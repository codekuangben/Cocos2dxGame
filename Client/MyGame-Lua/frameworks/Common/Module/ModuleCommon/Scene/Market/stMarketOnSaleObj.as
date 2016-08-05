package modulecommon.scene.market 
{
	/**
	 * ...
	 * @author ...
	 */
	import flash.utils.ByteArray;
	public class stMarketOnSaleObj extends stMarketBaseObj 
	{
		public var starttime:uint;
		public var endtime:uint;
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			starttime = byte.readUnsignedInt();
			endtime = byte.readUnsignedInt();
		}
		
	}

}

//特价商品
	/*struct stMarketOnSaleObj : public stMarketBaseObj
	{
		DWORD starttime;
		DWORD endtime;
		stMarketOnSaleObj()
		{
			starttime = endtime = 0;
		}
	};*/