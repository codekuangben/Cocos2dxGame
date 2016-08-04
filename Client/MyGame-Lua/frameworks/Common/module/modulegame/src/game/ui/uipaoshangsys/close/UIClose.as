package game.ui.uipaoshangsys.close
{
	import com.bit101.components.ButtonText;
	import com.bit101.components.Component;
	import flash.events.MouseEvent;
	import game.ui.uipaoshangsys.bg.UIBg;
	import game.ui.uipaoshangsys.DataPaoShang;
	import game.ui.uipaoshangsys.goods.UIGoods;
	import game.ui.uipaoshangsys.info.UIInfo;
	import game.ui.uipaoshangsys.start.UIStart;
	import game.ui.uipaoshangsys.title.UITitle;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import com.bit101.components.PushButton;
	
	/**
	 * @brief
	 */
	public class UIClose extends Form
	{
		public var m_DataPaoShang:DataPaoShang;
		protected var m_btnClose:PushButton;
		
		public function UIClose()
		{
			this.id = UIFormID.UIClose;
			this.setSize(160, 68);
		}
		
		override public function onReady():void
		{
			super.onReady();
			m_bCloseOnSwitchMap = false;
			alignVertial = Component.TOP;
			alignHorizontal = Component.RIGHT;
			marginTop = 50;
			marginRight = 50;
			m_btnClose = new PushButton(this, 0, 0, onBtnClose);
			m_btnClose.setSkinButton1Image("commoncontrol/panel/word_leave1.png");
		}
		
		override public function exit():void
		{
			m_DataPaoShang.m_onUIClose(this.id);
			super.exit();
			
			// 关闭其它界面
			var uititle:UITitle = m_DataPaoShang.m_gkcontext.m_UIMgr.getForm(UIFormID.UITitle) as UITitle;
			if (uititle)
			{
				uititle.exit();
			}
			var uistart:UIStart = m_DataPaoShang.m_gkcontext.m_UIMgr.getForm(UIFormID.UIStart) as UIStart;
			if (uistart)
			{
				uistart.exit();
			}
			
			var uigoods:UIGoods = m_DataPaoShang.m_gkcontext.m_UIMgr.getForm(UIFormID.UIGoods) as UIGoods;
			if (uigoods)
			{
				uigoods.exit();
			}
			var uiinfo:UIInfo = m_DataPaoShang.m_gkcontext.m_UIMgr.getForm(UIFormID.UIInfo) as UIInfo;
			if (uiinfo)
			{
				uiinfo.exit();
			}
			
			var uibg:UIBg = m_DataPaoShang.m_gkcontext.m_UIMgr.getForm(UIFormID.UIBg) as UIBg;
			if (uibg)
			{
				uibg.exit();
			}
		}
		
		private function onBtnClose(event:MouseEvent):void
		{
			exit();
		}
	}
}