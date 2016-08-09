package modulecommon.net.msg.rankcmd
{
	import flash.utils.ByteArray;

	/**
	 * @author ...
	 */
	public class stRetCorpsCombatPowerRankListUserCmd extends stRankCmd
	{
		public var size:uint;
		public var rank:uint;
		public var zhanli:uint;
		public var data:Array;
		
		public function stRetCorpsCombatPowerRankListUserCmd()
		{
			super();
			byParam = stRankCmd.RET_CORPS_COMBAT_POWER_RANK_LIST_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			data = [];
			var item:CorpsCombatPowerRankItem;
			
			size = byte.readUnsignedShort();
			rank = byte.readUnsignedShort();
			zhanli = byte.readUnsignedInt();

			var idx:uint = 0;
			while (idx < size)
			{
				item = new CorpsCombatPowerRankItem();
				item.deserialize(byte);
				item.mNo = idx + 1;		// 序号从 1 开始
				data[data.length] = item;
				++idx;
			}
		}
	}
}

//返回军团战力排行榜 s->c
//const BYTE RET_CORPS_COMBAT_POWER_RANK_LIST_USERCMD = 2;
//struct stRetCorpsCombatPowerRankListUserCmd : public stRankCmd
//{   
	//stRetCorpsCombatPowerRankListUserCmd()
	//{   
		//byParam = RET_CORPS_COMBAT_POWER_RANK_LIST_USERCMD;
	//}   
	//WORD size;
	//WORD rank;
	//DWORD zhanli;
	//CorpsCombatPowerRankItem data[0];
	//WORD getSize( void ) const { return sizeof(*this) + sizeof(CorpsCombatPowerRankItem)*size; }
//};