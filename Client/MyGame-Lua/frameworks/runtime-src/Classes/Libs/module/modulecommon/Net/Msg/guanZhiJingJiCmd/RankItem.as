package modulecommon.net.msg.guanZhiJingJiCmd 
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	import com.util.UtilTools;
	/**
	 * ...
	 * @author 
	 */
	public class RankItem 
	{
		public var rank:uint;
		public var name:String;
		public var score:uint;
		
		public function deserialize(byte:ByteArray):void
		{
			rank = byte.readUnsignedInt();
			name = UtilTools.readStr(byte, EnNet.MAX_NAMESIZE);
			score = byte.readUnsignedInt();
		}
		
	}

}

/*
	struct RankItem
	{
		DWORD rank;
		char name[MAX_NAMESIZE]; 
		DWORD score;
	};
*/