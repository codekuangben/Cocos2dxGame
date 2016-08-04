package modulecommon.net.msg.sceneUserCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	public class t_ItemData 
	{
		public var type:uint;
		public var value:uint;
		public function t_ItemData() 
		{
			
		}
		public function deserialize(byte:ByteArray):void
		{
			type = byte.readUnsignedByte();
			value = byte.readUnsignedInt();
		}
		
		public static function readWidthNum(byte:ByteArray, num:uint):Dictionary
		{
			var ret:Dictionary = new Dictionary();
			
			var i:int = 0;
			var lkey:uint;
			var lvalue:uint;
			
			while (i < num)
			{
				lkey = byte.readUnsignedByte();
				lvalue = byte.readUnsignedInt();
				ret[lkey] = lvalue;				
				i++;
			}
			return ret;
		}
		
		public static function readWidthNum_Vector(byte:ByteArray, num:uint):Vector.<t_ItemData>
		{
			var ret:Vector.<t_ItemData> = new Vector.<t_ItemData>(num);
			
			var i:int = 0;
			var data:t_ItemData;
			
			while (i < num)
			{
				data = new t_ItemData();
				data.deserialize(byte);
				ret[i] = data;				
				i++;
			}
			return ret;
		}
		public static function readWidthNum_Array(byte:ByteArray, num:uint):Array
		{
			var ret:Array = new Array();
			
			var i:int = 0;
			var data:t_ItemData;
			
			while (i < num)
			{
				data = new t_ItemData();
				data.deserialize(byte);
				ret.push(data);	
				i++;
			}
			return ret;
		}
		public static function read(byte:ByteArray):Dictionary
		{
			var num:int = byte.readUnsignedShort();
			return readWidthNum(byte, num);
		}
		
	}

}

/*
 * struct t_ItemData
    {   
        BYTE type;
        DWORD value;
    };
*/