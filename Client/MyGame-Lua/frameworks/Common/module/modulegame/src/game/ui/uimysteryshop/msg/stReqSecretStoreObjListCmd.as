package game.ui.uimysteryshop.msg
{
	import modulecommon.net.msg.giftCmd.stGiftCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stReqSecretStoreObjListCmd extends stGiftCmd
	{	
		public function stReqSecretStoreObjListCmd() 
		{
			super();
			byParam = stGiftCmd.PARA_REQ_SECRET_STORE_OBJLIST_CMD;
		}
	}
}

//请求神秘商店物品
//const BYTE PARA_REQ_SECRET_STORE_OBJLIST_CMD = 25;
//struct stReqSecretStoreObjListCmd : public stGiftCmd
//{
	//stReqSecretStoreObjListCmd()
	//{
		//byParam = PARA_REQ_SECRET_STORE_OBJLIST_CMD;
	//}
//};