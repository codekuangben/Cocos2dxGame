package datast 
{
	/**
	 * ...
	 * @author ...
	 */
	public interface IQueue 
	{
		/**
		 * 
		 * */
		function enqueue(obj:*):Boolean;
		
		/**
		 * 
		 * */
		function dequeue():*;
		
		/**
		 * 
		 * */
		function peek():*;
	}
}