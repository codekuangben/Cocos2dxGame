package modulecommon.net.msg.rankcmd
{
	import flash.utils.ByteArray;
	/**
	 * @author ...
	 */
	public class stRetCorpsLevelRankListUserCmd extends stRankCmd
	{
		public var size:uint;
		public var rank:uint;
		public var level:uint;
		public var data:Array;
		
		public function stRetCorpsLevelRankListUserCmd() 
		{
			super();
			byParam = stRankCmd.RET_CORPS_LEVEL_RANK_LIST_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			data = [];
			var item:CorpsLevelRankItem;
			
			size = byte.readUnsignedShort();
			rank = byte.readUnsignedShort();
			level = byte.readUnsignedByte();

			var idx:uint = 0;
			while (idx < size)
			{
				item = new CorpsLevelRankItem();
				item.deserialize(byte);
				item.mNo = idx + 1;		// 序号从 1 开始
				data[data.length] = item;
				++idx;
			}
		}
	}
}

//返回军团等级排行榜 s->c
//const BYTE RET_CORPS_LEVEL_RANK_LIST_USERCMD = 2;
//struct stRetCorpsLevelRankListUserCmd : public stRankCmd
//{   
	//stRetCorpsLevelRankListUserCmd()
	//{   
		//byParam = RET_CORPS_LEVEL_RANK_LIST_USERCMD;
	//}   
	//WORD size;
	//WORD rank;
	//BYTE level;
	//CorpsLevelRankItem data[0];
	//WORD getSize( void ) const { return sizeof(*this) + sizeof(CorpsLevelRankItem)*size; }
//};