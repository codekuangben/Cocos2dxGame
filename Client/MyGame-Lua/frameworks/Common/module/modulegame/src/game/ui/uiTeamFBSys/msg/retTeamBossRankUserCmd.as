package game.ui.uiTeamFBSys.msg
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;

	public class retTeamBossRankUserCmd extends stCopyUserCmd
	{
		public var size:uint;
		public var m_lst:Array;
		
		public function retTeamBossRankUserCmd()
		{
			super();
			byParam = stCopyUserCmd.RET_TEAM_BOSS_RANK_USERCMD;;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			size = byte.readUnsignedShort();
			
			m_lst = [];
			var item:Item;
			
			var idx:int = 0;
			while(idx < size)
			{
				item = new Item();
				item.deserialize(byte);
				item.rank = idx + 1;
				m_lst[m_lst.length] = item;
				
				++idx;
			}
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
//		WORD guan;
//	} data[0];
//	WORD  getSize( void ) const { return sizeof(Item)*size; }
//};