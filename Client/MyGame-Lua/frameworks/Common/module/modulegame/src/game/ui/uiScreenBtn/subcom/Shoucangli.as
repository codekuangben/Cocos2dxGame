package game.ui.uiScreenBtn.subcom 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.ui.UIFormID;
	/**
	 * ...
	 * @author ...
	 * 收藏游戏
	 */
	public class Shoucangli extends FunBtnBase 
	{
		public function Shoucangli(parent:DisplayObjectContainer=null) 
		{
			super(ScreenBtnMgr.Btn_Shoucangli, parent);			
		}
		override public function onClick(e:MouseEvent):void 
		{
			if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIShoucangGame)==false)
			{ 
				m_gkContext.m_UIMgr.showFormEx(UIFormID.UIShoucangGame);
			}
			else
			{
				m_gkContext.m_UIMgr.exitForm(UIFormID.UIShoucangGame);
			}
		}
	}

}