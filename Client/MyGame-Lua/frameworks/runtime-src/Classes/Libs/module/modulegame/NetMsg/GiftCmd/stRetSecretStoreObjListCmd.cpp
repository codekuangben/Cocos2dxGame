package game.netmsg.giftCmd
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.giftCmd.stGiftCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stRetSecretStoreObjListCmd extends stGiftCmd
	{
		public var objlist:Array;

		public function stRetSecretStoreObjListCmd() 
		{
			super();
			byParam = stGiftCmd.PARA_RET_SECRET_STORE_OBJLIST_CMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			objlist = [];
			var idx:int = 0;
			while (idx < 6)
			{
				objlist[objlist.length] = byte.readUnsignedInt();
				++idx;
			}
		}
	}
}

//const BYTE PARA_RET_SECRET_STORE_OBJLIST_CMD = 26;
//struct stRetSecretStoreObjListCmd : public stGiftCmd
//{
	//stRetSecretStoreObjListCmd()
	//{
		//byParam = PARA_RET_SECRET_STORE_OBJLIST_CMD;
		//bzero(objlist,sizeof(objlist));
	//}
	//DWORD objlist[6];   //万位:标签编号 千百十:物品编号 个位:是否购买
//};