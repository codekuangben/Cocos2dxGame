package modulecommon.net.msg.corpscmd 
{
	import flash.utils.ByteArray;
	/**
	 * 军团夺宝军粮更新消息
	 * @author 
	 */
	public class updateCorpsTreasureJunLiangDataUserCmd extends stCorpsCmd 
	{
		/**
		 * 军粮数量
		 */
		public var m_junliang:uint;
		public function updateCorpsTreasureJunLiangDataUserCmd() 
		{
			super();
			byParam = UPDATE_CORPS_TREASURE_JUNLIANG_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_junliang = byte.readUnsignedInt();
		}
		
	}

}/*const BYTE UPDATE_CORPS_TREASURE_JUNLIANG_USERCMD = 112; 
    struct updateCorpsTreasureJunLiangDataUserCmd : public stCorpsCmd
    {    
        updateCorpsTreasureJunLiangDataUserCmd()
        {    
            byParam = UPDATE_CORPS_TREASURE_JUNLIANG_USERCMD;
            junliang = 0; 
        }    
        DWORD junliang; //已获得军粮数量
    };   
*/