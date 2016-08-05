package datast 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 * 队列实现(用数组结构实现队列)
	 * 
	 */
	
	 
	 
	public class QueueVec 
	{
		private var m_vec:Vector.<Object>;
		private var m_bufferSize:uint;
		private var m_capacity:uint; //所能放下的最大数据数量，一旦被设置，该值
		private var m_size:uint;	//当前的数据数量
		private var m_head:int;	//指向队头元素
		private var m_tail:int; //指向队尾元素的下个位置
		public function QueueVec(capacity:uint) 
		{
			m_vec = new Vector.<Object>(capacity +1);
			m_bufferSize = capacity +1;
			m_capacity = capacity;
			m_head = 0;
			m_tail = 0;
			m_size = 0;
		}
		public function push(obj:Object):void
		{
			if (m_capacity == m_size)
			{
				pop();				
			}
			m_vec[m_tail] = obj;
			m_tail = (m_tail + 1) % m_bufferSize;
			m_size++;
		}
		public function pop():Object
		{
			if (m_size == 0)
			{
				return null;
			}
			var obj:Object = m_vec[m_head];
			m_head = (m_head + 1) % m_bufferSize;
			m_size --;
			return obj;
		}
		public function get size():uint
		{
			return m_size;
		}		
		
		public function get isFull():Boolean
		{
			return (m_capacity == m_size);
		}
		
		public function get isEmpty():Boolean
		{
			return (m_size == 0);
		}
		//用索引的方式访问队列内的元素, 对头元素的索引是0, 最后一个元素的
		public function getData(index:uint):Object
		{
			if (index < m_size)
			{
				return m_vec[(index + m_head)%m_bufferSize];
			}
			return null;
		}
		
	}

}