package modulecommon.net.msg.wunvCmd 
{
	import common.net.endata.EnNet
	import flash.utils.ByteArray;
	import modulecommon.scene.tongquetai.DancerBase;
	import modulecommon.time.Daojishi;
	/**
	 * ...
	 * @author ...
	 * 自己的正在跳舞舞女
	 */
	public class DancingWuNvMsg
	{
		
		public var id:uint;
		public var tempid:uint;
		public var time:uint;	//剩余时间		
		public var pos:uint;	
		public var stolenList:Array;
		public function deserialize(byte:ByteArray):void
		{
			id = byte.readUnsignedInt();
			tempid = byte.readUnsignedInt();
			time = byte.readUnsignedInt();
			pos = byte.readUnsignedByte();
			stolenList = new Array();
			var num:uint = byte.readUnsignedByte();
			for (var i:uint = 0; i < num; i++ )
			{
				var item:Object = new Object();
				item.m_name = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
				stolenList.push(item);
			}
		}
		
	}

}
/*	struct DancingWuNv {
		DWORD id;
		DWORD tempid; //舞女临时id
		DWORD time; //剩余时间
		BYTE pos;  //0开始,从左到右  INVALID_INDEX = 3
        BYTE size;//名字个数
        char name[0];//被偷名字 第一个10%二三5% 每个name最大长度
	};*/