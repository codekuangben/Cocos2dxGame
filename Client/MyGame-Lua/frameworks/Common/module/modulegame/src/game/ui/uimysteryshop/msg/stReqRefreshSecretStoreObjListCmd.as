package game.ui.uimysteryshop.msg
{
	import modulecommon.net.msg.giftCmd.stGiftCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stReqRefreshSecretStoreObjListCmd extends stGiftCmd
	{
		public function stReqRefreshSecretStoreObjListCmd() 
		{
			super();
			byParam = stGiftCmd.PARA_REQ_REFRESH_SECRET_STORE_OBJLIST_CMD;
		}	
	}
}

//请求刷新神秘商店物品
//const BYTE PARA_REQ_REFRESH_SECRET_STORE_OBJLIST_CMD = 28; 
//struct stReqRefreshSecretStoreObjListCmd : public stGiftCmd
//{   
	//stReqRefreshSecretStoreObjListCmd()
	//{   
		//byParam = PARA_REQ_REFRESH_SECRET_STORE_OBJLIST_CMD;
	//}   
//};