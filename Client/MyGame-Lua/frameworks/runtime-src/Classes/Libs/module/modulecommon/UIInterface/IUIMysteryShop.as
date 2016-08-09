package modulecommon.uiinterface
{
	
	/**
	 * @brief 神秘商店
	 */
	public interface IUIMysteryShop
	{
		function psstRetSecretStoreObjListCmd():void;
		function updateUI():void;
		function isResReady():Boolean;
	}
}