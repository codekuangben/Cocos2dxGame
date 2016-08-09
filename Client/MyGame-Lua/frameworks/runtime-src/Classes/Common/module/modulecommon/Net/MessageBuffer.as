package modulecommon.net 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	public class MessageBuffer 
	{
		private var m_bIsInBufferState:Boolean;
		private var m_quene:Array;
		
		public function MessageBuffer() 
		{
			
		}
		public function push(msg:ByteArray, param:int = 0):void
		{
			if (m_bIsInBufferState == false)
			{
				return;
			}
						
			var item:Item = new Item();
			item.msg = msg;
			item.param = param;
			m_quene.push(item);
		}
		
		public function pushTwoParam(msg:ByteArray, cmd:int, param:int = 0):void
		{
			if (m_bIsInBufferState == false)
			{
				return;
			}
						
			var item:Item = new Item();
			item.msg = msg;
			item.cmd = cmd;
			item.param = param;
			m_quene.push(item);
		}
		
		public function executeTwoParam(fun:Function):void
		{
			if (!m_quene)
			{
				return;
			}
			var index:int = 0;
			var item:Item;
			for (index = 0; index < m_quene.length; index++)
			{
				item = m_quene[index];
				item.msg.position = 0;
				fun(item.msg, item.cmd, item.param);
			}
			m_quene.length = 0;			
		}
		
		public function execute(fun:Function):void
		{
			var index:int = 0;
			var item:Item;
			for (index = 0; index < m_quene.length; index++)
			{
				item = m_quene[index];
				item.msg.position = 0;
				fun(item.msg, item.param);
			}
			m_quene.length = 0;
		}
		
		public function get isInBufferState():Boolean
		{
			return m_bIsInBufferState;
		}
		
		public function set isInBufferState(bBuffer:Boolean):void
		{
			if (m_bIsInBufferState == bBuffer)
			{
				return;
			}
			m_bIsInBufferState = bBuffer;
			if (m_bIsInBufferState == true)
			{
				m_quene = new Array();
			}			
		}
	}
}