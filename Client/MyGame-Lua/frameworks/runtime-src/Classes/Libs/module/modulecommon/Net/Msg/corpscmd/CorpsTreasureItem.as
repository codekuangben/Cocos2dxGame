package modulecommon.net.msg.corpscmd 
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	/**
	 * 军团夺宝夺宝榜单一队伍信息
	 * @author 
	 */
	public class CorpsTreasureItem 
	{
		/**
		 * 军团名称
		 */
		public var m_corpsname:String;
		/**
		 * 军团战斗胜利次数 按此排名
		 */
		public var m_winNum:uint;
		/**
		 * 获得宝箱数
		 */
		public var m_boxNum:uint;
		public function CorpsTreasureItem() 
		{
			
		}
		/**
		 * 解析消息
		 * @param	byte
		 */
		public function deserialize(byte:ByteArray):void
		{
			m_corpsname = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			m_winNum = byte.readUnsignedShort();
			m_boxNum = byte.readUnsignedShort();
		}
	}

}/*struct CorpsTreasureItem {
        char corpsname[MAX_NAMESIZE];
        WORD winNum;
        WORD boxNum;
    };   
*/