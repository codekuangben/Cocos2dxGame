package game.ui.tongquetai.msg 
{
	import flash.utils.ByteArray;
	import modulecommon.scene.tongquetai.DancerBase;
	/**
	 * ...
	 * @author ...
	 */
	public class FriendDancingWuNv 
	{
		public var id:uint;
		public var tempid:uint;
		public var time:uint;
		public var pos:uint;
		public var state:uint;
		public var dancerBase:DancerBase;
		
		public function deserialize(byte:ByteArray):void
		{
			id = byte.readUnsignedInt();
			tempid = byte.readUnsignedInt();
			time = byte.readUnsignedInt();
			pos = byte.readUnsignedByte();
			state = byte.readUnsignedByte();
		}
		
	}

}
/*	struct FriendDancingWuNv {
		DWORD id; //舞女id
		DWORD tempid, //舞女临时id
		DWORD time; //剩余时间
		BYTE pos;  //0开始,从左到右  INVALID_INDEX = 3
		BYTE state;//参考配置文件girl_state节点 //按位，第6位为 1：成熟，反之未成熟 第7位为1：可偷反之不可。
	};*/