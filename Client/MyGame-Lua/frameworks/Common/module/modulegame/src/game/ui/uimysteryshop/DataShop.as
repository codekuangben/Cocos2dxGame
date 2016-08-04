package game.ui.uimysteryshop
{
	import modulecommon.commonfuntion.imloader.ModuleResLoader;
	import modulecommon.ui.Form;
	/**
	 * @brief 神秘商店数据
	 */
	public class DataShop
	{
		public var m_mainForm:Form;
		public var m_resLoader:ModuleResLoader;
		
		public function dispose():void
		{
			m_resLoader.unloadRes();
			m_resLoader = null;
		}
	}
}