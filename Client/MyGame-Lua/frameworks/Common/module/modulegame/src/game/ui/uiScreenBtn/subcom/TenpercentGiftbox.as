package game.ui.uiScreenBtn.subcom 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.ui.UIFormID;
	/**
	 * ...
	 * @author ...
	 * 一折大礼包
	 */
	public class TenpercentGiftbox extends FunBtnBase
	{
		
		public function TenpercentGiftbox(parent:DisplayObjectContainer = null) 
		{
			super(ScreenBtnMgr.Btn_TenpercentGiftbox, parent);
		}
		
		override public function onClick(e:MouseEvent):void 
		{
			super.onClick(e);
			
			if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIYizhelibao)==false)
			{ 
				m_gkContext.m_UIMgr.showFormEx(UIFormID.UIYizhelibao);
			}
			else
			{
				m_gkContext.m_UIMgr.exitForm(UIFormID.UIYizhelibao);
			}
		}
	}

}