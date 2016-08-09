package modulecommon.net.msg.giftCmd
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stBuySecretStoreObjCmd extends stGiftCmd
	{
		public var objno:uint;

		public function stBuySecretStoreObjCmd()
		{
			super();
			byParam = stGiftCmd.PARA_BUY_SECRET_STORE_OBJ_CMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			objno = byte.readUnsignedInt();
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeUnsignedInt(objno);
		}
	}
}

//const BYTE PARA_BUY_SECRET_STORE_OBJ_CMD = 27; 
//struct stBuySecretStoreObjCmd : public stGiftCmd
//{   
	//stBuySecretStoreObjCmd()
	//{   
		//byParam = PARA_BUY_SECRET_STORE_OBJ_CMD;
		//objno = 0;
	//}   
	//DWORD objno;
//};