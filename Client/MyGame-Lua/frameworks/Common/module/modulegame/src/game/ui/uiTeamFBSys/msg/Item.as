package game.ui.uiTeamFBSys.msg
{
	import flash.utils.ByteArray;
	
	import common.net.endata.EnNet;

	public class Item
	{
		public var name:String;
		public var guan:uint;
		public var rank:uint;				// 这个是客户端自己添加的等级
		
		public function deserialize(byte:ByteArray):void
		{
			name = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			guan = byte.readUnsignedShort();
		}
	}
}

//返回组队闯关排行榜
//const BYTE RET_TEAM_BOSS_RANK_USERCMD = 64;
//struct retTeamBossRankUserCmd: public stCopyUserCmd
//{
//	retTeamBossRankUserCmd()
//	{
//		byParam = RET_TEAM_BOSS_RANK_USERCMD;
//	}
//	WORD size;
//	struct Item {
//		char name[MAX_NAMESIZE];
//		WORD guan;	// 第几关
//	} data[0];
//	WORD  getSize( void ) const { return sizeof(Item)*size; }
//};