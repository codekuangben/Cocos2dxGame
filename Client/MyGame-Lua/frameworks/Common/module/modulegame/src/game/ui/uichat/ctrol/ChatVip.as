package game.ui.uichat.ctrol 
{
	import com.bit101.components.Panel;
	import com.riaidea.text.GraphicBase;
	import flash.events.MouseEvent;
	import modulecommon.GkContext;
	import modulecommon.ui.UIFormID;
	
	/**
	 * ...
	 * @author 
	 */
	public class ChatVip extends GraphicBase 
	{
		private var m_gkcontext:GkContext;
		private var m_panel:Panel;
		private var m_id:int;
		public function ChatVip(gk:GkContext, id:int) 
		{
			m_id = id;
			m_gkcontext = gk;
			m_panel = new Panel(this, 0, 1);
			m_panel.setPanelImageSkin("module/vippanel/vip" + id + ".png");
			addEventListener(MouseEvent.CLICK, onClick);
		}
		private function onClick(e:MouseEvent):void
		{
			if (m_gkcontext.m_UIMgr.isFormVisible(UIFormID.UIVipPrivilege))
			{
				m_gkcontext.m_UIMgr.exitForm(UIFormID.UIVipPrivilege);
			}
			else
			{
				m_gkcontext.m_vipPrivilegeMgr.showVipPrivilegeForm();
			}
		}
		override public function get width():Number 
		{
			return 34;
		}
		
		override public function get height():Number 
		{
			return 13;
		}		
		
		override public function get identification():String 
		{
			return ChatRichTextField.s_formatVipPanel(m_id);
		}
		public function dispose():void
		{
			removeEventListener(MouseEvent.CLICK, onClick);
		}
		
	}

}