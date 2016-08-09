package game.netmsg.giftCmd
{
	import modulecommon.net.msg.giftCmd.stGiftCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stNotifyRefreshSecretStoreObjListCmd extends stGiftCmd
	{	
		public function stNotifyRefreshSecretStoreObjListCmd() 
		{
			super();
			byParam = stGiftCmd.PARA_NOTIFY_REFRESH_SECRET_STORE_OBJLIST_CMD;
		}
	}
}

//通知刷新神秘商店物品
//const BYTE PARA_NOTIFY_REFRESH_SECRET_STORE_OBJLIST_CMD = 24; 
//struct stNotifyRefreshSecretStoreObjListCmd : public stGiftCmd
//{   
	//stNotifyRefreshSecretStoreObjListCmd()
	//{   
		//byParam = PARA_NOTIFY_REFRESH_SECRET_STORE_OBJLIST_CMD;
	//}   
//};