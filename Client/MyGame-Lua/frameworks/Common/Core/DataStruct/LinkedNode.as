package datast 
{
	/**
	 * ...
	 * @author ...
	 */
	public class LinkedNode 
	{
		/**
		 * 
		 * */
		public var data:*;
		public var next:LinkedNode;
		
		/**
		 * 
		 * */
		public function LinkedNode(data:* = null) 
		{
			this.data = data;
			next = null;
		}
		
	}

}