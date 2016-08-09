package modulecommon.commonfuntion.systempromt_bottom 
{
	/**
	 * ...
	 * @author 
	 */
	import modulecommon.GkContext;
	public class SystemPrompt_Bottom 
	{
		private var m_gkContext:GkContext;
		private var m_MsgCtrlList:Vector.<MsgCtrol_Bottom>;
		private var m_msgList:Vector.<String>;
		
		private const m_cInterval:int = 95;
		public function SystemPrompt_Bottom(gk:GkContext) 
		{
			m_gkContext = gk;
			m_MsgCtrlList = new Vector.<MsgCtrol_Bottom>();
			m_msgList = new Vector.<String>();
		}
		public function addMsg(msg:String):void
		{
			if (m_MsgCtrlList.length > 0)
			{
				var ctrl:MsgCtrol_Bottom = m_MsgCtrlList[m_MsgCtrlList.length - 1];
				if (ctrl.isState_fadeIn)
				{
					m_msgList.push(msg);
					return;
				}
			}
			addMsgToCtrl(msg);
		}
		private function addMsgToCtrl(msg:String):void
		{
			var ctrl:MsgCtrol_Bottom = new MsgCtrol_Bottom(m_gkContext,this);
			addjustAllPos(m_cInterval);
			m_MsgCtrlList.push(ctrl);
			ctrl.y = standardY + 50;
			ctrl.begin(msg);
		}
		
		public function onFadeInEnd(ctr:MsgCtrol_Bottom):void
		{
			if (m_msgList.length > 0)
			{
				addMsgToCtrl(m_msgList.pop());
			}
		}
		
		public function onFadeOutEnd(ctrl:MsgCtrol_Bottom):void
		{
			var i:int = m_MsgCtrlList.indexOf(ctrl);
			if(i!=-1)
			{
				m_MsgCtrlList.splice(i, 1);
			}
			ctrl.dispose();
		}
		private function addjustAllPos(baseY:int=0):void
		{
			var i:int = m_MsgCtrlList.length - 1;
			var top:int = standardY - baseY;
			for (; i >= 0; i--)
			{
				m_MsgCtrlList[i].y = top;
				top -= m_cInterval;
			}
			
		}
		public function get standardY():int
		{
			return m_gkContext.m_context.m_config.m_showHeight  - 300;
		}
	}

}