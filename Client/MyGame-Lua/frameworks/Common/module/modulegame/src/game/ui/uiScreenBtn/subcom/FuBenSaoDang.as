package game.ui.uiScreenBtn.subcom
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import modulecommon.scene.saodang.SaodangMgr;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import com.util.UtilTools;
	import modulecommon.ui.UIFormID;
	
	import game.ui.uiScreenBtn.UIScreenBtn;
	
	
	
	/**
	 * ...
	 * @author panqiangqiang  20130725
	 */
	public class FuBenSaoDang extends FunBtnBase
	{
	
		private var m_TimeLable:Label;
		
		public function FuBenSaoDang(parent:DisplayObjectContainer=null)
		{
			super(ScreenBtnMgr.Btn_SaoDang, parent);
			
			m_TimeLable	= new Label(this, 38, 73, "00:00:00");
			m_TimeLable.align = Component.CENTER;
		}
		override public function onClick(e:MouseEvent):void 
		{
			var form:uint = 0;
			if(SaodangMgr._REWARD == m_gkContext.m_saodangMgr.state)
			{
				form = UIFormID.UISaoDangReward;
			}
			else if(SaodangMgr._ING == m_gkContext.m_saodangMgr.state)
			{
				form = UIFormID.UISaoDangIngInfo;
			}
			if(0 != form)
			{
				if (m_gkContext.m_UIMgr.isFormVisible(form) == true)
				{
					m_gkContext.m_UIMgr.exitForm(form);
				}
				else
				{
					m_gkContext.m_UIMgr.showFormEx(form);
				}
			}
		}
		override public function initData(fileName:String):void
		{
			super.initData(fileName);
			
		}
		public function updateTimeLabel(time:uint):void
		{
			m_TimeLable.text = UtilTools.formatTimeToString(time);
		}
	}
}