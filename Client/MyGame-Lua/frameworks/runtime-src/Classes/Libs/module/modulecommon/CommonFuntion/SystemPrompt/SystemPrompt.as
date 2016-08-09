package modulecommon.commonfuntion.systemprompt 
{
	import datast.reuse.MgrForReuse;
	import flash.geom.Point;
	
	import modulecommon.GkContext;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIAnnouncement;
	//import com.util.UtilColor;
	/**
	 * ...
	 * @author 
	 */
	public class SystemPrompt 
	{
		public var m_gkContext:GkContext;
		private var m_mgrForReuse:MgrForReuse;
		
		private var m_annUI:IUIAnnouncement;
		public function SystemPrompt(gk:GkContext) 
		{
			m_gkContext = gk;
			m_mgrForReuse = new MgrForReuse();
			m_mgrForReuse.setParam(createMsgCtrl2, 3);
		}
		
		private function createMsgCtrl2():MsgCtrl2
		{
			var ret:MsgCtrl2 = new MsgCtrl2(m_gkContext);
			return ret;
		}
	
		public function promptOnTopOfMousePos(str:String, color:uint = 0xE0972E, direct:int = 0):void
		{
			var pos:Point = new Point(m_gkContext.m_UIMgr.mouseX, m_gkContext.m_UIMgr.mouseY-120);
			prompt(str,pos,color,direct);
		}
		//direct��ʾ�����ƶ�����: 0-����  1-����
		public function prompt(str:String, pos:Point = null, color:uint = 0xE0972E, direct:int = 0):void
		{
			var format:MsgCtrl2_format = new MsgCtrl2_format();
			format.direct = direct;
			format.m_msg = str;
			format.m_color = color;
			if (pos == null)
			{
				format.m_pos = new Point(m_gkContext.m_context.m_config.m_curWidth/ 2, m_gkContext.m_context.m_config.m_curHeight / 2 - 50);
			}
			else
			{
				format.m_pos = pos;
			}
			
			var msgCtrl:MsgCtrl2 = m_mgrForReuse.allocate() as MsgCtrl2;
			msgCtrl.begin(format);		
		}	
		
		// 这个是错误提示
		public function promptError(str:String, pos:Point = null, color:uint = 0xff0000, direct:int = 0):void
		{
			prompt(str, pos, color, direct);
			// 播放音效
			m_gkContext.m_commonProc.playMsc(2);
		}
		
		public function announce(str:String):void
		{
			if (m_annUI == null)
			{
				m_annUI = m_gkContext.m_UIMgr.createFormInGame(UIFormID.UIAnnouncement)as IUIAnnouncement;
			}
			m_annUI.add(str);
		}
	}

}