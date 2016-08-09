package modulecommon.commonfuntion.systemprompt 
{
	import modulecommon.GkContext;
	
	/**
	 * ...
	 * @author 
	 */
	public class SystemPromptMulti 
	{
		private var m_gkContext:GkContext;
		private var m_MsgCtrlList:Vector.<MsgCtrl>;
		private var m_msgList:Vector.<MsgCtrl_format>;
		
		private const m_cInterval:int = 35;
		
		public function SystemPromptMulti(gk:GkContext)
		{
			m_gkContext = gk;
			m_MsgCtrlList = new Vector.<MsgCtrl>();
			m_msgList = new Vector.<MsgCtrl_format>();
		}
		
		public function addMsg(msg:String):void
		{
			var format:MsgCtrl_format = new MsgCtrl_format();
			format.m_msg = msg;
			format.m_color = 0xE0972E;
			
			if (m_MsgCtrlList.length > 0)
			{
				var ctrl:MsgCtrl = m_MsgCtrlList[m_MsgCtrlList.length - 1];
				if (ctrl.isState_fadeIn)
				{
					m_msgList.push(format);
					return;
				}
			}
			addMsgToCtrl(format);
		}
		private function addMsgToCtrl(format:MsgCtrl_format):void
		{
			var ctrl:MsgCtrl = new MsgCtrl(m_gkContext,this, format);			
			addjustAllPos(m_cInterval);		
			m_MsgCtrlList.push(ctrl);
			ctrl.y = standardY + 50;
			ctrl.begin();			
		}
		
		public function onFadeInEnd(ctr:MsgCtrl):void
		{
			if (m_msgList.length > 0)
			{
				addMsgToCtrl(m_msgList.pop());
			}
		}
		
		public function onFadeOutEnd(ctrl:MsgCtrl):void
		{
			var i:int = m_MsgCtrlList.indexOf(ctrl);
			if(i!=-1)
			{
				m_MsgCtrlList.splice(i, 1);
			}
			ctrl.dispose();
		}
		
		/*
		 * 判断在(baseY, byaseY-m_cInterval)之间有没有MsgCtrl对象，如果有，则将该对象的高度减m_cInterval，然后再递归调用addjustAllPos。
		 */
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
			return m_gkContext.m_context.m_config.m_showHeight / 2 - 220;
		}
	}

}