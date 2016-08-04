package modulecommon.scene.prop.relation 
{
	//import modulecommon.net.msg.sceneUserCmd.t_ItemData;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class KejiLearnedItem 
	{	
		public var m_type:int;
		public var m_value:int;
		
		public function deserialize(byte:ByteArray):void
		{
			m_type = byte.readUnsignedByte();
			m_value = byte.readUnsignedInt();
		}
		public static function readWidthNum_Array(byte:ByteArray, num:uint):Array
		{
			var ret:Array = new Array();
			
			var i:int = 0;
			var data:KejiLearnedItem;
			
			while (i < num)
			{
				data = new KejiLearnedItem();
				data.deserialize(byte);
				ret.push(data);	
				i++;
			}
			return ret;
		}
	}

}