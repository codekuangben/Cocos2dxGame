package datast 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Queue implements IQueue
	{
		/**
		 * 
		 * */
		private var _head:LinkedNode;
		private var _tail:LinkedNode;
		private var _size:uint;
		
		/**
		 * 
		 * */
		public function Queue() 
		{
			init();
		}
	
		/**
		 * 
		 * */
		private function init():void
		{
			_head = _tail = null;
			_size = 0;
		}
		
		/**
		 * 
		 * */
		public function IsEmpty():Boolean
		{
			return (_size == 0);
		}
		
		/**
		 * 
		 * */
		public function enqueue(obj:*):Boolean
		{
			var node:LinkedNode = new LinkedNode(obj);
			if (_size == 0)
			{
				_head = node;
				_tail = node;
				node.next = null;
				_size++
				return true;
			}
			
			_tail.next = node;
			_tail = _tail.next;
			_size++;
			
			return true;
		}
		
		/**
		 * 
		 * */
		public function dequeue():*
		{
			if (_size == 0)
			{
				return null;
			}
			
			var node:LinkedNode = _head;
			_head = _head.next;
			--_size;
			
			// 这样不会有问题吧 
			return node.data;
		}
		
		/**
		 * 
		 * */
		public function peek():*
		{
			if (_size == 0)
			{
				return null;
			}
			
			return _head.data;
		}
	}
}