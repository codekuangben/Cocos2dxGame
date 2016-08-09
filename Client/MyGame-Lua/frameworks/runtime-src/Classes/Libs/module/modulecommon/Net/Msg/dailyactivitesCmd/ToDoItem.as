package modulecommon.net.msg.dailyactivitesCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class ToDoItem 
	{
		public var id:uint;
		public var count:uint;
		
		public function ToDoItem() 
		{
			id = 0;
			count = 0;
		}
		
		public function deserialize(byte:ByteArray):void
		{
			id = byte.readUnsignedShort();
			count = byte.readUnsignedByte();
		}
	}

}

/*
	struct ToDoItem
	{
		WORD id; //配置的id
		BYTE count; //做了几次
	};
*/