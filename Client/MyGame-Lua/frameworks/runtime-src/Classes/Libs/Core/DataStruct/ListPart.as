package datast 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	public class ListPart 
	{
		public var m_list:Array;
		public function ListPart() 
		{
			m_list = new Array();
		}
		
		public function deserialize(byte:ByteArray, elementClass:Class, byteOfSize=1):void
		{
			var size:int;
			if (byteOfSize == 1)
			{
				size = byte.readUnsignedByte();
			}
			else if (byteOfSize == 2)
			{
				size = byte.readUnsignedShort();
			}
			var i:int;
			var ele:Object;
			for (i = 0; i < size; i++)
			{
				ele = new elementClass();
				ele.deserialize(byte);
				m_list.push(ele);
			}
		}
	}

}