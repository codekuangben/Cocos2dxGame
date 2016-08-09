package modulecommon.net.msg.corpscmd 
{
	import flash.utils.ByteArray;
	/**
	 * 更新夺宝榜上榜单信息的消息
	 * @author 
	 */
	public class updateCorpsTreasureRankUserCmd extends stCorpsCmd 
	{
		/**
		 * 夺宝榜所有队伍信息
		 */
		public var m_CorpsTreasureItemList:Array;
		public function updateCorpsTreasureRankUserCmd() 
		{
			super();
			byParam = CORPS_TREASURE_UI_DATA_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			var size:uint = byte.readUnsignedByte();
			for (var i:int = 0; i < size; i++ )
			{
				var item:CorpsTreasureItem = new CorpsTreasureItem()
				item.deserialize(byte);
				m_CorpsTreasureItemList.push(item);
			}
		}
		
	}

}/* const BYTE UPDATE_CORPS_TREASURE_RANK_USERCMD = 113; 
    struct updateCorpsTreasureRankUserCmd : public stCorpsCmd
    {    
        updateCorpsTreasureRankUserCmd()
        {    
            byParam = CORPS_TREASURE_UI_DATA_USERCMD;
            size = 0;
        }
        BYTE size;
        CorpsTreasureItem data[0];
        WORD getSize() { return sizeof(*this) + size*sizeof(CorpsTreasureItem); }
    };
*/