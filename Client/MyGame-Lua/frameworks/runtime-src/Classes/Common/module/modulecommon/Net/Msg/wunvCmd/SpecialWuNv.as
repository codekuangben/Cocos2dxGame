package modulecommon.net.msg.wunvCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.scene.tongquetai.MysteryDancer;
	/**
	 * ...
	 * @author ...
	 */
	public class SpecialWuNv 
	{
		public var m_dancer:MysteryDancer;
		public var id:uint;
		public var num:int;
		
		public function deserialize(byte:ByteArray):void
		{
			id = byte.readUnsignedInt();
			num = byte.readUnsignedShort();
		}
		
	}

}
/*	struct SpecialWuNv {
		DWORD id;
		WORD size;
	};*/