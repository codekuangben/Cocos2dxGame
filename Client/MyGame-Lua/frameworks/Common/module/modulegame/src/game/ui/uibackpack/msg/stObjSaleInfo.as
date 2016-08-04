package game.ui.uibackpack.msg 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	public class stObjSaleInfo 
	{
		public var thisid:uint;
		public var num:uint;
		public function serialize(byte:ByteArray):void 
		{
			byte.writeUnsignedInt(thisid);
			byte.writeShort(num);
		}
	}

}

/*struct stObjSaleInfo
    {   
        DWORD thisid;
        WORD  num;
        stObjSaleInfo()
        {   
            thisid = 0;
            num = 0;
        }   
    }; */