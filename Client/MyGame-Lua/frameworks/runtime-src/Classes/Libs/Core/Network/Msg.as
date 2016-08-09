package network 
{
	/**
	 * ...
	 * @author ...
	 * @brief 基本的消息 
	 */
	public class Msg 
	{
		/**
		 * 
		 * */
		private var m_size:uint;	// 记录消息大小 
		private var m_bResolve:Boolean;	// 记录消息有没有解析 
		 
		/**
		 * 
		 * */
		public function Msg() 
		{
			init();
		}
		
		/**
		 * 
		 * */
		public function init():void
		{
			m_size = 0;
			m_bResolve = false;
		}
		
		/**
		 * 
		 * */
		public function get GetSize():uint
		{
			return m_size;
		}
		
		/**
		 * 
		 * */
		public function set SetSize(size:uint):void 
		{
			m_size = size;
		}
	}
}