// ActionScript file
package modulefight.netmsg.stmsg
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stJinnang 
	{
		public var id:uint;
		public var num:uint;		
		
		public function deserialize(byte:ByteArray):void
		{
			id = byte.readUnsignedInt();
			num = byte.readUnsignedByte();
			var singleDigit:int = id % 10;
			if (singleDigit > 1)
			{
				num = singleDigit;
				id = Math.floor(id / 10) * 10 + 1;
			}
			
		}
	}
}