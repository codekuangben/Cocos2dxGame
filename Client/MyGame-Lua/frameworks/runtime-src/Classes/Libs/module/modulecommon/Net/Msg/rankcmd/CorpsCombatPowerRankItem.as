package modulecommon.net.msg.rankcmd
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	/**
	 * ...
	 * @author ...
	 */
	public class CorpsCombatPowerRankItem
	{
		public var id:uint;
		public var name:String;
		public var tuanzhang:String;
		public var combatpower:uint;
		
		public var mNo:uint;		// 客户端自己使用序号

		public function deserialize(byte:ByteArray):void 
		{
			id = byte.readUnsignedInt();
			name = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			tuanzhang = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			combatpower = byte.readUnsignedInt();
		}
	}
}

//struct CorpsCombatPowerRankItem {
	//DWORD id;
	//char name[MAX_NAMESIZE];
	//char tuanzhang[MAX_NAMESIZE];
	//DWORD combatpower;
//};