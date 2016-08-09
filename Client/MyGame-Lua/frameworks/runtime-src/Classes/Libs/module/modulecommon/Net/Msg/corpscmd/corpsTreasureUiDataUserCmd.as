package modulecommon.net.msg.corpscmd 
{
	import flash.utils.ByteArray;
	/**
	 * 军团夺宝界面信息
	 * @author 
	 */
	public class corpsTreasureUiDataUserCmd extends stCorpsCmd 
	{
		/**
		 * 剩余时间
		 */
		public var m_time:uint;
		/**
		 * 已获得军粮数量
		 */
		public var m_junliang:uint;
		/**
		 * 夺宝榜所有队伍信息
		 */
		public var m_CorpsTreasureItemList:Array;
		public function corpsTreasureUiDataUserCmd() 
		{
			super();
			byParam = CORPS_TREASURE_UI_DATA_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_time = byte.readUnsignedInt();
			m_junliang = byte.readUnsignedInt();
			var size:uint = byte.readUnsignedByte();
			for (var i:int = 0; i < size; i++ )
			{
				var item:CorpsTreasureItem = new CorpsTreasureItem()
				item.deserialize(byte);
				m_CorpsTreasureItemList.push(item);
			}
		}
		
	}

}/*   // 界面信息s->c
    const BYTE CORPS_TREASURE_UI_DATA_USERCMD = 111; 
    struct corpsTreasureUiDataUserCmd : public stCorpsCmd
    {    
        corpsTreasureUiDataUserCmd()
        {    
            byParam = CORPS_TREASURE_UI_DATA_USERCMD;
            time = junliang = 0; 
            lastFreeReliveTime = size = 0; 
        }    
        DWORD time; //剩余时间
        DWORD junliang; //已获得军粮数量        
        BYTE size;
        CorpsTreasureItem data[0];
    };   
*/