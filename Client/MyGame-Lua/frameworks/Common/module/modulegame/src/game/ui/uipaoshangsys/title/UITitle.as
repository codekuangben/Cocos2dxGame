package game.ui.uipaoshangsys.title
{
	import com.bit101.components.Component;
	import game.ui.uipaoshangsys.DataPaoShang;
	import modulecommon.ui.Form;
	//import modulecommon.ui.FormStyleOne;
	import modulecommon.ui.UIFormID;
	import com.bit101.components.Panel;
	import modulecommon.uiinterface.IUIPaoShangSys;
	
	/**
	 * @brief
	 */
	public class UITitle extends Form
	{
		public var m_DataPaoShang:DataPaoShang;
		public var m_pnlBg:Panel;
		
		public function UITitle()
		{
			this.id = UIFormID.UITitle;
			this.setSize(225, 62);
		}
		
		override public function onReady():void 
		{
			super.onReady();
			m_bCloseOnSwitchMap = false;
			alignVertial = Component.TOP;
			//this.setFormSkin("form1", 250);
			//this.title = "日志";
			m_pnlBg = new Panel(this);
			if ((m_DataPaoShang.m_form as IUIPaoShangSys).isResReady())
			{
				initRes();
			}
		}
		
		// 所有资源的初始化，主要是打包的图片的资源
		public function initRes():void
		{
			m_pnlBg.setPanelImageSkinBySWF(m_DataPaoShang.m_form.swfRes, "uipaoshang.paoshang");
		}
		
		override public function exit():void
		{
			m_DataPaoShang.m_onUIClose(this.id);
			super.exit();
		}
	}
}