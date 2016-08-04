package game.ui.uiScreenBtn.subcom
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import com.util.UtilTools;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	/**
	 * @brief VIP 体验
	 */
	public class VipTiYan extends FunBtnBase
	{
		private var m_TimeLable:Label;
		
		public function VipTiYan(parent:DisplayObjectContainer=null) 
		{
			super(ScreenBtnMgr.Btn_VipTiYan, parent);
			
			m_TimeLable	= new Label(this, 38, 73, "00:00:00");
			m_TimeLable.align = Component.CENTER;
			m_TimeLable.visible = false;
		}
		
		override public function onClick(e:MouseEvent):void 
		{
			super.onClick(e);
			
			if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIVipTiYan))
			{
				m_gkContext.m_UIMgr.exitForm(UIFormID.UIVipTiYan);
			}
			else
			{
				var form:Form = m_gkContext.m_UIMgr.createFormInGame(UIFormID.UIVipTiYan);
				if (form)
				{
					form.show();
				}
			}		
		}
		
		public function updateTimeLabel(time:uint):void
		{
			if (time > 0)
			{
				// 如果不可见
				if (m_TimeLable.visible == false)
				{
					m_TimeLable.visible = true;
				}
				m_TimeLable.text = UtilTools.formatTimeToString(time);
			}
			else
			{
				m_TimeLable.visible = false;
			}
		}
	}
}